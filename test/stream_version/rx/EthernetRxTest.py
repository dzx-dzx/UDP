import cocotb
import random
from socket import *
from struct import *
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.result import TestSuccess, TestFailure
from cocotb.triggers import RisingEdge
from queue import Queue

# from remote_pdb import RemotePdb
# rpdb = RemotePdb("127.0.0.1", 4000)

BYTE_WIDTH = 8
DATA_WIDTH = 512
KEEP_WIDTH = 64
IP_ETH_WIDTH = 32

# MAC
PREAMBLE = 0x55555555555555
SFD = 0xD5
DEST_MAC = 0x111111111111
SRC_MAC = 0x111111111111
MAC_WIDTH = 48
ETH_TYPE = 0x0800
ETH_TYPE_WIDTH = 16

MAC_ETH_LENGTH = 22

# IP
IHL_WIDTH = 4
TOS = 0x0
TOS_WIDTH = 8
TOTAL_LEN_WIDTH = 16
FLAG_WIDTH = 3
DEFF_WIDTH = 13
PROTO_WIDTH = 8
UDP_CHECKSUM_WIDTH = 16
UDP_CHECKSUM = 0x0
IP_ETH_LENGTH = 20

# UDP
PORT_WIDTH = 16
UDP_ETH_LENGTH = 8

ETH_TOTAL_LENGTH = MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH


