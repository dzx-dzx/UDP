package udp_master

import spinal.core.SpinalConfig

object EthernetTxMain {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl")
      .generateVerilog(
        EthernetTx(
          ethernetTxGenerics = EthernetTxGenerics(
            destIp = 0xc0a81f6eL, 
            destMac = 0x111111111111L, 
            destPort = 37984, 
            srcIp = 0x11111111L,
            srcMac = 0x111111111101L,
            srcPort = 37985
          )
        )
      )
      .printPruned()
  }
}
