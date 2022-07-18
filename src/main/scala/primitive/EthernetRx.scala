package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetRxGenerics(
    destIp: Long,  // 目的IP地址 32bit
    destMac: Long, // 目的MAC地址 48bit
    destPort: Int  // 目标端口号 16bit
)

object EthernetRxConstant {
  val DATA_WIDTH         = 512                 // 数据位宽
  val DES_IP_WIDTH       = 32                  // 目的IP地址位宽
  val IP_HEAD_WIDTH      = 6                   // IP首部长度寄存器位宽
  val ERROR_CNT_WIDTH    = 16                  // 错误计数器位宽
  val KEEP_WIDTH         = 64
  val BYTE_NUM_WIDTH     = 16
  val PORT_WIDTH         = 16
  val PREAMBLE_SDF       = 0x55555555555555d5L // 8byte
  val PREAMBLE_SDF_WIDTH = 64
  val PROTOCOL           = 17
  val PROTOCOL_WIDTH     = 8
  val ETH_TYPE           = 0x0800
  val ETH_TYPE_WIDTH     = 16
  val DEST_MAC_WIDTH     = 48
}

case class EthernetRxDataIn() extends Bundle {
  val data  = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRxDataOut() extends Bundle {
  val data      = Bits(EthernetRxConstant.DATA_WIDTH bits)
  val byteNum   = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  val errorCnt  = UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)
  val errorFlag = Bool()
  val tkeep     = Bits(EthernetRxConstant.KEEP_WIDTH bits)
}

case class EthernetRx(ethernetRxGenerics: EthernetRxGenerics) extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetRxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetRxDataOut()))
  }

  val errorCnt    = Reg(UInt(EthernetRxConstant.ERROR_CNT_WIDTH bits)) init (0)
  val destMac     = Bits(EthernetRxConstant.DEST_MAC_WIDTH bits)
  val ethType     = Bits(EthernetRxConstant.ETH_TYPE_WIDTH bits)
  val preambleSdf = Bits(EthernetRxConstant.PREAMBLE_SDF_WIDTH bits)

  val ipHeadByteNum = Bits(EthernetRxConstant.IP_HEAD_WIDTH bits)
  val destIp        = Bits(EthernetRxConstant.DES_IP_WIDTH bits)
  val protocol      = Bits(EthernetRxConstant.PROTOCOL_WIDTH bits)

  val udpByteNum  = UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits)
  val dataByteNum = Reg(UInt(EthernetRxConstant.BYTE_NUM_WIDTH bits))
  val destPort    = Bits(EthernetRxConstant.PORT_WIDTH bits)

  io.dataIn.ready      := False
  io.dataOut.valid     := False
  io.dataOut.data      := 0
  io.dataOut.last      := False
  io.dataOut.errorFlag := False
  io.dataOut.byteNum   := dataByteNum
  io.dataOut.errorCnt  := errorCnt
  io.dataOut.tkeep     := 0

  destMac       := 0
  ethType       := 0
  preambleSdf   := 0
  ipHeadByteNum := 0
  protocol      := 0
  destIp        := 0
  destPort      := 0
  udpByteNum    := 0

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
          destMac     := io.dataIn.data(447 downto 400)
          ethType     := io.dataIn.data(351 downto 336)
          when(
            (preambleSdf === EthernetRxConstant.PREAMBLE_SDF) && (destMac === ethernetRxGenerics.destMac || destMac === 0xffffffffffffL) && (ethType === EthernetRxConstant.ETH_TYPE)
          ) {
            goto(stIp)
          }.otherwise {
            goto(stRxEnd)
            errorCnt := errorCnt + 1
          }
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
          protocol      := io.dataIn.data(263 downto 256)
          destIp        := io.dataIn.data(207 downto 176)
          udpByteNum    := io.dataIn.data(143 downto 128).asUInt
          dataByteNum   := udpByteNum - 8
          when(
            (protocol === EthernetRxConstant.PROTOCOL) && (destIp === ethernetRxGenerics.destIp)
          ) {
            goto(stUdp)
          }.otherwise {
            goto(stRxEnd)
            errorCnt := errorCnt + 1
          }
        }.otherwise {
          goto(stRxEnd)
          errorCnt := errorCnt + 1
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
          when(destPort === ethernetRxGenerics.destPort) {
            io.dataOut.tkeep := B"50'0" ## io.dataIn.tkeep(13 downto 0)
            io.dataIn.ready  := io.dataOut.ready
            io.dataOut.data  := io.dataIn.data
            io.dataOut.valid := io.dataIn.valid
            when(io.dataIn.fire) {
              goto(stRxData)
            }.otherwise {
              goto(stUdp)
            }
          }.otherwise {
            goto(stRxEnd)
            errorCnt := errorCnt + 1
          }
        }.otherwise {
          goto(stRxEnd)
          errorCnt := errorCnt + 1
        }
      }
    }
    val stRxData: State = new State {
      whenIsActive {
        when(io.dataIn.valid) {
          io.dataOut.valid := io.dataIn.valid
          io.dataOut.data  := io.dataIn.data
          io.dataIn.ready  := io.dataOut.ready
          io.dataOut.tkeep := io.dataIn.tkeep
          io.dataOut.last  := io.dataIn.last
          when(io.dataIn.last && io.dataIn.fire === True) {
            goto(idle)
          }
        }
      }
    }

    val stRxEnd: State = new State {
      whenIsActive {
        when(io.dataIn.valid) {
          io.dataIn.ready      := True
          io.dataOut.errorFlag := True
          when(io.dataIn.last && io.dataIn.fire === True) {
            goto(idle)
          }
        }
      }
    }
  }
}
