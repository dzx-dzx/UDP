package udp_master_stream

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import scala.collection.mutable.Queue

class EthernetTxTestbench extends AnyFunSuite {
  var compiled: SimCompiled[EthernetTx] = null
  test("compile") {
    compiled = SimConfig.withWave
      .withConfig(SpinalConfig(targetDirectory = "rtl"))
      .compile(
        new EthernetTx(
          ethernetTxGenerics = EthernetTxGenerics(
            destIp = 0x7f000001, // 0xc0a8aeffL, //目的IP地址 32bit //0xc0a8ae01L
            destMac = 0x111111111111L, // 目的MAC地址 48bit
            destPort = 37984,          // 8080, //目标端口号 16bit
            srcIp = 0x7f000001,        // 0xc0a8aeffL,
            srcMac = 0x111111111101L,
            srcPort = 37985 // 37984
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

        def createHeader(headerRaw: BigInt) = {
          import EthernetProtocolConstant._
          var positionInHeaderString = 0

          val SEGMENTS_WIDTH = List(
            // MAC
            PREAMBLE_SDF_WIDTH,
            MAC_WIDTH,
            MAC_WIDTH,
            ETH_TYPE_WIDTH,
            // IP
            VERSION_IHL_WIDTH,
            TOS_WIDTH,
            TOTAL_LENGTH_WIDTH,
            IDENTIFICATION_WIDTH,
            FLAGS_FRAGMENT_OFFSET_WIDTH,
            TTL_PROTOCOL_WIDTH,
            HEADER_CHECKSUM_WIDTH,
            IP_WIDTH,
            IP_WIDTH,
            // UDP
            PORT_WIDTH,
            PORT_WIDTH,
            UDP_LENGTH_WIDTH,
            UDP_CHECKSUM_WIDTH
          )

          val SEGMENTS = List(
            // MAC
            "preambleSdf",
            "destMac",
            "srcMac",
            "ethType",
            // IP
            "versionIhl",
            "tos",
            "totalLength",
            "identification",
            "flagsFragmentOffset",
            "ttlProtocol",
            "headerCheckSum",
            "srcIp",
            "destIp",
            // UDP
            "srcPort",
            "destPort",
            "udpLength",
            "udpCheckSum"
          )

          var header = Map[String, String]()

          for (i <- 0 until SEGMENTS.length) {
            header += (
              SEGMENTS(i) ->
                //   (
                //     (headerRaw >> (bitLength - SEGMENTS_WIDTH(i) - positionInHeaderString))
                //       & (BigInt(1) << SEGMENTS_WIDTH(i) - 1)
                //   ).toString(16)
                headerRaw
                  .toString(2)
                  .slice(
                    positionInHeaderString,
                    positionInHeaderString + SEGMENTS_WIDTH(i)
                  )
            )
            println(
              (
                SEGMENTS(i),
                SEGMENTS_WIDTH(i),
                ("0" + headerRaw.toString(2)) // Leading zero...
                  .slice(
                    positionInHeaderString,
                    positionInHeaderString + SEGMENTS_WIDTH(i)
                  )
              )
            )
            positionInHeaderString += SEGMENTS_WIDTH(i)
          }
          header
        }
        var isHeader = true

        io.dataIn.payload.last #= false

        fork {
          while (true) {
            dut.clockDomain.waitSampling()

            if (!io.dataIn.valid.toBoolean) io.dataIn.valid.randomize()
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
              io.dataIn.valid.randomize()
            }
          }
        }

        fork {
          while (true) {
            dut.clockDomain.waitSampling()
            io.dataOut.ready.randomize()

            if (io.dataOut.valid.toBoolean && io.dataOut.ready.toBoolean) {
              if (!isHeader)
                outputFragment.enqueue(
                  io.dataOut.payload.data.toBigInt.toString(16)
                )
              else {
                println(
                  Console.YELLOW + s"Header:${io.dataOut.payload.data.toBigInt.toString(16)}"
                )
                createHeader(io.dataOut.payload.data.toBigInt)
              }
              if (io.dataOut.payload.last.toBoolean) {
                val output = extractDataFromFragments(outputFragment)
                println(Console.BLUE + s"Output:\n${output}")
                assert(
                  scoreboard.nonEmpty && scoreboard.dequeue().equals(output)
                )
                isHeader = true
              } else {
                isHeader = false
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
