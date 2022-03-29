package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetTxGenerics(
    destIp: Long, 
    destMac: Long, 
    destPort: Int, 
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)

object EthernetTxConstant {
  val DATA_WIDTH = 512 
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val IDENTIFICATION_WIDTH = 16
  val CNT_WIDTH = 6
  val CHECK_BUFFER_WIDTH = 32

  val MIN_DATA_NUM = 18
  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PROTOCOL = 17
  val ETH_TYPE = 0x0800
  val VERSION_IHL = 0x45
  val TOS = 0x00
  val FLAGS_FRAGMENT_OFFSET = 0x4000
  val TTL_PROTOCOL = 0x4011
}

case class EthernetTxDataIn() extends Bundle {
  val data = Bits(EthernetTxConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetTxConstant.BYTE_NUM_WIDTH bits)
  val tkeep = Bits(EthernetTxConstant.KEEP_WIDTH bits)
}

case class EthernetTxDataOut() extends Bundle {
  val data = Bits(EthernetTxConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetTxConstant.KEEP_WIDTH bits)
}

case class EthernetTx(ethernetTxGenerics: EthernetTxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetTxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetTxDataOut()))
  }

  val headBuffer = Reg(Bits(EthernetTxConstant.DATA_WIDTH bits)) init (0)
  val identificationCnt =
    Reg(UInt(EthernetTxConstant.IDENTIFICATION_WIDTH bits)) init (0)
  val checkCnt = Reg(UInt(EthernetTxConstant.CNT_WIDTH bits)) init (0)
  val checkBuffer =
    Reg(UInt(EthernetTxConstant.CHECK_BUFFER_WIDTH bits)) init (0)
  val realTxDataNum = UInt(EthernetTxConstant.BYTE_NUM_WIDTH bits)

  when(io.dataIn.byteNum >= EthernetTxConstant.MIN_DATA_NUM) {
    realTxDataNum := io.dataIn.byteNum
  }.otherwise {
    realTxDataNum := EthernetTxConstant.MIN_DATA_NUM
  }

  io.dataIn.ready := False
  io.dataOut.valid := False
  io.dataOut.data := 0
  io.dataOut.last := False
  io.dataOut.tkeep := 0

  val fsm = new StateMachine {
    val idle: State = new State with EntryPoint {
      whenIsActive {
        when(io.dataIn.valid) {
          headBuffer(511 downto 448) := EthernetTxConstant.PREAMBLE_SDF
          headBuffer(447 downto 400) := ethernetTxGenerics.destMac
          headBuffer(399 downto 352) := ethernetTxGenerics.srcMac
          headBuffer(351 downto 336) := EthernetTxConstant.ETH_TYPE
          headBuffer(335 downto 328) := EthernetTxConstant.VERSION_IHL
          headBuffer(327 downto 320) := EthernetTxConstant.TOS
          headBuffer(319 downto 304) := (io.dataIn.byteNum + 28).asBits
          headBuffer(303 downto 288) := identificationCnt.asBits
          identificationCnt := identificationCnt + 1
          headBuffer(287 downto 272) := EthernetTxConstant.FLAGS_FRAGMENT_OFFSET
          headBuffer(271 downto 256) := EthernetTxConstant.TTL_PROTOCOL
          headBuffer(255 downto 240) := 0
          headBuffer(239 downto 208) := ethernetTxGenerics.srcIp
          headBuffer(207 downto 176) := ethernetTxGenerics.destIp
          headBuffer(175 downto 160) := ethernetTxGenerics.srcPort
          headBuffer(159 downto 144) := ethernetTxGenerics.destPort
          headBuffer(143 downto 128) := (io.dataIn.byteNum + 8).asBits
          headBuffer(127 downto 0) := 0
          goto(stCheckSum)
        }
      }
    }

    val stCheckSum: State = new State {
      onEntry {
        checkCnt := 0
        checkBuffer := 0
      }
      whenIsActive {
        when(io.dataIn.valid) {
          checkCnt := checkCnt + 1
          when(checkCnt === 0) {
            checkBuffer := (headBuffer(335 downto 320).asUInt + headBuffer(
              319 downto 304
            ).asUInt + headBuffer(303 downto 288).asUInt + headBuffer(
              287 downto 272
            ).asUInt + headBuffer(271 downto 256).asUInt + headBuffer(
              255 downto 240
            ).asUInt + headBuffer(239 downto 224).asUInt + headBuffer(
              223 downto 208
            ).asUInt + headBuffer(207 downto 192).asUInt + headBuffer(
              191 downto 176
            ).asUInt).resized
          }.elsewhen(checkCnt === 1 || checkCnt === 2) {
            checkBuffer := (checkBuffer(31 downto 16) + checkBuffer(
              15 downto 0
            )).resized
          }.elsewhen(checkCnt === 3) {
            headBuffer(255 downto 240) := ~(checkBuffer(15 downto 0).asBits)
          }.elsewhen(checkCnt === 4) {
            io.dataOut.tkeep := B(50 bits, default -> True) ## B(
              14 bits,
              default -> False
            )
            io.dataOut.data := headBuffer
            io.dataOut.valid := True
            checkCnt := checkCnt
            when(io.dataOut.fire) {
              goto(stTxData)
            }
          }
        }
      }
    }

    val stTxData: State = new State {
      whenIsActive {
        when(io.dataIn.valid) {
          io.dataOut.valid := io.dataIn.valid
          io.dataOut.data := io.dataIn.data
          io.dataIn.ready := io.dataOut.ready
          io.dataOut.tkeep := io.dataIn.tkeep
          io.dataOut.last := io.dataIn.last
          when(io.dataIn.last && io.dataIn.fire === True) {
            when(io.dataIn.byteNum < EthernetTxConstant.MIN_DATA_NUM) {
              io.dataOut.tkeep := B(18 bits, default -> True) ## B(
                46 bits,
                default -> False
              )
            }
            goto(idle)
          }
        }
      }
    }
  }
}
