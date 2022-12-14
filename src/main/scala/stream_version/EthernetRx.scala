package udp_master_stream

import spinal.core._
import spinal.lib._
import EthernetUserConstant._
import EthernetProtocolConstant._

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

case class EthernetRxDataEth() extends Bundle {
  val eth   = Header()
  val input = Fragment(EthernetRxDataIn())
}

case class EthernetRxDataIn() extends Bundle {
  val data  = Bits(DATA_WIDTH bits)
  val tkeep = Bits(KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(DATA_WIDTH bits)
//  val byteNum = UInt(BYTE_NUM_WIDTH bits)
  val tkeep = Bits(KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
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
      result.valid   := inputStream.isFirst
    }.result
  // ??????????????????????????????????????????????????????, ?????????????????????.

  val dataInExtractCompany = StreamExtractCompany(io.dataIn, companyExtractFunc)
    .throwWhen(io.dataIn.first)

  val eth = dataInExtractCompany
    .translateWith {
      val ret = EthernetRxDataEth()
      ret.input.tkeep := dataInExtractCompany._1.tkeep
      ret.input.data  := dataInExtractCompany._1.data
      ret.input.last  := dataInExtractCompany._1.last
      ret.eth.set(
        dataInExtractCompany._2.data(
          DATA_WIDTH - 1 downto DATA_WIDTH - BYTE_WIDTH * ETH_TOTAL_LENGTH
        )
      ) // ??????????????????????????????.
      ret
    }

  def EthIpCheck(ip: IPHeader): Bool = ~(
    ip.ttlProtocol((TTL_PROTOCOL_WIDTH / 2 - 1) downto 0) === PROTOCOL
      && (ip.destIp === ethernetRxGenerics.destIp)
  )

  def EthUdpCheck(udp: UDPHeader): Bool =
    ~(udp.destPort === ethernetRxGenerics.destPort)
  // ?????????????????????.

  def EthMacCheck(tkeep: Bits, mac: MacHeader): Bool = ~(
    tkeep(KEEP_WIDTH - 1 downto KEEP_WIDTH - ETH_TOTAL_LENGTH) === B(
      ETH_TOTAL_LENGTH bits,
      default -> True
    )
      && (mac.preambleSdf === PREAMBLE_SDF)
      && ((mac.destMac === ethernetRxGenerics.destMac) || (mac.destMac === BROADCAST_MAC_ADDRESS))
      && (mac.ethType === ETH_TYPE)
  )

  val ethCheck = Stream(EthernetRxDataEth())
  ethCheck <-/< eth

  io.dataOut <-/< ((ethCheck
    .throwWhen {
      // report(L"At $REPORT_TIME, while processing ${ethCheck.payload.input.data} EthMacCheck:${EthMacCheck(
      //   ethCheck.input.tkeep,
      //   ethCheck.eth.mac
      // )} EthIpCheck:${EthIpCheck(ethCheck.eth.ip)} EthUdpCheck:${EthUdpCheck(ethCheck.eth.udp)}".toSeq)
      EthMacCheck(ethCheck.input.tkeep, ethCheck.eth.mac) ||
      EthIpCheck(ethCheck.eth.ip) ||
      EthUdpCheck(ethCheck.eth.udp)
    })
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := ethCheck.input.tkeep
      ret.data  := ethCheck.input.data
//    ret.byteNum := ethCheck.eth.udpLength.asUInt - UDP_ETH_LENGTH
      ret.last := ethCheck.input.last
      ret
    })
}