class RxTopTester:
    def __init__(self, target) -> None:
        self.dut = target
        self.rxDataQueue = Queue()
        self.aimResult = Queue()
        self.recvQ = Queue()

    async def reset_dut(self):
        dut = self.dut
        dut.reset.value = 0
        await RisingEdge(dut.clk)
        dut.reset.value = 1
        for i in range(10):
            await RisingEdge(dut.clk)
        dut.reset.value = 0

    async def socket_package(self):
        def eth_split(
            version,
            ihl,
            total_len,
            data_id,
            flag,
            deff,
            ttl,
            proto,
            head_checksum,
            src_ip,
            dest_ip,
            udp_length,
        ):
            # MAC
            eth_mac = (
                (
                    (
                        ((((PREAMBLE << BYTE_WIDTH) + SFD) << MAC_WIDTH) + DEST_MAC)
                        << MAC_WIDTH
                    )
                    + SRC_MAC
                )
                << ETH_TYPE_WIDTH
            ) + ETH_TYPE
            # IP
            eth_ip_0 = (
                ((((version << IHL_WIDTH) + ihl) << TOS_WIDTH) + TOS) << TOTAL_LEN_WIDTH
            ) + total_len
            eth_ip_1 = (((data_id << FLAG_WIDTH) + flag) << DEFF_WIDTH) + deff
            eth_ip_2 = (
                ((ttl << PROTO_WIDTH) + proto) << UDP_CHECKSUM_WIDTH
            ) + head_checksum
            eth_ip_3 = src_ip
            eth_ip_4 = dest_ip
            eth_ip = (
                (
                    (
                        (
                            (((eth_ip_0 << IP_ETH_WIDTH) + eth_ip_1) << IP_ETH_WIDTH)
                            + eth_ip_2
                        )
                        << IP_ETH_WIDTH
                    )
                    + eth_ip_3
                )
                << IP_ETH_WIDTH
            ) + eth_ip_4
            # UDP
            eth_udp = (
                ((((src_port << PORT_WIDTH) + dest_port) << PORT_WIDTH) + udp_length)
                << PORT_WIDTH
            ) + UDP_CHECKSUM

            eth = (
                ((eth_mac << (IP_ETH_LENGTH * BYTE_WIDTH)) + eth_ip)
                << (UDP_ETH_LENGTH * BYTE_WIDTH)
            ) + eth_udp
            return eth

        udp_socket = socket(AF_INET, SOCK_RAW, IPPROTO_UDP)
        local_addr = ("127.0.0.1", 37984)

        udp_socket.bind(local_addr)

        udp_socket.setsockopt(IPPROTO_IP, IP_HDRINCL, 1)

        recv_data = udp_socket.recvfrom(65535)  #
        print(recv_data)
        while recv_data[1][0]!="127.0.0.1":
            recv_data = udp_socket.recvfrom(65535)
            print(recv_data)

        data = recv_data[0]  # 存储接收到的数据
        msg = data[28:]

        ip_header = unpack("!BBHHHBBH4s4s", data[0:20])
        print(ip_header)

        s_addr = inet_ntoa(ip_header[-2])
        src_ip = int.from_bytes(ip_header[-2], "big")

        d_addr = inet_ntoa(ip_header[-1])
        dest_ip = int.from_bytes(ip_header[-1], "big")

        v_h = "{:0>8}".format(str(bin(ip_header[0]))[2:])
        version = int("0b" + v_h[0:4], 2)
        ihl = int("0b" + v_h[4:], 2)

        deff = ip_header[1]

        total_len = ip_header[2]

        data_id = ip_header[3]

        flag = ip_header[4]

        ttl = ip_header[5]

        proto = ip_header[6]

        head_checksum = ip_header[7]

        udp_header = unpack("!HH", data[20:24])

        src_port = udp_header[0]
        dest_port = udp_header[1]

        udp_length = len(msg) + 8

        eth = eth_split(
            version,
            ihl,
            total_len,
            data_id,
            flag,
            deff,
            ttl,
            proto,
            head_checksum,
            src_ip,
            dest_ip,
            udp_length,
        )

        udp_socket.close()
        data_in_fragment = eth << (DATA_WIDTH - ETH_TOTAL_LENGTH * BYTE_WIDTH)
        # print(hex(data_in_fragment))
        data_in_keep = ((2**ETH_TOTAL_LENGTH) - 1) << (KEEP_WIDTH - ETH_TOTAL_LENGTH)
        # print(hex(data_in_keep))
        data_in_last = False
        self.rxDataQueue.put([data_in_fragment, data_in_keep, data_in_last])  # 以太网帧头
        data_num = len(msg) * BYTE_WIDTH // DATA_WIDTH
        data_mod = len(msg) * BYTE_WIDTH % DATA_WIDTH

        for i in range(data_num):
            data_512bit = ""
            for j in range(DATA_WIDTH // BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[i * 64 + j])
                data_512bit = data_512bit + data_8bit
            data_in_fragment = int(data_512bit, base=2)
            data_in_keep = (2**KEEP_WIDTH) - 1
            if data_mod == 0 and (i == data_num - 1):
                data_in_last = True
            else:
                data_in_last = False
            self.rxDataQueue.put([data_in_fragment, data_in_keep, data_in_last])
            self.aimResult.put([data_in_fragment, data_in_keep, data_in_last])

        if data_mod != 0:
            data_512bit = ""
            for k in range(data_mod // BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[k - 1])
                data_512bit = data_8bit + data_512bit
            data_in_fragment = int(data_512bit, base=2) << (DATA_WIDTH - data_mod)
            data_in_keep = (2 ** (data_mod // BYTE_WIDTH)) - 1 << (
                KEEP_WIDTH - data_mod // BYTE_WIDTH
            )
            data_in_last = True
            self.rxDataQueue.put([data_in_fragment, data_in_keep, data_in_last])
            self.aimResult.put([data_in_fragment, data_in_keep, data_in_last])

    async def input_drv(self):
        dut = self.dut
        edge = RisingEdge(dut.clk)
        while not self.rxDataQueue.empty():
            dut.io_dataIn_valid.setimmediatevalue(1)
            dut.io_dataOut_ready.setimmediatevalue(random.random() > 0.3)
            if dut.io_dataIn_valid.value & dut.io_dataIn_ready.value:
                data_rx = self.rxDataQueue.get()
                data = data_rx[0]
                tkeep = data_rx[1]
                last = data_rx[2]
                dut.io_dataIn_payload_fragment_data.setimmediatevalue(data)
                dut.io_dataIn_payload_fragment_tkeep.setimmediatevalue(tkeep)
                dut.io_dataIn_payload_last.setimmediatevalue(last)
            await edge

    async def task_mon(self):
        dut = self.dut
        edge = RisingEdge(dut.clk)
        flag = 0
        while True:
            if dut.io_dataOut_valid.value & dut.io_dataOut_ready.value:
                cocotb.log.info("get a transaction in Output Monitor")
                self.recvQ.put(
                    [
                        int(str(dut.io_dataOut_payload_fragment_data.value), 2),
                        int(str(dut.io_dataOut_payload_fragment_tkeep.value), 2),
                        bool(dut.io_dataOut_payload_last.value),
                    ]
                )

            if dut.io_dataOut_payload_last.value:
                if self.recvQ.empty():
                    raise TestFailure("Ethernet frame header mismatch")
                else:
                    while not self.aimResult.empty():
                        recvQ_data = self.recvQ.get()
                        aimResult_data = self.aimResult.get()
                        if recvQ_data != aimResult_data:
                            flag = flag + 1
                    if flag == 0:
                        raise TestSuccess("pass")
                    else:
                        raise TestFailure("Failure")
            await edge


@cocotb.test(timeout_time=200000, timeout_unit="ns")
async def eth_rx_test(dut):
    await cocotb.start(Clock(dut.clk, 10, "ns").start())
    # rpdb.set_trace()

    # set default values to all dut input ports
    dut.io_dataIn_valid.value = False
    dut.io_dataIn_payload_fragment_data.value = 0
    dut.io_dataIn_payload_fragment_tkeep.value = 0
    dut.io_dataIn_payload_last.value = False

    dut.io_dataOut_ready.value = False

    # start testing
    tester = RxTopTester(dut)
    await tester.reset_dut()
    await Timer(100, "ns")
    await cocotb.start(tester.socket_package())
    await cocotb.start(tester.input_drv())
    await cocotb.start(tester.task_mon())

    while True:
        await RisingEdge(dut.clk)
