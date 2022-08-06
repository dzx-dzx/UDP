package udp_master_stream

import spinal.sim._
import spinal.core._
import spinal.core.sim._
import java.util.Random
import spinal.core.internals.Operator
import scala.collection.mutable.Queue

object EthernetTxTestbench {
  def main(args: Array[String]): Unit = {
    val compiled = SimConfig.withWave
      .compile(
        new EthernetTx(
          ethernetTxGenerics = EthernetTxGenerics(
            destIp = 0x7f000001,       // 0xc0a8aeffL, //目的IP地址 32bit //0xc0a8ae01L
            destMac = 0x111111111111L, // 目的MAC地址 48bit
            destPort = 37984,          // 8080, //目标端口号 16bit
            srcIp = 0x7f000001,        // 0xc0a8aeffL,
            srcMac = 0x111111111101L,
            srcPort = 37985 // 37984
          )
        )
      )
      .doSim { dut =>
        {
          dut.clockDomain.forkStimulus(period = 10)
          // SimTimeout(100 * 10)
          val io = dut.io

          val reference        = Queue[String]()
          val scoreboard       = Queue[String]()
          val stimulusFragment = Queue[String]()
          val outputFragment   = Queue[String]()
          def extractDataFromFragments(q: Queue[String]): String = {
            var ret = ""
            while (q.nonEmpty) ret = ret + q.dequeue + "\n"
            ret
          }

          io.dataIn.payload.last #= false

          fork {
            while (true) {
              io.dataIn.valid.randomize()

              if (io.dataIn.valid.toBoolean && io.dataIn.ready.toBoolean) {
                stimulusFragment.enqueue(io.dataIn.payload.data.toBigInt.toString(16))
                if (io.dataIn.payload.last.toBoolean) {
                  println(s"Stimulus:\n${extractDataFromFragments(stimulusFragment)}")
                }
                io.dataIn.payload.last.randomize()
                io.dataIn.payload.fragment.data.randomize()
              }
              dut.clockDomain.waitSampling()
            }
          }

          fork {
            while (true) {
              io.dataOut.ready.randomize()

              if (io.dataOut.valid.toBoolean && io.dataOut.ready.toBoolean) {
                outputFragment.enqueue(io.dataOut.payload.data.toBigInt.toString(16))
                if (io.dataOut.payload.last.toBoolean) {
                  println(s"Output:\n${extractDataFromFragments(outputFragment)}")
                }
              }
              dut.clockDomain.waitSampling()
            }
          }
          for (_ <- 0 until 100) {
            dut.clockDomain.waitSampling()
          }
        }
      }
  }
}
