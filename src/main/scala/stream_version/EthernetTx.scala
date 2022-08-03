package udp_master_stream

import spinal.core._
import spinal.lib._

import EthernetProtocolConstant._

case class EthernetTxGenerics(
    destIp: Long,  // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int, // Destination port 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)

case class EthernetTxDataIn() extends Bundle {
  val data    = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)
  val tkeep   = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetTxDataOut() extends Bundle {
  val data  = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetTx(ethernetTxGenerics: EthernetTxGenerics) extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetTxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetTxDataOut()))
  }

  val identificationCnt =
    Counter(IDENTIFICATION_WIDTH bits)

  when(io.dataOut.fire & io.dataOut.last) {
    identificationCnt.increment()
  }

  val realTxDataNum = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)

  when(io.dataIn.byteNum >= MIN_DATA_NUM) {
    realTxDataNum := io.dataIn.byteNum
  } otherwise {
    realTxDataNum := MIN_DATA_NUM
  }

  val (inputStream1, inputStream2) = StreamFork2(io.dataIn)
  // 前一个计算checksum, 后一个传输数据.
  // 是否有可能有别的写法?

  val checkSumStage1 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkSumStage2 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkSumStage3 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))

  val ethReg = EthernetHeadTx()
  // Mac
  ethReg.preambleSdf := PREAMBLE_SDF
  ethReg.destMac     := ethernetTxGenerics.destMac
  ethReg.srcMac      := ethernetTxGenerics.srcMac
  ethReg.ethType     := ETH_TYPE
  // IP
  ethReg.versionIhl  := VERSION_IHL
  ethReg.tos         := TOS
  ethReg.totalLength := realTxDataNum + IP_ETH_LENGTH + UDP_ETH_LENGTH // 输入数据加上Mac与IP层的头
  ethReg.identification      := identificationCnt // "usually incremented by 1 each time a message is sent."
  ethReg.flagsFragmentOffset := FLAGS_FRAGMENT_OFFSET
  ethReg.ttlProtocol         := TTL_PROTOCOL
  ethReg.headerCheckSum := checkSumStage3.payload(
    EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
  )
  ethReg.srcIp  := ethernetTxGenerics.srcIp
  ethReg.destIp := ethernetTxGenerics.destIp
  // UDP
  ethReg.srcPort     := ethernetTxGenerics.srcPort
  ethReg.destPort    := ethernetTxGenerics.destPort
  ethReg.udpLength   := (realTxDataNum + UDP_ETH_LENGTH).asBits
  ethReg.udpCheckSum := U"16'x0000"

  val ipEth = Vec(
    (ethReg.versionIhl ## ethReg.tos).asUInt,
    ethReg.totalLength,
    ethReg.identification,
    ethReg.flagsFragmentOffset.asUInt,
    ethReg.ttlProtocol.asUInt,
    U"16'x0000",
    ethReg
      .srcIp(
        IP_WIDTH - 1 downto IP_WIDTH / 2
      )
      .asUInt,
    ethReg.srcIp(IP_WIDTH / 2 - 1 downto 0).asUInt,
    ethReg
      .destIp(
        IP_WIDTH - 1 downto IP_WIDTH / 2
      )
      .asUInt,
    ethReg.destIp(IP_WIDTH / 2 - 1 downto 0).asUInt
  ) // 提取IP头并按16bit对齐. subdivideIn应该是更好的写法.

  val checkSum4 = Stream(Fragment(EthernetTxDataOut()))
  // https://en.wikipedia.org/wiki/Internet_checksum
  checkSumStage1 <-/< inputStream1
    .translateWith(
      ipEth
        .reduceBalancedTree(_ +^ _)
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    ) // 将IP头各部分相加.

  checkSumStage2 <-/< checkSumStage1
    .translateWith(
      checkSumStage1.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage1
        .payload(
          EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
        )
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    ) // 取进位部分与低位相加. 反码进位(end-around borrow)规则. https://en.wikipedia.org/wiki/Ones%27_complement

  checkSumStage3 <-/< checkSumStage2
    .translateWith(
      ~((checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
      )).resize(EthernetUserConstant.CHECK_BUFFER_WIDTH))
    ) // 上一次操作可能产生进位, 因而再做一次反码进位. 之后取反.
  checkSum4 << checkSumStage3.translateWith {
    val ret = Fragment(EthernetTxDataOut())
    ret.data := ethReg.asBigEndianBitsTx
    ret.tkeep := B(
      (MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH) bits,
      default -> True
    ) ## B(
      (EthernetUserConstant.KEEP_WIDTH - (MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH)) bits,
      default -> False
    ) // 标记无效数据. https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/miscelenea/core/elements.html#element
    ret.last := False
    ret
  }

  val pipDataIn = Stream(Fragment(EthernetTxDataOut()))

  pipDataIn << inputStream2
    .translateWith {
      val ret = Fragment(EthernetTxDataOut())
      ret.data  := io.dataIn.data
      ret.tkeep := io.dataIn.tkeep
      ret.last  := io.dataIn.last
      ret
    }
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()

  val muxOut      = Stream(Fragment(EthernetTxDataOut()))
  val dataOutMux  = Vec(pipDataIn, checkSum4.throwWhen(~muxOut.first))
  val muxSelWidth = log2Up(dataOutMux.length)
  val muxSel      = UInt(muxSelWidth bits)

  when(muxOut.first /*fragment.first是一个reg*/ ) {
    muxSel := 1 // 输出头
  }.otherwise {
    muxSel := 0 // 输出数据
  }

  muxOut << StreamMux(muxSel, dataOutMux)
  io.dataOut <-/< muxOut
}
