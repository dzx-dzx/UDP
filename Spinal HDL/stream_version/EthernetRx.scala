/*package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val errorCnt = Counter(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val destMac = Bits(EthernetRxConstant.DEST_MAC_WIDTH bits)
  val ethType = Bits(EthernetRxConstant.ETH_TYPE_WIDTH bits)
  val preambleSdf = Bits(EthernetRxConstant.PREAMBLE_SDF_WIDTH bits)

  val ipHeadByteNum = Bits(EthernetRxConstant.IP_HEAD_WIDTH bits)
  val destIp = Bits(EthernetRxConstant.DES_IP_WIDTH bits)
  val protocol = Bits(EthernetRxConstant.PROTOCOL_WIDTH bits)

  val udpByteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  val dataByteNum = Reg(UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits))
  val destPort = Bits(EthernetRxConstant.PORT_WIDTH bits)

  io.dataIn.ready := False
  io.dataOut.valid := False
  io.dataOut.data := 0
  io.dataOut.last := False
  io.dataOut.errorFlag := False
  io.dataOut.byteNum := dataByteNum
  io.dataOut.errorCnt := errorCnt
  io.dataOut.tkeep := 0

  destMac := 0
  ethType := 0
  preambleSdf := 0
  ipHeadByteNum := 0
  protocol := 0
  destIp := 0
  destPort := 0
  udpByteNum := 0

  val fsm = new StateMachine {
    val idle: State = new State with EntryPoint {
      whenIsActive {
        when(
          io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
            "3ffffffffffff",
            16
          ))
        ) {
          preambleSdf := io.dataIn.data(511 downto 448)
          destMac := io.dataIn.data(447 downto 400)
          ethType := io.dataIn.data(351 downto 336)
          /*          ipHeadByteNum := (io.dataIn.data(331 downto 328) ## B"2'0")
          protocol := io.dataIn.data(263 downto 256)
          destIp := io.dataIn.data(207 downto 176)
          destPort := io.dataIn.data(159 downto 144)
          udpByteNum := io.dataIn.data(143 downto 128).asUInt*/
          when(
            (preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && (destMac === ethernetRxGenerics.destMac || destMac === 0xffffffffffffL) && (ethType === EthernetRxConstant.ETH_TYPE)
          ) {
            /*          io.dataOut.tkeep := B"50'0" ## B(14 bits, default -> True)
            io.dataIn.ready := io.dataOut.ready
            io.dataOut.data := io.dataIn.data
            io.dataOut.valid := io.dataIn.valid
            dataByteNum := udpByteNum - 8
            when(io.dataIn.fire) {
              goto(stRxData)
            }.otherwise {
              goto(idle)
            }*/
            goto(stIp)
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }

      val stIp: State = new State {
        whenIsActive {
          when(
            io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
              "3ffffffffffff",
              16
            ))
          ) {
            ipHeadByteNum := (io.dataIn.data(331 downto 328) ## B"2'0")
            protocol := io.dataIn.data(263 downto 256)
            destIp := io.dataIn.data(207 downto 176)
            udpByteNum := io.dataIn.data(143 downto 128).asUInt
            dataByteNum := udpByteNum - 8
            when(
              (protocol === EthernetRxConstant.PROTOCOL) && (destIp === ethernetRxGenerics.destIp)
            ) {
              goto(stUdp)
            }.otherwise {
              goto(stRxEnd)
              errorCnt.increment()
            }
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }

      val stUdp: State = new State {
        whenIsActive {
          when(
            io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
              "3ffffffffffff",
              16
            ))
          ) {
            destPort := io.dataIn.data(159 downto 144)
            //          udpByteNum := io.dataIn.data(143 downto 128).asUInt
            when(destPort === ethernetRxGenerics.destPort) {
              //            io.dataOut.tkeep := B"50'0" ## B(14 bits, default -> True)
              io.dataOut.tkeep := B"50'0" ## io.dataIn.tkeep(13 downto 0)
              io.dataIn.ready := io.dataOut.ready
              io.dataOut.data := io.dataIn.data
              io.dataOut.valid := io.dataIn.valid
              //            dataByteNum := udpByteNum - 8
              when(io.dataIn.fire) {
                goto(stRxData)
              }.otherwise {
                goto(stUdp)
              }
            }.otherwise {
              goto(stRxEnd)
              errorCnt.increment()
            }
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }
      val stRxData: State = new State {
        whenIsActive {
          when(io.dataIn.valid) {
            io.dataOut.valid := io.dataIn.valid
            io.dataOut.data := io.dataIn.data
            io.dataIn.ready := io.dataOut.ready
            io.dataOut.tkeep := io.dataIn.tkeep
            io.dataOut.last := io.dataIn.last
            when(io.dataIn.last && io.dataIn.fire === True) {
              goto(idle)
            }
          }
        }
      }

      val stRxEnd: State = new State {
        whenIsActive {
          when(io.dataIn.valid) {
            io.dataIn.ready := True
            io.dataOut.errorFlag := True
            when(io.dataIn.last && io.dataIn.fire === True) {
              goto(idle)
            }
          }
        }
      }
    }
  }
}*/
/*
package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
}

case class EthernetHeadRx() extends Bundle {
  val preambleSdf = Bits(EthernetTxConstant.PREAMBLE_SDF_WIDTH bits)
  val destMac = Bits(EthernetTxConstant.MAC_WIDTH bits)
  val srcMac = Bits(EthernetTxConstant.MAC_WIDTH bits)
  val ethType = Bits(EthernetTxConstant.ETH_TYPE_WIDTH bits)
  val versionIhl = Bits(EthernetTxConstant.VERSION_IHL_WIDTH bits)
  val tos = Bits(EthernetTxConstant.TOS_WIDTH bits)
  val totalLength = Bits(EthernetTxConstant.TOTAL_LENGTH_WIDTH bits)
  val identification = Bits(EthernetTxConstant.IDENTIFICATION_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxConstant.TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum = Bits(EthernetTxConstant.HEADER_CHECKSUM bits)
  val srcIp = Bits(EthernetTxConstant.IP_WIDTH bits)
  val destIp = Bits(EthernetTxConstant.IP_WIDTH bits)
  val srcPort = Bits(EthernetTxConstant.PORT_WIDTH bits)
  val destPort = Bits(EthernetTxConstant.PORT_WIDTH bits)
  val udpLength = Bits(EthernetTxConstant.UDP_LENGTH_WIDTH bits)
  val udpCheckSum = Bits(EthernetTxConstant.UDP_CHECKSUM bits)

  /*  def asBigEndianBitsRx(
      rxDataIn: Bits
  ): Bits = {
    val ethernetHead =
      preambleSdf ## destMac ## srcMac ## ethType ## versionIhl ## tos ## totalLength.asBits ## identification.asBits ## flagsFragmentOffset ## ttlProtocol ## headerCheckSum.asBits ## srcIp ## destIp ## srcPort ## destPort ## udpLength ## udpCheckSum.asBits
    ethernetHead := rxDataIn(511 downto 112)
    ethernetHead
  }*/
}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val errorCnt = Counter(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val dataByteNum = Reg(UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits))

  io.dataIn.ready := False
  io.dataOut.valid := False
  io.dataOut.data := 0
  io.dataOut.last := False
  io.dataOut.errorFlag := False
  io.dataOut.byteNum := dataByteNum
  io.dataOut.errorCnt := errorCnt
  io.dataOut.tkeep := 0

  val eth = EthernetHeadRx()
  /*  (eth.preambleSdf ## eth.destMac ## eth.srcMac ## eth.ethType ## eth.versionIhl ## eth.tos ## eth.totalLength ## eth.identification ## eth.flagsFragmentOffset ## eth.ttlProtocol ## eth.headerCheckSum ## eth.srcIp ## eth.destIp ## eth.srcPort ## eth.destPort ## eth.udpLength ## eth.udpCheckSum) := io.dataIn
    .data(511 downto 112)*/

  eth.preambleSdf := io.dataIn.data(511 downto 448)
  eth.destMac := io.dataIn.data(447 downto 400)
  eth.srcMac := io.dataIn.data(399 downto 352)
  eth.ethType := io.dataIn.data(351 downto 336)
  eth.versionIhl := io.dataIn.data(335 downto 328)
  eth.tos := io.dataIn.data(327 downto 320)
  eth.totalLength := io.dataIn.data(319 downto 304)
  eth.identification := io.dataIn.data(303 downto 288)
  eth.flagsFragmentOffset := io.dataIn.data(287 downto 272)
  eth.ttlProtocol := io.dataIn.data(271 downto 256)
  eth.headerCheckSum := io.dataIn.data(255 downto 240)
  eth.srcIp := io.dataIn.data(239 downto 208)
  eth.destIp := io.dataIn.data(207 downto 176)
  eth.srcPort := io.dataIn.data(175 downto 160)
  eth.destPort := io.dataIn.data(159 downto 144)
  eth.udpLength := io.dataIn.data(143 downto 128)
  eth.udpCheckSum := io.dataIn.data(127 downto 112)

  val fsm = new StateMachine {
    val idle: State = new State with EntryPoint {
      whenIsActive {
        when(
          io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
            "3ffffffffffff",
            16
          ))
        ) {
          when(
            (eth.preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && (eth.destMac === ethernetRxGenerics.destMac || eth.destMac === 0xffffffffffffL) && (eth.ethType === EthernetRxConstant.ETH_TYPE)
          ) {
            goto(stIp)
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }

      val stIp: State = new State {
        whenIsActive {
          when(
            io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
              "3ffffffffffff",
              16
            ))
          ) {
            dataByteNum := eth.udpLength.asUInt - 8
            when(
              (eth.ttlProtocol(
                7 downto 0
              ) === EthernetRxConstant.PROTOCOL) && (eth.destIp === ethernetRxGenerics.destIp)
            ) {
              goto(stUdp)
            }.otherwise {
              goto(stRxEnd)
              errorCnt.increment()
            }
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }

      val stUdp: State = new State {
        whenIsActive {
          when(
            io.dataIn.valid && (io.dataIn.tkeep(63 downto 14) === BigInt(
              "3ffffffffffff",
              16
            ))
          ) {
            when(eth.destPort === ethernetRxGenerics.destPort) {
              io.dataOut.tkeep := B"50'0" ## io.dataIn.tkeep(13 downto 0)
              io.dataIn.ready := io.dataOut.ready
              io.dataOut.data := io.dataIn.data
              io.dataOut.valid := io.dataIn.valid
              when(io.dataIn.fire) {
                goto(stRxData)
              }.otherwise {
                goto(stUdp)
              }
            }.otherwise {
              goto(stRxEnd)
              errorCnt.increment()
            }
          }.otherwise {
            goto(stRxEnd)
            errorCnt.increment()
          }
        }
      }
      val stRxData: State = new State {
        whenIsActive {
          when(io.dataIn.valid) {
            io.dataOut.valid := io.dataIn.valid
            io.dataOut.data := io.dataIn.data
            io.dataIn.ready := io.dataOut.ready
            io.dataOut.tkeep := io.dataIn.tkeep
            io.dataOut.last := io.dataIn.last
            when(io.dataIn.last && io.dataIn.fire === True) {
              goto(idle)
            }
          }
        }
      }

      val stRxEnd: State = new State {
        whenIsActive {
          when(io.dataIn.valid) {
            io.dataIn.ready := True
            io.dataOut.errorFlag := True
            when(io.dataIn.last && io.dataIn.fire === True) {
              goto(idle)
            }
          }
        }
      }
    }
  }
}
 */

