package udp_master_stream

import spinal.core.SpinalConfig

object EthernetTxMain {
  def main(args : Array[String] = Array("rtl")): Unit = {
    SpinalConfig(targetDirectory = args(0), enumPrefixEnable = false)//.dumpWave()
      .generateVerilog(
        EthernetTx(
          ethernetTxGenerics = EthernetTxGenerics(
            destIp = 0x7f000001, //0xc0a8aeffL, //目的IP地址 32bit //0xc0a8ae01L
            destMac = 0x111111111111L, //目的MAC地址 48bit
            destPort = 37984, //8080, //目标端口号 16bit
            srcIp = 0x7f000001, //0xc0a8aeffL,
            srcMac = 0x111111111101L,
            srcPort = 37985 //37984
          )
        )
      )
      .printPruned()
  }
}
