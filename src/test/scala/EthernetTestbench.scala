package udp_master_stream

import org.scalatest.funsuite.AnyFunSuite
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
    val pkt_clk              = out Bool ()

    val fsm_dataOut_valid_0                    = in Bool ()
    val fsm_dataOut_ready_0                    = out Bool ()
    val fsm_dataOut_payload_last_0             = in Bool ()
    val fsm_dataOut_payload_fragment_data_0    = in Bits (512 bits)
    val fsm_dataOut_payload_fragment_byteNum_0 = in Bits (16 bits)
    val fsm_dataOut_payload_fragment_tkeep_0   = in Bits (64 bits)

    val rx_dataOut_valid_0                      = out Bool ()
    val rx_dataOut_ready_0                      = in Bool ()
    val rx_dataOut_payload_last_0               = out Bool ()
    val rx_dataOut_payload_fragment_data_0      = out Bits ((512 bits))
    val rx_dataOut_payload_fragment_byteNum_0   = out Bits (16 bits)
    val rx_dataOut_payload_fragment_errorCnt_0  = out Bits (16 bits)
    val rx_dataOut_payload_fragment_errorFlag_0 = out Bool ()
    val rx_dataOut_payload_fragment_tkeep_0     = out Bits (64 bits)
  }
  noIoPrefix()
  mapCurrentClockDomain(clock = io.clk, reset = io.sys_reset)

  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/udp_40G_Top.v"
  )
  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_exdes.v"
  )
  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/l_ethernet_0_mac_baser_syncer_reset.v"
  )
  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/TxFsm.v"
  )

  // addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/Sources/EthernetTx.v")
  // addRTLPath("/home/dzx/Programming/High-speed-UDP-transport-protocol/Sources/EthernetRx.v")

  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetTx.v"
  )
  addRTLPath(
    "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/EthernetRx.v"
  )
}

class TopLevel extends Component {
  val io = new Bundle {
    val gt_ref_clk_p_40MAC_0 = in Bool ()
    val sys_clk_p            = in Bool ()
    val gt_txp_out_40MAC_0   = out Bits (4 bits)
    val gt_txn_out_40MAC_0   = out Bits (4 bits)
    val pkt_clk              = out Bool ()

    val fsm_dataOut_valid_0                    = in Bool ()
    val fsm_dataOut_ready_0                    = out Bool ()
    val fsm_dataOut_payload_last_0             = in Bool ()
    val fsm_dataOut_payload_fragment_data_0    = in Bits (512 bits)
    val fsm_dataOut_payload_fragment_byteNum_0 = in Bits (16 bits)
    val fsm_dataOut_payload_fragment_tkeep_0   = in Bits (64 bits)

    val rx_dataOut_valid_0                      = out Bool ()
    val rx_dataOut_ready_0                      = in Bool ()
    val rx_dataOut_payload_last_0               = out Bool ()
    val rx_dataOut_payload_fragment_data_0      = out Bits ((512 bits))
    val rx_dataOut_payload_fragment_byteNum_0   = out Bits (16 bits)
    val rx_dataOut_payload_fragment_errorCnt_0  = out Bits (16 bits)
    val rx_dataOut_payload_fragment_errorFlag_0 = out Bool ()
    val rx_dataOut_payload_fragment_tkeep_0     = out Bits (64 bits)
  }
  val udp = new udp_40G_TOP()
  udp.io.gt_ref_clk_p_40MAC_0 := io.gt_ref_clk_p_40MAC_0
  udp.io.sys_clk_p            := io.sys_clk_p
  udp.io.gt_ref_clk_n_40MAC_0 := !io.gt_ref_clk_p_40MAC_0
  udp.io.sys_clk_n            := !io.sys_clk_p
  udp.io.pkt_clk              <> io.pkt_clk

  udp.io.gt_txp_out_40MAC_0 <> io.gt_txp_out_40MAC_0
  udp.io.gt_txn_out_40MAC_0 <> io.gt_txn_out_40MAC_0

  udp.io.gt_rxp_in_40MAC_0 <> udp.io.gt_txp_out_40MAC_0
  udp.io.gt_rxn_in_40MAC_0 <> udp.io.gt_txn_out_40MAC_0

