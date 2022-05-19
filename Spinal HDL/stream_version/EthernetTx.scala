/*package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

case class EthernetTxGenerics(
    destIp: Long, // 目的IP地址 32bit
    destMac: Long, // 目的MAC地址 48bit
    destPort: Int, // 目标端口号 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)

object EthernetTxConstant {
  val DATA_WIDTH = 512 //数据位宽
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
  } otherwise {
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
            checkBuffer := (headBuffer(335 downto 320).asUInt +
              headBuffer(319 downto 304).asUInt +
              headBuffer(303 downto 288).asUInt +
              headBuffer(287 downto 272).asUInt +
              headBuffer(271 downto 256).asUInt +
              headBuffer(255 downto 240).asUInt + headBuffer(
                239 downto 224
              ).asUInt + headBuffer(
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
}*/
/*package udp_master

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

case class EthernetTxGenerics(
    destIp: Long, // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int, // Destination port 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)

object EthernetTxConstant {
  val DATA_WIDTH = 512
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val CNT_WIDTH = 6
  val CHECK_BUFFER_WIDTH = 32
  val MIN_DATA_NUM = 18
  val PROTOCOL = 17

  val PREAMBLE_SDF = 0x55555555555555d5L //8byte
  val PREAMBLE_SDF_WIDTH = 64
  val MAC_WIDTH = 48
  val ETH_TYPE = 0x0800
  val ETH_TYPE_WIDTH = 16
  val VERSION_IHL = 0x45
  val VERSION_IHL_WIDTH = 8
  val TOS = 0x00
  val TOS_WIDTH = 8
  val TOTAL_LENGTH_WIDTH = 16
  val IDENTIFICATION_WIDTH = 16
  val FLAGS_FRAGMENT_OFFSET = 0x4000
  val FLAGS_FRAGMENT_OFFSET_WIDTH = 16
  val TTL_PROTOCOL = 0x4011
  val TTL_PROTOCOL_WIDTH = 16
  val HEADER_CHECKSUM = 16
  val IP_WIDTH = 32
  val PORT_WIDTH = 16
  val UDP_LENGTH_WIDTH = 16
  val UDP_CHECKSUM = 16

}

case class EthernetHeadTx() extends Bundle {
  val preambleSdf = Bits(EthernetTxConstant.PREAMBLE_SDF_WIDTH bits)
  val destMac = Bits(EthernetTxConstant.MAC_WIDTH bits)
  val srcMac = Bits(EthernetTxConstant.MAC_WIDTH bits)
  val ethType = Bits(EthernetTxConstant.ETH_TYPE_WIDTH bits)
  val versionIhl = Bits(EthernetTxConstant.VERSION_IHL_WIDTH bits)
  val tos = Bits(EthernetTxConstant.TOS_WIDTH bits)
  val totalLength = UInt(EthernetTxConstant.TOTAL_LENGTH_WIDTH bits)
  val identification = UInt(EthernetTxConstant.IDENTIFICATION_WIDTH bits)
  val flagsFragmentOffset = Bits(
    EthernetTxConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxConstant.TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum = UInt(EthernetTxConstant.HEADER_CHECKSUM bits)
  val srcIp = Bits(EthernetTxConstant.IP_WIDTH bits)
  val destIp = Bits(EthernetTxConstant.IP_WIDTH bits)
  val srcPort = Bits(EthernetTxConstant.PORT_WIDTH bits)
  val destPort = Bits(EthernetTxConstant.PORT_WIDTH bits)
  val udpLength = Bits(EthernetTxConstant.UDP_LENGTH_WIDTH bits)
  val udpCheckSum = UInt(EthernetTxConstant.UDP_CHECKSUM bits)

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

  val identificationCnt =
    Counter(EthernetTxConstant.IDENTIFICATION_WIDTH bits)
  val checkCnt = Counter(EthernetTxConstant.CNT_WIDTH bits)
  val checkBuffer =
    Reg(UInt(EthernetTxConstant.CHECK_BUFFER_WIDTH bits))
  val realTxDataNum = UInt(EthernetTxConstant.BYTE_NUM_WIDTH bits)

  val ethReg = Reg(EthernetHeadTx())

  when(io.dataIn.byteNum >= EthernetTxConstant.MIN_DATA_NUM) {
    realTxDataNum := io.dataIn.byteNum
  } otherwise {
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
          ethReg.preambleSdf := EthernetTxConstant.PREAMBLE_SDF
          ethReg.destMac := ethernetTxGenerics.destMac
          ethReg.srcMac := ethernetTxGenerics.srcMac
          ethReg.ethType := EthernetTxConstant.ETH_TYPE
          ethReg.versionIhl := EthernetTxConstant.VERSION_IHL
          ethReg.tos := EthernetTxConstant.TOS
          ethReg.totalLength := io.dataIn.byteNum + 28
          ethReg.identification := identificationCnt
          identificationCnt.increment()
          ethReg.flagsFragmentOffset := EthernetTxConstant.FLAGS_FRAGMENT_OFFSET
          ethReg.ttlProtocol := EthernetTxConstant.TTL_PROTOCOL
          ethReg.headerCheckSum := U"16'x0000"
          ethReg.srcIp := ethernetTxGenerics.srcIp
          ethReg.destIp := ethernetTxGenerics.destIp
          ethReg.srcPort := ethernetTxGenerics.srcPort
          ethReg.destPort := ethernetTxGenerics.destPort
          ethReg.udpLength := (io.dataIn.byteNum + 8).asBits
          ethReg.udpCheckSum := U"16'x0000"
          goto(stCheckSum)
        }
      }
    }

    val stCheckSum: State = new State {
      onEntry {
        checkCnt.clear()
        checkBuffer := 0
      }
      whenIsActive {
        when(io.dataIn.valid) {
          checkCnt.increment()
          when(checkCnt === 0) {
            checkBuffer := ((ethReg.versionIhl ## ethReg.tos).asUInt +^
              ethReg.totalLength +^
              ethReg.identification +^
              ethReg.flagsFragmentOffset.asUInt +^
              ethReg.ttlProtocol.asUInt +^
              ethReg.headerCheckSum +^
              ethReg.srcIp(31 downto 16).asUInt +^
              ethReg.srcIp(15 downto 0).asUInt +^
              ethReg.destIp(31 downto 16).asUInt +^ ethReg
                .destIp(15 downto 0)
                .asUInt).resized
          }.elsewhen(checkCnt === 1 || checkCnt === 2) {
            checkBuffer := (checkBuffer(31 downto 16) +| checkBuffer(
              15 downto 0
            )).resized
          }.elsewhen(checkCnt === 3) {
            ethReg.headerCheckSum := ~checkBuffer(15 downto 0)
          }.elsewhen(checkCnt === 4) {
            io.dataOut.tkeep := B(50 bits, default -> True) ## B(
              14 bits,
              default -> False
            )
            io.dataOut.data := ethReg.asBigEndianBitsTx(
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
}*/
/*package udp_master

import spinal.core._
import spinal.lib._

case class EthernetTxGenerics(
    destIp: Long, // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int, // Destination port 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)
object EthernetTxUserConstant {
  val DATA_WIDTH = 512
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val CHECK_BUFFER_WIDTH = 32
}

object EthernetTxProtocolConstant {
  val MIN_DATA_NUM = 18

  val PREAMBLE = 0x55555555555555L
  val SFD = 0xd5
  val ETH_TYPE = 0x0800 //0x0800 represents the IP protocol

  val MAC_ETH_LENGTH = 22
  val IP_ETH_LENGTH = 20
  val UDP_ETH_LENGTH = 8
  val PREAMBLE_SDF_WIDTH = 64
  val PREAMBLE_SDF = (PREAMBLE << 8) + SFD
  val MAC_WIDTH = 48
  val ETH_TYPE_WIDTH = 16
  val VERSION_IHL = 0x45
  val VERSION_IHL_WIDTH = 8
  val TOS = 0x00
  val TOS_WIDTH = 8
  val TOTAL_LENGTH_WIDTH = 16
  val IDENTIFICATION_WIDTH = 16
  val FLAGS_FRAGMENT_OFFSET = 0x4000
  val FLAGS_FRAGMENT_OFFSET_WIDTH = 16
  val TTL_PROTOCOL = 0x4011
  val TTL_PROTOCOL_WIDTH = 16
  val HEADER_CHECKSUM = 16
  val IP_WIDTH = 32
  val PORT_WIDTH = 16
  val UDP_LENGTH_WIDTH = 16
  val UDP_CHECKSUM = 16
}

case class EthernetHeadTx() extends Bundle {
  val preambleSdf = Bits(EthernetTxProtocolConstant.PREAMBLE_SDF_WIDTH bits)
  val destMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val srcMac = Bits(EthernetTxProtocolConstant.MAC_WIDTH bits)
  val ethType = Bits(EthernetTxProtocolConstant.ETH_TYPE_WIDTH bits)
  val versionIhl = Bits(EthernetTxProtocolConstant.VERSION_IHL_WIDTH bits)
  val tos = Bits(EthernetTxProtocolConstant.TOS_WIDTH bits)
  val totalLength = UInt(EthernetTxProtocolConstant.TOTAL_LENGTH_WIDTH bits)
  val identification = UInt(
    EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits
  )
  val flagsFragmentOffset = Bits(
    EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET_WIDTH bits
  )
  val ttlProtocol = Bits(EthernetTxProtocolConstant.TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum = UInt(EthernetTxProtocolConstant.HEADER_CHECKSUM bits)
  val srcIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val destIp = Bits(EthernetTxProtocolConstant.IP_WIDTH bits)
  val srcPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val destPort = Bits(EthernetTxProtocolConstant.PORT_WIDTH bits)
  val udpLength = Bits(EthernetTxProtocolConstant.UDP_LENGTH_WIDTH bits)
  val udpCheckSum = UInt(EthernetTxProtocolConstant.UDP_CHECKSUM bits)

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
  val data = Bits(EthernetTxUserConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetTxUserConstant.BYTE_NUM_WIDTH bits)
  val tkeep = Bits(EthernetTxUserConstant.KEEP_WIDTH bits)
}

case class EthernetTxDataOut() extends Bundle {
  val data = Bits(EthernetTxUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetTxUserConstant.KEEP_WIDTH bits)
}

case class EthernetTx(ethernetTxGenerics: EthernetTxGenerics)
    extends Component {
  val io = new Bundle {
    val dataIn =
      slave Stream (Fragment(EthernetTxDataIn()))
    val dataOut =
      master Stream (Fragment(EthernetTxDataOut()))
  }

  val identificationCnt =
    Counter(EthernetTxProtocolConstant.IDENTIFICATION_WIDTH bits)

  when(io.dataIn.fire & io.dataIn.last) {
    identificationCnt.increment()
  }

  val checkBuffer =
    Stream(UInt(EthernetTxUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkBuffer1 =
    Stream(UInt(EthernetTxUserConstant.CHECK_BUFFER_WIDTH bits))
  val checkBuffer2 =
    Stream(UInt(EthernetTxUserConstant.CHECK_BUFFER_WIDTH bits))

  val checkBuffer3 = Stream(Fragment(EthernetTxDataOut()))

  val realTxDataNum = UInt(EthernetTxUserConstant.BYTE_NUM_WIDTH bits)

  when(io.dataIn.byteNum >= EthernetTxProtocolConstant.MIN_DATA_NUM) {
    realTxDataNum := io.dataIn.byteNum
  } otherwise {
    realTxDataNum := EthernetTxProtocolConstant.MIN_DATA_NUM
  }

  val (inputStream1, inputStream2) = StreamFork2(io.dataIn)

  val ethReg = EthernetHeadTx()
  ethReg.preambleSdf := EthernetTxProtocolConstant.PREAMBLE_SDF
  ethReg.destMac := ethernetTxGenerics.destMac
  ethReg.srcMac := ethernetTxGenerics.srcMac
  ethReg.ethType := EthernetTxProtocolConstant.ETH_TYPE
  ethReg.versionIhl := EthernetTxProtocolConstant.VERSION_IHL
  ethReg.tos := EthernetTxProtocolConstant.TOS
  ethReg.totalLength := realTxDataNum + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH
  ethReg.identification := identificationCnt
  ethReg.flagsFragmentOffset := EthernetTxProtocolConstant.FLAGS_FRAGMENT_OFFSET
  ethReg.ttlProtocol := EthernetTxProtocolConstant.TTL_PROTOCOL
  ethReg.headerCheckSum := checkBuffer2.payload(
    EthernetTxUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
  )
  ethReg.srcIp := ethernetTxGenerics.srcIp
  ethReg.destIp := ethernetTxGenerics.destIp
  ethReg.srcPort := ethernetTxGenerics.srcPort
  ethReg.destPort := ethernetTxGenerics.destPort
  ethReg.udpLength := (realTxDataNum + EthernetTxProtocolConstant.UDP_ETH_LENGTH).asBits
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
        EthernetTxProtocolConstant.IP_WIDTH - 1 downto EthernetTxProtocolConstant.IP_WIDTH / 2
      )
      .asUInt,
    ethReg.srcIp(EthernetTxProtocolConstant.IP_WIDTH / 2 - 1 downto 0).asUInt,
    ethReg
      .destIp(
        EthernetTxProtocolConstant.IP_WIDTH - 1 downto EthernetTxProtocolConstant.IP_WIDTH / 2
      )
      .asUInt,
    ethReg.destIp(EthernetTxProtocolConstant.IP_WIDTH / 2 - 1 downto 0).asUInt
  )

  checkBuffer << inputStream1
    .translateWith(
      ipEth
        .reduceBalancedTree(_ +^ _)
        .resize(EthernetTxUserConstant.CHECK_BUFFER_WIDTH)
    )
    .stage()

  checkBuffer1 << checkBuffer
    .translateWith(
      checkBuffer.payload(
        EthernetTxUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetTxUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkBuffer
        .payload(
          EthernetTxUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
        )
        .resize(EthernetTxUserConstant.CHECK_BUFFER_WIDTH)
    )
    .stage()

  checkBuffer2 << checkBuffer1
    .translateWith(
      ~((checkBuffer1.payload(
        EthernetTxUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetTxUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkBuffer1.payload(
        EthernetTxUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
      )).resize(EthernetTxUserConstant.CHECK_BUFFER_WIDTH))
    )
    .stage()

  val pipDataIn = Stream(Fragment(EthernetTxDataOut()))

  pipDataIn << inputStream2
    .translateWith {
      val ret = Fragment(EthernetTxDataOut())
      ret.data := io.dataIn.data
      ret.tkeep := io.dataIn.tkeep
      ret.last := io.dataIn.last
      ret
    }
    .stage()
    .stage()
    .stage()

  checkBuffer3 << checkBuffer2.translateWith {
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
      (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH) bits,
      default -> True
    ) ## B(
      (EthernetTxUserConstant.KEEP_WIDTH - (EthernetTxProtocolConstant.MAC_ETH_LENGTH + EthernetTxProtocolConstant.IP_ETH_LENGTH + EthernetTxProtocolConstant.UDP_ETH_LENGTH)) bits,
      default -> False
    )
    ret.last := False
    ret
  }

  val dataOutMux = Vec(pipDataIn, checkBuffer3.throwWhen(~io.dataOut.first))
  val muxSel = UInt(log2Up(dataOutMux.length) bits)

  when(io.dataOut.first) {
    muxSel := 1
  }.otherwise {
    muxSel := 0
  }

  io.dataOut << StreamMux(muxSel, dataOutMux)
}*/
package udp_master

