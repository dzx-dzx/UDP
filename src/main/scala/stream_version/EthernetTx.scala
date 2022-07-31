package udp_master_stream

import spinal.core._
import spinal.lib._

case class EthernetTxGenerics(
    destIp: Long,  // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int, // Destination port 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)
object EthernetUserConstant {
  val DATA_WIDTH         = 512
  val KEEP_WIDTH         = 64
  val BYTE_NUM_WIDTH     = 16
  val CHECK_BUFFER_WIDTH = 32
}

object EthernetProtocolConstant {
  val MIN_DATA_NUM          = 18
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL

  val PREAMBLE        = 0x55555555555555L
  val SFD             = 0xd5   // Start Frame Delimiter
  val ETH_TYPE        = 0x0800 // 0x0800 represents the IP protocol
  val VERSION         = 0x4    // 0x4 represents IPv4
  val IHL             = 0x5    // Internet Header Length
  val TOS             = 0x00   // Type of service , 0x00 represents general service
  val FLAGS           = 0x2
  val FRAGMENT_OFFSET = 0x0
  val TTL             = 0x40   // Time to Live
  val PROTOCOL        = 0x11   // 0x11 represents UDP

  val BYTE_WIDTH                  = 8
  val MAC_ETH_LENGTH              = 22
  val IP_ETH_LENGTH               = 20
  val UDP_ETH_LENGTH              = 8
  val ETH_TOTAL_LENGTH            = MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH
  val PREAMBLE_SDF_WIDTH          = 64
  val PREAMBLE_SDF                = (PREAMBLE << 8) + SFD
  val MAC_WIDTH                   = 48
  val ETH_TYPE_WIDTH              = 16
  val VERSION_IHL                 = (VERSION << 4) + IHL
  val VERSION_IHL_WIDTH           = 8
  val TOS_WIDTH                   = 8
  val TOTAL_LENGTH_WIDTH          = 16
  val IDENTIFICATION_WIDTH        = 16
  val FLAGS_FRAGMENT_OFFSET       = (FLAGS << 13) + FRAGMENT_OFFSET
  val FLAGS_FRAGMENT_OFFSET_WIDTH = 16
  val TTL_PROTOCOL                = (TTL << 8) + PROTOCOL
  val TTL_PROTOCOL_WIDTH          = 16
  val HEADER_CHECKSUM_WIDTH       = 16
  val IP_WIDTH                    = 32
  val PORT_WIDTH                  = 16
  val UDP_LENGTH_WIDTH            = 16
  val UDP_CHECKSUM                = 16
}

case class EthernetHeadTx() extends Bundle {
  val preambleSdf = Bits(EthernetProtocolConstant.PREAMBLE_SDF_WIDTH bits)
  val destMac     = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val srcMac      = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val ethType     = Bits(EthernetProtocolConstant.ETH_TYPE_WIDTH bits)
  val versionIhl  = Bits(EthernetProtocolConstant.VERSION_IHL_WIDTH bits)
  val tos         = Bits(EthernetProtocolConstant.TOS_WIDTH bits)
  val totalLength = UInt(EthernetProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val identification = UInt(
    EthernetProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val flagsFragmentOffset = Bits(
    EthernetProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum = UInt(
    EthernetProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val srcIp       = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val destIp      = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val srcPort     = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val destPort    = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val udpLength   = Bits(EthernetProtocolConstant.UDP_LENGTH_WIDTH bits)
  val udpCheckSum = UInt(EthernetProtocolConstant.UDP_CHECKSUM bits)

  def asBigEndianBitsTx(
      preambleSdf: Bits,
      destMac: Bits,
      srcMac: Bits,
      ethType: Bits,
      versionIhl: Bits,
      tos: Bits,
      totalLength: UInt,
      identification: UInt,
      flagsFragmentOffset: Bits,
      ttlProtocol: Bits,
      headerCheckSum: UInt,
      srcIp: Bits,
      destIp: Bits,
      srcPort: Bits,
      destPort: Bits,
      udpLength: Bits,
      udpCheckSum: UInt
  ): Bits = {
    val ethernetHead =
      preambleSdf ## destMac ## srcMac ## ethType ## versionIhl ## tos ## totalLength.asBits ## identification.asBits ## flagsFragmentOffset ## ttlProtocol ## headerCheckSum.asBits ## srcIp ## destIp ## srcPort ## destPort ## udpLength ## udpCheckSum.asBits ## B"112'x0"
    ethernetHead
  }
}

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
    Counter(EthernetProtocolConstant.IDENTIFICATION_WIDTH bits)

  when(io.dataOut.fire & io.dataOut.last) {
    identificationCnt.increment()
  }

  val checkSumStage1 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkSumStage2 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkSumStage3 =
    Stream(UInt(EthernetUserConstant.CHECK_BUFFER_WIDTH bits))

  val checkSum4 = Stream(Fragment(EthernetTxDataOut()))

  val realTxDataNum = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)

  when(io.dataIn.byteNum >= EthernetProtocolConstant.MIN_DATA_NUM) {
    realTxDataNum := io.dataIn.byteNum
  } otherwise {
    realTxDataNum := EthernetProtocolConstant.MIN_DATA_NUM
  }

  val (inputStream1, inputStream2) = StreamFork2(io.dataIn)
  //前一个计算checksum, 后一个传输数据.
  //是否有可能有别的写法?

  val ethReg = EthernetHeadTx()
  //Mac
  ethReg.preambleSdf := EthernetProtocolConstant.PREAMBLE_SDF
  ethReg.destMac     := ethernetTxGenerics.destMac
  ethReg.srcMac      := ethernetTxGenerics.srcMac
  ethReg.ethType     := EthernetProtocolConstant.ETH_TYPE
  //IP
  ethReg.versionIhl  := EthernetProtocolConstant.VERSION_IHL
  ethReg.tos         := EthernetProtocolConstant.TOS
  ethReg.totalLength := realTxDataNum + EthernetProtocolConstant.IP_ETH_LENGTH + EthernetProtocolConstant.UDP_ETH_LENGTH//输入数据加上Mac与IP层的头
  ethReg.identification      := identificationCnt //"usually incremented by 1 each time a message is sent."
  ethReg.flagsFragmentOffset := EthernetProtocolConstant.FLAGS_FRAGMENT_OFFSET
  ethReg.ttlProtocol         := EthernetProtocolConstant.TTL_PROTOCOL
  ethReg.headerCheckSum := checkSumStage3.payload(
    EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
  )
  ethReg.srcIp       := ethernetTxGenerics.srcIp
  ethReg.destIp      := ethernetTxGenerics.destIp
  //UDP
  ethReg.srcPort     := ethernetTxGenerics.srcPort
  ethReg.destPort    := ethernetTxGenerics.destPort
  ethReg.udpLength   := (realTxDataNum + EthernetProtocolConstant.UDP_ETH_LENGTH).asBits
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
        EthernetProtocolConstant.IP_WIDTH - 1 downto EthernetProtocolConstant.IP_WIDTH / 2
      )
      .asUInt,
    ethReg.srcIp(EthernetProtocolConstant.IP_WIDTH / 2 - 1 downto 0).asUInt,
    ethReg
      .destIp(
        EthernetProtocolConstant.IP_WIDTH - 1 downto EthernetProtocolConstant.IP_WIDTH / 2
      )
      .asUInt,
    ethReg.destIp(EthernetProtocolConstant.IP_WIDTH / 2 - 1 downto 0).asUInt
  )//提取IP头并按16bit对齐. subdivideIn应该是更好的写法.

  // https://en.wikipedia.org/wiki/Internet_checksum
  checkSumStage1 <-/< inputStream1
    .translateWith(
      ipEth
        .reduceBalancedTree(_ +^ _)
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    )//将IP头各部分相加. 

  checkSumStage2 <-/< checkSumStage1
    .translateWith(
      checkSumStage1.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage1
        .payload(
          EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
        )
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    )//取进位部分与低位相加. 反码进位(end-around borrow)规则. https://en.wikipedia.org/wiki/Ones%27_complement

  checkSumStage3 <-/< checkSumStage2
    .translateWith(
      ~((checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
      )).resize(EthernetUserConstant.CHECK_BUFFER_WIDTH))
    )//上一次操作可能产生进位, 因而再做一次反码进位. 之后取反.

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

  checkSum4 << checkSumStage3.translateWith {
    val ret = Fragment(EthernetTxDataOut())
    ret.data := ethReg.asBigEndianBitsTx(
      ethReg.preambleSdf,
      ethReg.destMac,
      ethReg.srcMac,
      ethReg.ethType,
      ethReg.versionIhl,
      ethReg.tos,
      ethReg.totalLength,
      ethReg.identification,
      ethReg.flagsFragmentOffset,
      ethReg.ttlProtocol,
      ethReg.headerCheckSum,
      ethReg.srcIp,
      ethReg.destIp,
      ethReg.srcPort,
      ethReg.destPort,
      ethReg.udpLength,
      ethReg.udpCheckSum
    )
    ret.tkeep := B(
      (EthernetProtocolConstant.MAC_ETH_LENGTH + EthernetProtocolConstant.IP_ETH_LENGTH + EthernetProtocolConstant.UDP_ETH_LENGTH) bits,
      default -> True
    ) ## B(
      (EthernetUserConstant.KEEP_WIDTH - (EthernetProtocolConstant.MAC_ETH_LENGTH + EthernetProtocolConstant.IP_ETH_LENGTH + EthernetProtocolConstant.UDP_ETH_LENGTH)) bits,
      default -> False
    )// 标记无效数据. https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/miscelenea/core/elements.html#element
    ret.last := False
    ret
  }

  val muxOut      = Stream(Fragment(EthernetTxDataOut()))
  val dataOutMux  = Vec(pipDataIn, checkSum4.throwWhen(~muxOut.first))
  val muxSelWidth = log2Up(dataOutMux.length)
  val muxSel      = UInt(muxSelWidth bits)

  when(muxOut.first/*fragment.first是一个reg*/) {
    muxSel := 1//输出头
  }.otherwise {
    muxSel := 0//输出数据
  }

  muxOut << StreamMux(muxSel, dataOutMux)
  io.dataOut <-/< muxOut
}
