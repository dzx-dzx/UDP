package udp_master_stream

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import scala.collection.mutable.Queue

class EthernetRxTestbench extends AnyFunSuite {
  var compiled: SimCompiled[EthernetRx] = null
  test("compile") {
    compiled = SimConfig.withWave
      .withConfig(SpinalConfig(targetDirectory = "rtl"))
      .compile(
        new EthernetRx(
          ethernetRxGenerics = EthernetRxGenerics(
            destIp = 0x7f000001,       // 0xc0a8aeffL, //目的IP地址 32bit
            destMac = 0x111111111111L, // 目的MAC地址 48bit
            destPort = 37984           // 目标端口号 16bit
          )
        )
      )
  }
  test("testbench") {
    compiled.doSim { dut =>
      {
        dut.clockDomain.forkStimulus(period = 10)
        // SimTimeout(100 * 10)
        val io = dut.io

        val scoreboard       = Queue[String]()
        val stimulusFragment = Queue[String]()
        val outputFragment   = Queue[String]()
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
              if (io.dataIn.payload.last.toBoolean) {
                io.dataIn.payload.fragment.data #= BigInt(
                  "55555555555555d511111111111111111111110108004500218b0099400040115f877f0000017f00000194619460217700000000000000000000000000000000",
                  16
                )
                io.dataIn.payload.last #= false
              } else {
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
        for (_ <- 0 until 1000) {
          dut.clockDomain.waitSampling()
        }
      }
    }
  }
}
