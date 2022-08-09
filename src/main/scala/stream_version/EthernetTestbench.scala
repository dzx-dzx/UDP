package udp_master_stream

import spinal.sim._
import spinal.core._
import spinal.core.sim._
import scala.collection.mutable.ArrayBuffer

class udp_40G_TOP() extends BlackBox {
  val io = new Bundle {
    val gt_rxp_in_40MAC_0    = in Bits (4 bits)
    val gt_rxn_in_40MAC_0    = in Bits (4 bits)
    val gt_txp_out_40MAC_0   = out Bits (4 bits)
    val gt_txn_out_40MAC_0   = out Bits (4 bits)
    val gt_rxp_in_40MAC_1    = in Bits (4 bits)
    val gt_rxn_in_40MAC_1    = in Bits (4 bits)
    val gt_txp_out_40MAC_1   = out Bits (4 bits)
    val gt_txn_out_40MAC_1   = out Bits (4 bits)
    val sys_reset            = in Bits (1 bit)
    val gt_ref_clk_p_40MAC_0 = in Bits (1 bit)
    val gt_ref_clk_n_40MAC_0 = in Bits (1 bit)
    val gt_ref_clk_p_40MAC_1 = in Bits (1 bit)
    val gt_ref_clk_n_40MAC_1 = in Bits (1 bit)
    val sys_clk_p            = in Bits (1 bit)
    val sys_clk_n            = in Bits (1 bit)
  }
  noIoPrefix()

  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/udp_40G_Top.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_exdes_1.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_exdes.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_mac_baser_syncer_reset.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/TxFsm.v")
  
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/rtl/EthernetTx.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/rtl/EthernetRx.v")

  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetTx.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetRx.v")
}

object EthernetTestbench {
  def main(args: Array[String]): Unit = {
    EthernetRxMain.main(Array(""))
    EthernetTxMain.main(Array(""))
    val compiled = SimConfig.withWave
      .withXSim
      // .addSimulatorFlag("-part xcvu13p-fhgb2104-2-i")
      .withXSimSourcesPaths(ArrayBuffer("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/ip/"),ArrayBuffer(""))
      .compile(new udp_40G_TOP)
      .doSim(dut => {
        simSuccess()
      })
  }
}