/*package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetTxProtocolConstant.UDP_CHECKSUM bits)
  val udpLength = Bits(EthernetTxProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val srcPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val destIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val srcIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val headerCheckSum = Bits(
    EthernetTxProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val identification = Bits(
    EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val totalLength = Bits(EthernetTxProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val tos = Bits(EthernetTxProtocolConstant.TOS_WIDTH bits)
  val versionIhl = Bits(EthernetTxProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType = Bits(EthernetTxProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val destMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetTxProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  /*  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()*/
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val ethMacCheck = Stream(EthernetHeadRx())

  ethMacCheck <-/< io.dataIn
    .translateWith {
      val ret = EthernetHeadRx()
      ret.assignFromBits(
        io.dataIn
          .data(
            EthernetRxConstant.DATA_WIDTH - 1 downto EthernetRxConstant.DATA_WIDTH - 8 * (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH)
          )
      )
      ret
    }
    .throwWhen(~(ethMacCheck.destPort === ethernetRxGenerics.destPort))

  io.dataOut <-/< ethMacCheck
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := io.dataIn.tkeep
      ret.data := io.dataIn.data
      ret.byteNum := 0
      ret.last := io.dataIn.last
      ret
    }

}*/
/*
package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetTxProtocolConstant.UDP_CHECKSUM bits)
  val udpLength = Bits(EthernetTxProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val srcPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val destIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val srcIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val headerCheckSum = Bits(
    EthernetTxProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val identification = Bits(
    EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val totalLength = Bits(EthernetTxProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val tos = Bits(EthernetTxProtocolConstant.TOS_WIDTH bits)
  val versionIhl = Bits(EthernetTxProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType = Bits(EthernetTxProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val destMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetTxProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  /*  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()*/
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val errorCnt = Counter(EthernetRxConstant.ERROR_CNT_WIDTH bits)

  val (inputStream1, inputStream2) = StreamFork2(io.dataIn)

  val ethMacCheck = Stream(EthernetHeadRx())
  val ethIpCheck = Stream(EthernetHeadRx())
  val ethUdpCheck = Stream(EthernetHeadRx())

  ethMacCheck << inputStream1
    .translateWith {
      val ret = EthernetHeadRx()
      ret.assignFromBits(
        inputStream1
          .data(
            EthernetRxConstant.DATA_WIDTH - 1 downto EthernetRxConstant.DATA_WIDTH - 8 * (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH)
          )
      )
      ret
    }

  ethIpCheck <-/< ethMacCheck
    .translateWith {
      ethMacCheck.payload
    }
    .throwWhen(
      ~(/*inputStream1.first &*/ inputStream1.tkeep(
        EthernetTxUserConstant.KEEP_WIDTH - 1 downto EthernetTxUserConstant.KEEP_WIDTH - EthernetTxProtocolConstant.MAC_ETH_LENGTH - EthernetTxProtocolConstant.IP_ETH_LENGTH - EthernetTxProtocolConstant.UDP_ETH_LENGTH
      ) === B(
        (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH) bits,
        default -> True
      ) & (ethMacCheck.preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && (ethMacCheck.destMac === ethernetRxGenerics.destMac || ethMacCheck.destMac === EthernetRxConstant.BROADCAST_MAC_ADDRESS) && (ethMacCheck.ethType === EthernetRxConstant.ETH_TYPE))
    )

  ethUdpCheck <-/< ethIpCheck
    .translateWith {
      ethIpCheck.payload
    }
    .throwWhen(
      ~(ethIpCheck.ttlProtocol(
        7 downto 0
      ) === EthernetRxConstant.PROTOCOL) && (ethIpCheck.destIp === ethernetRxGenerics.destIp)
    )

  val pipDataIn = Stream(Fragment(EthernetRxDataOut()))

  pipDataIn << inputStream2
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.data := io.dataIn.data
      ret.tkeep := io.dataIn.tkeep
      ret.last := io.dataIn.last
      ret.byteNum := ethUdpCheck.udpLength.asUInt - 8
      ret
    }
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()

  val muxOut = Stream(Fragment(EthernetRxDataOut()))
  val dataOutMux = Vec(
    pipDataIn,
    ethUdpCheck
      .translateWith {
        val ret = Fragment(EthernetRxDataOut())
        ret.data := io.dataIn.data
        ret.tkeep := io.dataIn.tkeep
        ret.last := io.dataIn.last
        ret.byteNum := ethUdpCheck.udpLength.asUInt - 8
        ret
      }
      .throwWhen(
        ~(ethUdpCheck.destPort === ethernetRxGenerics.destPort)
      )
  )
  val muxSelWidth = log2Up(dataOutMux.length)
  val muxSel = UInt(muxSelWidth bits)

  when(~ethUdpCheck.valid) {
    muxSel := 1
  }.otherwise {
    muxSel := 0
  }

  muxOut << StreamMux(muxSel, dataOutMux)
  io.dataOut <-/< muxOut

  /*io.dataOut <-/< ethUdpCheck
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := io.dataIn.tkeep
      ret.data := io.dataIn.data
      ret.byteNum := ethUdpCheck.udpLength.asUInt - 8
      ret.last := io.dataIn.last
      ret
    }
    .throwWhen(~(ethUdpCheck.destPort === ethernetRxGenerics.destPort))*/
}*/
/*package udp_master

import spinal.core._
import spinal.lib._

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetTxProtocolConstant.UDP_CHECKSUM bits)
  val udpLength = Bits(EthernetTxProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val srcPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val destIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val srcIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val headerCheckSum = Bits(
    EthernetTxProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val identification = Bits(
    EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val totalLength = Bits(EthernetTxProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val tos = Bits(EthernetTxProtocolConstant.TOS_WIDTH bits)
  val versionIhl = Bits(EthernetTxProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType = Bits(EthernetTxProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val destMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetTxProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataEth() extends Bundle {
  val eth = EthernetHeadRx()
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  /*  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()*/
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
    val ethOut = master Stream (EthernetRxDataEth())

  }

  val companyExtractFunc = (inputStream: Stream[Fragment[EthernetRxDataIn]]) =>
    new Composite(inputStream, "RespVerifier_companyExtractFunc") {

      val result = Flow(EthernetRxDataIn())
      result.payload := io.dataIn.payload
      when(inputStream.first) {
        result.valid := inputStream.fire
      }.otherwise { result.valid := False }
    }.result

  val dataInExtractCompany = StreamExtractCompany(io.dataIn, companyExtractFunc)

  val (dataInExtractCompany1, dataInExtractCompany2) = StreamFork2(
    dataInExtractCompany
  )

  val inputData = Stream(Fragment(EthernetRxDataIn()))
  val inputEth = Stream(EthernetRxDataEth())
  val ethMacCheck = Stream(EthernetRxDataEth())
  val ethIpCheck = Stream(EthernetRxDataEth())
  val ethUdpCheck = Stream(EthernetRxDataEth())

  inputData << dataInExtractCompany1.translateWith {
    val ret = Fragment(EthernetRxDataIn())
    ret.tkeep := dataInExtractCompany._1.tkeep
    ret.data := dataInExtractCompany._1.data
    ret.last := dataInExtractCompany._1.last
    ret
  }

  inputEth << dataInExtractCompany2.translateWith {
    val ret = EthernetRxDataEth()
    ret.tkeep := dataInExtractCompany._2.tkeep
    ret.eth.assignFromBits(
      dataInExtractCompany._2.data(
        EthernetRxConstant.DATA_WIDTH - 1 downto EthernetRxConstant.DATA_WIDTH - 8 * (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH)
      )
    )
    ret
  }

  ethMacCheck <-/< inputEth.throwWhen(
    ~(ethMacCheck.tkeep(
      EthernetTxUserConstant.KEEP_WIDTH - 1 downto EthernetTxUserConstant.KEEP_WIDTH - EthernetTxProtocolConstant.MAC_ETH_LENGTH - EthernetTxProtocolConstant.IP_ETH_LENGTH - EthernetTxProtocolConstant.UDP_ETH_LENGTH
    ) === B(
      (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH) bits,
      default -> True
    ) & (ethMacCheck.eth.preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && ((ethMacCheck.eth.destMac === ethernetRxGenerics.destMac) || (ethMacCheck.eth.destMac === EthernetRxConstant.BROADCAST_MAC_ADDRESS)) && (ethMacCheck.eth.ethType === EthernetRxConstant.ETH_TYPE))
  )

  ethIpCheck <-/< ethMacCheck.throwWhen(
    ~(ethIpCheck.eth.ttlProtocol(
      7 downto 0
    ) === EthernetRxConstant.PROTOCOL) && (ethIpCheck.eth.destIp === ethernetRxGenerics.destIp)
  )

  ethUdpCheck <-/< ethIpCheck.throwWhen(
    ~(ethUdpCheck.eth.destPort === ethernetRxGenerics.destPort)
  )

  io.ethOut << ethUdpCheck

  io.dataOut << inputData
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := inputData.tkeep
      ret.data := inputData.data
      ret.byteNum := 0
      ret.last := inputData.last
      ret
    }
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()
    .s2mPipe()
    .m2sPipe()
    .throwWhen(~io.ethOut.fire)

}*/
///StreamJOIN
/*package udp_master

import spinal.core._
import spinal.lib._

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH = 512
  val DES_IP_WIDTH = 32
  val IP_HEAD_WIDTH = 6
  val ERROR_CNT_WIDTH = 16
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val PORT_WIDTH = 16
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL = 17
  val PROTOCOL_WIDTH = 8
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val DEST_MAC_WIDTH = 48
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetTxProtocolConstant.UDP_CHECKSUM bits)
  val udpLength = Bits(EthernetTxProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val srcPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val destIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val srcIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val headerCheckSum = Bits(
    EthernetTxProtocolConstant.HEADER_CHECKSUM_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val identification = Bits(
    EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val totalLength = Bits(EthernetTxProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val tos = Bits(EthernetTxProtocolConstant.TOS_WIDTH bits)
  val versionIhl = Bits(EthernetTxProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType = Bits(EthernetTxProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val destMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetTxProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataEth() extends Bundle {
  val eth = EthernetHeadRx()
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  /*  val errorCnt = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()*/
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
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
      when(inputStream.first) {
        result.valid := inputStream.fire
      }.otherwise { result.valid := False }
    }.result

  val dataInExtractCompany = StreamExtractCompany(io.dataIn, companyExtractFunc)

  val (dataInExtractCompany1, dataInExtractCompany2) = StreamFork2(
    dataInExtractCompany
  )

  val inputData = Stream(Fragment(EthernetRxDataIn()))
  val inputEth = Stream(EthernetRxDataEth())
  val ethMacCheck = Stream(EthernetRxDataEth())
  val ethIpCheck = Stream(EthernetRxDataEth())
  val ethUdpCheck = Stream(EthernetRxDataEth())

  inputData << dataInExtractCompany1.translateWith {
    val ret = Fragment(EthernetRxDataIn())
    ret.tkeep := dataInExtractCompany._1.tkeep
    ret.data := dataInExtractCompany._1.data
    ret.last := dataInExtractCompany._1.last
    ret
  }

  inputEth << dataInExtractCompany2.translateWith {
    val ret = EthernetRxDataEth()
    ret.tkeep := dataInExtractCompany._2.tkeep
    ret.eth.assignFromBits(
      dataInExtractCompany._2.data(
        EthernetRxConstant.DATA_WIDTH - 1 downto EthernetRxConstant.DATA_WIDTH - 8 * (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH)
      )
    )
    ret
  }

  ethMacCheck <-/< inputEth /*.throwWhen(
    ~(ethMacCheck.tkeep(
      EthernetTxUserConstant.KEEP_WIDTH - 1 downto EthernetTxUserConstant.KEEP_WIDTH - EthernetTxProtocolConstant.MAC_ETH_LENGTH - EthernetTxProtocolConstant.IP_ETH_LENGTH - EthernetTxProtocolConstant.UDP_ETH_LENGTH
    ) === B(
      (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH) bits,
      default -> True
    ) & (ethMacCheck.eth.preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && ((ethMacCheck.eth.destMac === ethernetRxGenerics.destMac) || (ethMacCheck.eth.destMac === EthernetRxConstant.BROADCAST_MAC_ADDRESS)) && (ethMacCheck.eth.ethType === EthernetRxConstant.ETH_TYPE))
  )*/

  ethIpCheck <-/< ethMacCheck /*.throwWhen(
    ~(ethIpCheck.eth.ttlProtocol(
      7 downto 0
    ) === EthernetRxConstant.PROTOCOL) && (ethIpCheck.eth.destIp === ethernetRxGenerics.destIp)
  )*/

  ethUdpCheck <-/< ethIpCheck.throwWhen(
    ~(ethUdpCheck.eth.destPort === ethernetRxGenerics.destPort)
  )

  io.dataOut << StreamJoin
    .arg(inputData, ethUdpCheck)
    .translateWith {
      val ret = Fragment(EthernetRxDataOut())
      ret.tkeep := inputData.tkeep
      ret.data := inputData.data
      ret.byteNum := 0
      ret.last := inputData.last
      ret
    }

}*/
package udp_master

