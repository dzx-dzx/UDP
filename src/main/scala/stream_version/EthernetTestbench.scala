package udp_master_stream

import spinal.core._
import spinal.core.sim._
import scala.collection.mutable.ArrayBuffer

class udp_40G_TOP() extends BlackBox {
  val io = new Bundle {
    val clk                  = in Bool ()
    val gt_rxp_in_40MAC_0    = in Bits (4 bits)
    val gt_rxn_in_40MAC_0    = in Bits (4 bits)
    val gt_txp_out_40MAC_0   = out Bits (4 bits)
    val gt_txn_out_40MAC_0   = out Bits (4 bits)
    val sys_reset            = in Bool ()
    val gt_ref_clk_p_40MAC_0 = in Bool ()
    val gt_ref_clk_n_40MAC_0 = in Bool ()
    val sys_clk_p            = in Bool ()
    val sys_clk_n            = in Bool ()
  }
  noIoPrefix()
  mapCurrentClockDomain(clock = io.clk, reset = io.sys_reset)

  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/udp_40G_Top.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_exdes.v")
  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_mac_baser_syncer_reset.v"
  )
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/TxFsm.v")

  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/Sources/EthernetTx.v")
  // addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/Sources/EthernetRx.v")

  // addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetTx.v")
  addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetRx.v")
}

class TopLevel extends Component {
  val io = new Bundle {
    val gt_ref_clk_p_40MAC_0 = in Bool ()
    val sys_clk_p            = in Bool ()
    val gt_txp_out_40MAC_0   = out Bits (4 bits)
    val gt_txn_out_40MAC_0   = out Bits (4 bits)
  }
  val udp = new udp_40G_TOP()
  udp.io.gt_ref_clk_p_40MAC_0 := io.gt_ref_clk_p_40MAC_0
  udp.io.sys_clk_p            := io.sys_clk_p
  udp.io.gt_ref_clk_n_40MAC_0 := !io.gt_ref_clk_p_40MAC_0
  udp.io.sys_clk_n            := !io.sys_clk_p

  udp.io.gt_txp_out_40MAC_0 <> io.gt_txp_out_40MAC_0
  udp.io.gt_txn_out_40MAC_0 <> io.gt_txn_out_40MAC_0

  udp.io.gt_rxp_in_40MAC_0 <> udp.io.gt_txp_out_40MAC_0
  udp.io.gt_rxn_in_40MAC_0 <> udp.io.gt_txn_out_40MAC_0

}

object EthernetTestbench {
  def main(args: Array[String]): Unit = {
    EthernetRxMain.main(Array("Sources"))
    EthernetTxMain.main(Array("Sources"))
    SimConfig.withWave.withXSim
      // .addSimulatorFlag("-part xcvu13p-fhgb2104-2-i")
      // .addSimulatorFlag("-d SIM")
      .withXSimSourcesPaths(
        ArrayBuffer("/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/ip/"),
        ArrayBuffer("")
      )
      .compile(new TopLevel)
      .doSim(dut => {
        dut.clockDomain.forkStimulus(period = 10)
        dut.io.gt_ref_clk_p_40MAC_0 #= 1.toBoolean
        dut.io.sys_clk_p #= 1.toBoolean
        for (_ <- 0 until 100) {
          fork {
            dut.clockDomain.waitSampling(48)
            dut.io.gt_ref_clk_p_40MAC_0 #= !dut.io.gt_ref_clk_p_40MAC_0.toBoolean
          }
          fork {
            dut.clockDomain.waitSampling(25)
            dut.io.sys_clk_p #= !dut.io.sys_clk_p.toBoolean
          }
          dut.clockDomain.waitSampling()
        }
        simSuccess()
      })
  }
}
