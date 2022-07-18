package udp_master_stream

import spinal.core.SpinalConfig

object EthernetRxMain {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl")
      .generateVerilog(
        EthernetRx(
          ethernetRxGenerics = EthernetRxGenerics(
            destIp = 0x7f000001, //0xc0a8aeffL, //目的IP地址 32bit
            destMac = 0x111111111111L, //目的MAC地址 48bit
            destPort = 37984 //目标端口号 16bit
          )
        )
      )
      .printPruned()
  }
}
