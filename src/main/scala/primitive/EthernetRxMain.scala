package udp_master

import spinal.core.SpinalConfig

object EthernetRxMain {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl")
      .generateVerilog(
        EthernetRx(
          ethernetRxGenerics = EthernetRxGenerics(
            destIp = 0xc0a81f6eL, 
            destMac = 0x111111111111L, 
            destPort = 37984 
          )
        )
      )
      .printPruned()
  }
}
