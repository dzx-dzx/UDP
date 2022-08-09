package udp_master_stream

import spinal.core._
import spinal.lib._

case class EthernetRxGenerics(
    destIp: Long,  // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int  // Destination port 16bit
)

object StreamExtractCompany {
  def apply[Tpay <: Data, Tcomp <: Data](
      inputStream: Stream[Tpay],
      companyExtractFunc: Stream[Tpay] => Flow[Tcomp]
  ): Stream[TupleBundle2[Tpay, Tcomp]] =
    new Composite(inputStream, "StreamExtractCompany") {
      val companyFlow = companyExtractFunc(inputStream)
      // Data register, no need to reset
      val companyReg = Reg(companyFlow.payloadType)

      val outputStream = inputStream.translateWith {
        val result =
          TupleBundle2(inputStream.payloadType, companyFlow.payloadType)
        result._1 := inputStream.payload
        when(companyFlow.valid) {
          result._2  := companyFlow.payload
          companyReg := companyFlow.payload
        } otherwise {
          result._2 := companyReg
        }
        result
      }
    }.outputStream
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetProtocolConstant.UDP_CHECKSUM_WIDTH bits)
  val udpLength   = Bits(EthernetProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort    = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val srcPort     = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val destIp      = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val srcIp       = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val headerCheckSum = Bits(
    EthernetProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val identification = Bits(
    EthernetProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val totalLength = Bits(EthernetProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val tos         = Bits(EthernetProtocolConstant.TOS_WIDTH bits)
  val versionIhl  = Bits(EthernetProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType     = Bits(EthernetProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac      = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val destMac     = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataEth() extends Bundle {
  val eth   = EthernetHeadRx()
  val input = Fragment(EthernetRxDataIn())
}

case class EthernetRxDataIn() extends Bundle {
  val data  = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data  = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)

  val byteNum   = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)
  val errorCnt  = UInt(EthernetUserConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics) extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val companyExtractFunc = (inputStream: Stream[Fragment[EthernetRxDataIn]]) =>
    new Composite(inputStream, "RespVerifier_companyExtractFunc") {
      val result = Flow(EthernetRxDataIn())
      result.payload := io.dataIn.payload
      when(inputStream.first) {
        result.valid := inputStream.fire
      } otherwise {
        result.valid := False
      }
    }.result
  // 提取包头数据并维持在处理整个包时有效, 直到下一个包头.

  val dataInExtractCompany = StreamExtractCompany(io.dataIn, companyExtractFunc)

  val (dataInExtractCompany1, dataInExtractCompany2) = StreamFork2(
    dataInExtractCompany
  )

  val inputData = Stream(Fragment(EthernetRxDataIn()))
  val inputEth  = Stream(EthernetHeadRx())

  inputData << dataInExtractCompany1.translateWith {
    val ret = Fragment(EthernetRxDataIn())
    ret.tkeep := dataInExtractCompany._1.tkeep
    ret.data  := dataInExtractCompany._1.data
    ret.last  := dataInExtractCompany._1.last
    ret
  }

  inputEth << dataInExtractCompany2.translateWith {
    val ret = EthernetHeadRx()
    ret.assignFromBits(
      dataInExtractCompany._2.data(
        EthernetUserConstant.DATA_WIDTH - 1 downto EthernetUserConstant.DATA_WIDTH -
          EthernetProtocolConstant.BYTE_WIDTH * EthernetProtocolConstant.ETH_TOTAL_LENGTH
      )
    )
    ret
  }

  def EthMacCheck(
      tkeep: Bits,
      eth: EthernetHeadRx
  ): Bool = {
    val fit = {
      ~(tkeep(
        EthernetUserConstant.KEEP_WIDTH - 1 downto EthernetUserConstant.KEEP_WIDTH - EthernetProtocolConstant.ETH_TOTAL_LENGTH
      ) === B(
        EthernetProtocolConstant.ETH_TOTAL_LENGTH bits,
        default -> True
      ) & (eth.preambleSdf === EthernetProtocolConstant.PREAMBLE_SDF) && ((eth.destMac === ethernetRxGenerics.destMac) || (eth.destMac === EthernetProtocolConstant.BROADCAST_MAC_ADDRESS)) && (eth.ethType === EthernetProtocolConstant.ETH_TYPE))
    }
    fit
  }

  def EthIpCheck(
      eth: EthernetHeadRx
  ): Bool = {
    val fit = ~((eth.ttlProtocol(
      (EthernetProtocolConstant.TTL_PROTOCOL_WIDTH / 2 - 1) downto 0
    ) === EthernetProtocolConstant.PROTOCOL) && (eth.destIp === ethernetRxGenerics.destIp))
    fit
  }

  def EthUdpCheck(
      eth: EthernetHeadRx
  ): Bool = {
    val fit = ~(eth.destPort === ethernetRxGenerics.destPort)
    fit
  }

  val eth = StreamJoin
    .arg(inputData, inputEth)
    .translateWith {
      val ret = EthernetRxDataEth()
      ret.input.tkeep := inputData.tkeep
      ret.input.data  := inputData.data
      ret.input.last  := inputData.last
      ret.eth         := inputEth.payload // 包传递完成前保持不变.
      ret
    }

  val ethMacCheck = Stream(EthernetRxDataEth())
  ethMacCheck <-/< eth.throwWhen(
    EthMacCheck(ethMacCheck.input.tkeep, ethMacCheck.eth)
  )

  val ethIpCheck = Stream(EthernetRxDataEth())
  ethIpCheck <-/< ethMacCheck.throwWhen(
    EthIpCheck(ethIpCheck.eth)
  )

  val ethUdpCheck = Stream(EthernetRxDataEth())
  ethUdpCheck <-/< ethIpCheck.throwWhen(
    EthUdpCheck(ethUdpCheck.eth)
  )
  // 校验包头各部分.

  io.dataOut <-/< ethUdpCheck.translateWith {
    val ret = Fragment(EthernetRxDataOut())
    ret.tkeep     := ethUdpCheck.input.tkeep
    ret.data      := ethUdpCheck.input.data
    ret.byteNum   := ethUdpCheck.eth.udpLength.asUInt - EthernetProtocolConstant.UDP_ETH_LENGTH
    ret.last      := ethUdpCheck.input.last
    ret.errorCnt  := 0
    ret.errorFlag := False
    ret
  }

}