  io.fsm_dataOut_valid_0        <> udp.io.fsm_dataOut_valid_0
  io.fsm_dataOut_ready_0        <> udp.io.fsm_dataOut_ready_0
  io.fsm_dataOut_payload_last_0 <> udp.io.fsm_dataOut_payload_last_0
  io.fsm_dataOut_payload_fragment_data_0 <> udp.io.fsm_dataOut_payload_fragment_data_0
  io.fsm_dataOut_payload_fragment_byteNum_0 <> udp.io.fsm_dataOut_payload_fragment_byteNum_0
  io.fsm_dataOut_payload_fragment_tkeep_0 <> udp.io.fsm_dataOut_payload_fragment_tkeep_0
  io.rx_dataOut_valid_0        <> udp.io.rx_dataOut_valid_0
  io.rx_dataOut_ready_0        <> udp.io.rx_dataOut_ready_0
  io.rx_dataOut_payload_last_0 <> udp.io.rx_dataOut_payload_last_0
  io.rx_dataOut_payload_fragment_data_0 <> udp.io.rx_dataOut_payload_fragment_data_0
  io.rx_dataOut_payload_fragment_byteNum_0 <> udp.io.rx_dataOut_payload_fragment_byteNum_0
  io.rx_dataOut_payload_fragment_errorCnt_0 <> udp.io.rx_dataOut_payload_fragment_errorCnt_0
  io.rx_dataOut_payload_fragment_errorFlag_0 <> udp.io.rx_dataOut_payload_fragment_errorFlag_0
  io.rx_dataOut_payload_fragment_tkeep_0 <> udp.io.rx_dataOut_payload_fragment_tkeep_0

  val packetClockDomain = new ClockDomain(clock = io.pkt_clk)
}

class EthernetTestbench extends AnyFunSuite {
  var compiled: SimCompiled[TopLevel] = null
  test("compile") {
    EthernetRxMain.main(Array("Sources"))
    EthernetTxMain.main(Array("Sources"))
    compiled = SimConfig.withWave.withXSim
      // .addSimulatorFlag("-part xcvu13p-fhgb2104-2-i")
      // .addSimulatorFlag("-d SIM")
      .withXSimSourcesPaths(
        ArrayBuffer(
          "/home/dzx/Programming/High-speed-UDP-transport-protocol/VIVADO/Sources/ip/"
        ),
        ArrayBuffer("")
      )
      .compile(new TopLevel)
  }

  test("testbench") {
    compiled.doSim(dut => {
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
        fork {
          dut.packetClockDomain.waitRisingEdge()
          println(s"${dut.io.pkt_clk.toBigInt}")
        }
        fork {
          val scoreboard = Queue[String]()
          val stimulusFragment = Queue[String]()
          val outputFragment = Queue[String]()
          def extractDataFromFragments(q: Queue[String]): String = {
            var ret = ""
            while (q.nonEmpty) ret = ret + q.dequeue()
            ret
          }

          io.dataIn.payload.last #= false

          fork {
            while (true) {
              dut.clockDomain.waitSampling()
              io.dataIn.valid.randomize()

              if (io.dataIn.valid.toBoolean && io.dataIn.ready.toBoolean) {
                stimulusFragment.enqueue(
                  io.dataIn.payload.data.toBigInt.toString(16)
                )
                if (io.dataIn.payload.last.toBoolean) {
                  val stimulus = extractDataFromFragments(stimulusFragment)
                  scoreboard.enqueue(stimulus)
                  println(Console.RED + s"Stimulus:\n${stimulus}")
                }
                io.dataIn.payload.last.randomize()
                io.dataIn.payload.fragment.data.randomize()
              }
            }
          }

          fork {
            while (true) {
              dut.clockDomain.waitSampling()
              io.dataOut.ready.randomize()

              if (io.dataOut.valid.toBoolean && io.dataOut.ready.toBoolean) {
                  outputFragment.enqueue(
                    io.dataOut.payload.data.toBigInt.toString(16)
                  )
                if (io.dataOut.payload.last.toBoolean) {
                  val output = extractDataFromFragments(outputFragment)
                  println(Console.BLUE + s"Output:\n${output}")
                  assert(
                    scoreboard.nonEmpty && scoreboard.dequeue().equals(output)
                  )
                }
              }
            }
          }
        }
        dut.clockDomain.waitSampling()
      }
      simSuccess()
    })
    assert(true)
  }
}