import spinal.core._
import spinal.lib._

case class EthernetRxGenerics(
    destIp: Long, //Destination IP address 32bit
    destMac: Long, //Destination MAC address 48bit
    destPort: Int //Destination port 16bit
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
          result._2 := companyFlow.payload
          companyReg := companyFlow.payload
        } otherwise {
          result._2 := companyReg
        }
        result
      }
    }.outputStream
}

case class EthernetHeadRx() extends Bundle {
  val udpCheckSum = Bits(EthernetProtocolConstant.UDP_CHECKSUM bits)
  val udpLength = Bits(EthernetProtocolConstant.UDP_LENGTH_WIDTH bits)
  val destPort = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val srcPort = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val destIp = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val srcIp = Bits(EthernetProtocolConstant.IP_WIDTH bits)
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
  val tos = Bits(EthernetProtocolConstant.TOS_WIDTH bits)
  val versionIhl = Bits(EthernetProtocolConstant.VERSION_IHL_WIDTH bits)
  val ethType = Bits(EthernetProtocolConstant.ETH_TYPE_WIDTH bits)
  val srcMac = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val destMac = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val preambleSdf = Bits(EthernetProtocolConstant.PREAMBLE_SDF_WIDTH bits)

}

case class EthernetRxDataEth() extends Bundle {
  val eth = EthernetHeadRx()
  val input = Fragment(EthernetRxDataIn())
}

