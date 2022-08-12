package udp_master_stream

import spinal.core._

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
  val UDP_CHECKSUM_WIDTH          = 16
}

import EthernetProtocolConstant._

case class MacHeader() extends Bundle {
  val preambleSdf = Bits(PREAMBLE_SDF_WIDTH bits)
  val destMac     = Bits(MAC_WIDTH bits)
  val srcMac      = Bits(MAC_WIDTH bits)
  val ethType     = Bits(ETH_TYPE_WIDTH bits)
}

case class IPHeader() extends Bundle {
  val versionIhl          = Bits(VERSION_IHL_WIDTH bits)
  val tos                 = Bits(TOS_WIDTH bits)
  val totalLength         = UInt(TOTAL_LENGTH_WIDTH bits)
  val identification      = UInt(IDENTIFICATION_WIDTH bits)
  val flagsFragmentOffset = Bits(FLAGS_FRAGMENT_OFFSET_WIDTH bits)
  val ttlProtocol         = Bits(TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum      = UInt(HEADER_CHECKSUM_WIDTH bits)
  val srcIp               = Bits(IP_WIDTH bits)
  val destIp              = Bits(IP_WIDTH bits)
}

case class UDPHeader() extends Bundle {
  val srcPort     = Bits(PORT_WIDTH bits)
  val destPort    = Bits(PORT_WIDTH bits)
  val udpLength   = Bits(UDP_LENGTH_WIDTH bits)
  val udpCheckSum = UInt(UDP_CHECKSUM_WIDTH bits)
}

case class Header() extends Bundle {
  val mac = MacHeader()
  val ip  = IPHeader()
  val udp = UDPHeader()
}

case class EthernetHeadTx() extends Bundle {
  val preambleSdf         = Bits(PREAMBLE_SDF_WIDTH bits)
  val destMac             = Bits(MAC_WIDTH bits)
  val srcMac              = Bits(MAC_WIDTH bits)
  val ethType             = Bits(ETH_TYPE_WIDTH bits)
  val versionIhl          = Bits(VERSION_IHL_WIDTH bits)
  val tos                 = Bits(TOS_WIDTH bits)
  val totalLength         = UInt(TOTAL_LENGTH_WIDTH bits)
  val identification      = UInt(IDENTIFICATION_WIDTH bits)
  val flagsFragmentOffset = Bits(FLAGS_FRAGMENT_OFFSET_WIDTH bits)
  val ttlProtocol         = Bits(TTL_PROTOCOL_WIDTH bits)
  val headerCheckSum      = UInt(HEADER_CHECKSUM_WIDTH bits)
  val srcIp               = Bits(IP_WIDTH bits)
  val destIp              = Bits(IP_WIDTH bits)
  val srcPort             = Bits(PORT_WIDTH bits)
  val destPort            = Bits(PORT_WIDTH bits)
  val udpLength           = Bits(UDP_LENGTH_WIDTH bits)
  val udpCheckSum         = UInt(UDP_CHECKSUM_WIDTH bits)

  def asBigEndianBitsTx: Bits = {
    val header = this.elements
      .map(_._2.asBits)
      .reduceRight((a, b) => a ## b) ## B(
      112 bits,
      default -> False
    ) // I actually spent 6 hours on these three lines of code...
    header
  }
}