import spinal.core._
import spinal.lib._

case class EthernetTxGenerics(
    destIp: Long, // Destination IP address 32bit
    destMac: Long, // Destination MAC address 48bit
    destPort: Int, // Destination port 16bit
    srcIp: Long,
    srcMac: Long,
    srcPort: Int
)
object EthernetUserConstant {
  val DATA_WIDTH = 512
  val KEEP_WIDTH = 64
  val BYTE_NUM_WIDTH = 16
  val CHECK_BUFFER_WIDTH = 32
}

object EthernetProtocolConstant {
  val MIN_DATA_NUM = 18
  val BROADCAST_MAC_ADDRESS = 0xffffffffffffL

  val PREAMBLE = 0x55555555555555L
  val SFD = 0xd5 //Start Frame Delimiter
  val ETH_TYPE = 0x0800 //0x0800 represents the IP protocol
  val VERSION = 0x4 //0x4 represents IPv4
  val IHL = 0x5 //Internet Header Length
  val TOS = 0x00 //Type of service , 0x00 represents general service
  val FLAGS = 0x2
  val FRAGMENT_OFFSET = 0x0
  val TTL = 0x40 //Time to Live
  val PROTOCOL = 0x11 //0x11 represents UDP

  val BYTE_WIDTH = 8
  val MAC_ETH_LENGTH = 22
  val IP_ETH_LENGTH = 20
  val UDP_ETH_LENGTH = 8
  val ETH_TOTAL_LENGTH = MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH
  val PREAMBLE_SDF_WIDTH = 64
  val PREAMBLE_SDF = (PREAMBLE << 8) + SFD
  val MAC_WIDTH = 48
  val ETH_TYPE_WIDTH = 16
  val VERSION_IHL = (VERSION << 4) + IHL
  val VERSION_IHL_WIDTH = 8
  val TOS_WIDTH = 8
  val TOTAL_LENGTH_WIDTH = 16
  val IDENTIFICATION_WIDTH = 16
  val FLAGS_FRAGMENT_OFFSET = (FLAGS << 13) + FRAGMENT_OFFSET
  val FLAGS_FRAGMENT_OFFSET_WIDTH = 16
  val TTL_PROTOCOL = (TTL << 8) + PROTOCOL
  val TTL_PROTOCOL_WIDTH = 16
  val HEADER_CHECKSUM_WIDTH = 16
  val IP_WIDTH = 32
  val PORT_WIDTH = 16
  val UDP_LENGTH_WIDTH = 16
  val UDP_CHECKSUM = 16
}