case class EthernetRxDataIn() extends Bundle {
  val data = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data = Bits(EthernetUserConstant.DATA_WIDTH bits)
//  val byteNum = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
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
      when(inputStream.first) {
        result.valid := inputStream.fire
      } otherwise {
        result.valid := False
      }
    }.result

  val dataInExtractCompany = StreamExtractCompany(io.dataIn, companyExtractFunc)

  val (dataInExtractCompany1, dataInExtractCompany2) = StreamFork2(
    dataInExtractCompany
  )

  val inputData = Stream(Fragment(EthernetRxDataIn()))
  val inputEth = Stream(EthernetHeadRx())

  inputData << dataInExtractCompany1.translateWith {
    val ret = Fragment(EthernetRxDataIn())
    ret.tkeep := dataInExtractCompany._1.tkeep
    ret.data := dataInExtractCompany._1.data
    ret.last := dataInExtractCompany._1.last
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
      ret.input.data := inputData.data
      ret.input.last := inputData.last
      ret.eth := inputEth.payload
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

  io.dataOut <-/< ethUdpCheck.translateWith {
    val ret = Fragment(EthernetRxDataOut())
    ret.tkeep := ethUdpCheck.input.tkeep
    ret.data := ethUdpCheck.input.data
//    ret.byteNum := ethUdpCheck.eth.udpLength.asUInt - EthernetProtocolConstant.UDP_ETH_LENGTH
    ret.last := ethUdpCheck.input.last
    ret
  }
//存在问题，不能保留第一拍而保留的是第二拍
}
