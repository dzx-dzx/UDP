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
  val inputEth  = Stream(Header())

  inputData << dataInExtractCompany1.translateWith {
    val ret = Fragment(EthernetRxDataIn())
    ret.tkeep := dataInExtractCompany._1.tkeep
    ret.data  := dataInExtractCompany._1.data
    ret.last  := dataInExtractCompany._1.last
    ret
  }

  inputEth << dataInExtractCompany2.translateWith {
    val ret = Header()
    ret.set(
      dataInExtractCompany._2.data(DATA_WIDTH - 1 downto DATA_WIDTH - BYTE_WIDTH * ETH_TOTAL_LENGTH)
    )
    ret
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

  def EthMacCheck(tkeep: Bits, mac: MacHeader): Bool = ~(
    tkeep(KEEP_WIDTH - 1 downto KEEP_WIDTH - ETH_TOTAL_LENGTH) === B(ETH_TOTAL_LENGTH bits, default -> True)
      && (mac.preambleSdf === PREAMBLE_SDF)
      && ((mac.destMac === ethernetRxGenerics.destMac) || (mac.destMac === BROADCAST_MAC_ADDRESS))
      && (mac.ethType === ETH_TYPE)
  )

  def EthIpCheck(ip: IPHeader): Bool = ~(
    ip.ttlProtocol((TTL_PROTOCOL_WIDTH / 2 - 1) downto 0) === PROTOCOL
      && (ip.destIp === ethernetRxGenerics.destIp)
  )

  def EthUdpCheck(udp: UDPHeader): Bool = ~(udp.destPort === ethernetRxGenerics.destPort)
  // 校验包头各部分.

  val ethMacCheck = Stream(EthernetRxDataEth())
  ethMacCheck <-/< eth.throwWhen {
    EthMacCheck(ethMacCheck.input.tkeep, ethMacCheck.eth.mac)
  }

  val ethIpCheck = Stream(EthernetRxDataEth())
  ethIpCheck <-/< ethMacCheck.throwWhen(
    EthIpCheck(ethIpCheck.eth.ip)
  )

  val ethUdpCheck = Stream(EthernetRxDataEth())
  ethUdpCheck <-/< ethIpCheck.throwWhen(
    EthUdpCheck(ethUdpCheck.eth.udp)
  )

  io.dataOut <-/< ethUdpCheck.translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := ethUdpCheck.input.tkeep
      ret.data  := ethUdpCheck.input.data
//    ret.byteNum := ethUdpCheck.eth.udpLength.asUInt - UDP_ETH_LENGTH
      ret.last := ethUdpCheck.input.last
      ret
    }
}