case class EthernetHeadTx() extends Bundle {
  val preambleSdf = Bits(EthernetProtocolConstant.PREAMBLE_SDF_WIDTH bits)
  val destMac = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val srcMac = Bits(EthernetProtocolConstant.MAC_WIDTH bits)
  val ethType = Bits(EthernetProtocolConstant.ETH_TYPE_WIDTH bits)
  val versionIhl = Bits(EthernetProtocolConstant.VERSION_IHL_WIDTH bits)
  val tos = Bits(EthernetProtocolConstant.TOS_WIDTH bits)
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
  val srcIp = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val destIp = Bits(EthernetProtocolConstant.IP_WIDTH bits)
  val srcPort = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val destPort = Bits(EthernetProtocolConstant.PORT_WIDTH bits)
  val udpLength = Bits(EthernetProtocolConstant.UDP_LENGTH_WIDTH bits)
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
  val data = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val byteNum = UInt(EthernetUserConstant.BYTE_NUM_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetTxDataOut() extends Bundle {
  val data = Bits(EthernetUserConstant.DATA_WIDTH bits)
  val tkeep = Bits(EthernetUserConstant.KEEP_WIDTH bits)
}

case class EthernetTx(ethernetTxGenerics: EthernetTxGenerics)
    extends Component {
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

  val ethReg = EthernetHeadTx()
  ethReg.preambleSdf := EthernetProtocolConstant.PREAMBLE_SDF
  ethReg.destMac := ethernetTxGenerics.destMac
  ethReg.srcMac := ethernetTxGenerics.srcMac
  ethReg.ethType := EthernetProtocolConstant.ETH_TYPE
  ethReg.versionIhl := EthernetProtocolConstant.VERSION_IHL
  ethReg.tos := EthernetProtocolConstant.TOS
  ethReg.totalLength := realTxDataNum + EthernetProtocolConstant.IP_ETH_LENGTH + EthernetProtocolConstant.UDP_ETH_LENGTH
  ethReg.identification := identificationCnt
  ethReg.flagsFragmentOffset := EthernetProtocolConstant.FLAGS_FRAGMENT_OFFSET
  ethReg.ttlProtocol := EthernetProtocolConstant.TTL_PROTOCOL
  ethReg.headerCheckSum := checkSumStage3.payload(
    EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
  )
  ethReg.srcIp := ethernetTxGenerics.srcIp
  ethReg.destIp := ethernetTxGenerics.destIp
  ethReg.srcPort := ethernetTxGenerics.srcPort
  ethReg.destPort := ethernetTxGenerics.destPort
  ethReg.udpLength := (realTxDataNum + EthernetProtocolConstant.UDP_ETH_LENGTH).asBits
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
  )

  checkSumStage1 <-/< inputStream1
    .translateWith(
      ipEth
        .reduceBalancedTree(_ +^ _)
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    )

  checkSumStage2 <-/< checkSumStage1
    .translateWith(
      checkSumStage1.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage1
        .payload(
          EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
        )
        .resize(EthernetUserConstant.CHECK_BUFFER_WIDTH)
    )

  checkSumStage3 <-/< checkSumStage2
    .translateWith(
      ~((checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH - 1 downto EthernetUserConstant.CHECK_BUFFER_WIDTH / 2
      ) + checkSumStage2.payload(
        EthernetUserConstant.CHECK_BUFFER_WIDTH / 2 - 1 downto 0
      )).resize(EthernetUserConstant.CHECK_BUFFER_WIDTH))
    )

  val pipDataIn = Stream(Fragment(EthernetTxDataOut()))

  pipDataIn << inputStream2
    .translateWith {
      val ret = Fragment(EthernetTxDataOut())
      ret.data := io.dataIn.data
      ret.tkeep := io.dataIn.tkeep
      ret.last := io.dataIn.last
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
    )
    ret.last := False
    ret
  }

  val muxOut = Stream(Fragment(EthernetTxDataOut()))
  val dataOutMux = Vec(pipDataIn, checkSum4.throwWhen(~muxOut.first))
  val muxSelWidth = log2Up(dataOutMux.length)
  val muxSel = UInt(muxSelWidth bits)

  when(muxOut.first) {
    muxSel := 1
  }.otherwise {
    muxSel := 0
  }

  muxOut << StreamMux(muxSel, dataOutMux)
  io.dataOut <-/< muxOut
}
