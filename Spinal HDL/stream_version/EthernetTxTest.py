import cocotb
import random
from socket import * #导入socket模块
from struct import *  #导入解包加密包的模块
import math
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.result import TestSuccess, TestFailure
from cocotb.triggers import RisingEdge
from queue import Queue
from collections import deque

BYTE_WIDTH = 8
DATA_WIDTH = 512
KEEP_WIDTH = 64
IP_ETH_WIDTH = 32

#MAC报头
HEX_WIDTH = 2
PREAMBLE_HEX_WIDTH = HEX_WIDTH + 7*HEX_WIDTH
SFD_HEX_WIDTH = PREAMBLE_HEX_WIDTH + HEX_WIDTH
DEST_MAC_HEX_WIDTH = SFD_HEX_WIDTH + 6*HEX_WIDTH
SRC_MAC_HEX_WIDTH = DEST_MAC_HEX_WIDTH + 6*HEX_WIDTH
ETH_TYPE_HEX_WIDTH = SRC_MAC_HEX_WIDTH + 2*HEX_WIDTH

#IP报头
VERSION_HEX_WIDTH = ETH_TYPE_HEX_WIDTH + 1
IHL_HEX_WIDTH = VERSION_HEX_WIDTH + 1
TOS_HEX_WIDTH = IHL_HEX_WIDTH + HEX_WIDTH
TOTAL_LEN_HEX_WIDTH = TOS_HEX_WIDTH + 2*HEX_WIDTH
ID_HEX_WIDTH = TOTAL_LEN_HEX_WIDTH + 2*HEX_WIDTH
FLAG_DEFF_HEX_WIDTH = ID_HEX_WIDTH + 2*HEX_WIDTH
TTL_HEX_WIDTH = FLAG_DEFF_HEX_WIDTH + HEX_WIDTH
PROTO_HEX_WIDTH = TTL_HEX_WIDTH + HEX_WIDTH
CHECKSUM_HEX_WIDTH = PROTO_HEX_WIDTH + 2*HEX_WIDTH
SRC_IP_HEX_WIDTH = CHECKSUM_HEX_WIDTH + 4*HEX_WIDTH
DEST_IP_HEX_WIDTH = SRC_IP_HEX_WIDTH + 4*HEX_WIDTH

#UDP报头
SRC_PORT_HEX_WIDTH = DEST_IP_HEX_WIDTH + 2*HEX_WIDTH
DEST_PORT_HEX_WIDTH = SRC_PORT_HEX_WIDTH + 2*HEX_WIDTH
UDP_LENGTH_HEX_WIDTH = DEST_PORT_HEX_WIDTH + 2*HEX_WIDTH



class TxTopTester:
    def __init__(self, target) -> None:  # -> None为没有返回值
        self.dut = target
        self.txDataQueue = Queue()
        self.aimResult = Queue()
        self.recvQ = deque()

    async def reset_dut(self):
        dut = self.dut
        dut.reset.value = 0
        await RisingEdge(dut.clk)
        dut.reset.value = 1
        for i in range(10):
            await RisingEdge(dut.clk)
        dut.reset.value = 0

    async def data_input(self):
        #msg_data = random.random()
        msg_data = 0x112233445566778899112233445566778899
        msg = bytes(str(msg_data), encoding='UTF-8')
        data_num = len(msg)*BYTE_WIDTH // DATA_WIDTH
        data_mod = len(msg)*BYTE_WIDTH % DATA_WIDTH

        for i in range(data_num):
            data_512bit = ''
            for j in range(DATA_WIDTH//BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[i*64+j])
                data_512bit = data_512bit + data_8bit
            data_in_fragment = int(data_512bit, base=2)
            data_in_keep = (2**KEEP_WIDTH) -1
            if(data_mod == 0 & (i ==data_num-1)):
                data_in_last = True
            else:
                data_in_last = False
            self.txDataQueue.put([data_in_fragment,data_in_keep, data_in_last])
            self.aimResult.put([data_in_fragment,data_in_keep, data_in_last])

        if(data_mod != 0):
            data_512bit = ''
            for k in range(data_mod//BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[k-1])
                data_512bit = data_8bit + data_512bit
            data_in_fragment = int(data_512bit, base=2) << (DATA_WIDTH - data_mod)
            data_in_keep = (2**(data_mod//BYTE_WIDTH)) -1 << (KEEP_WIDTH-data_mod//BYTE_WIDTH)
            data_in_last = True
            self.txDataQueue.put([data_in_fragment,data_in_keep, data_in_last])
            self.aimResult.put([data_in_fragment,data_in_keep, data_in_last])

    async def input_drv(self):
        dut = self.dut
        edge = RisingEdge(dut.clk)
        while not self.txDataQueue.empty():
            dut.io_dataIn_valid.setimmediatevalue(1)
            random.seed(2)
            rand = random.random() > 0.3
            dut.io_dataOut_ready.setimmediatevalue(rand)
            if dut.io_dataIn_valid.value & dut.io_dataIn_ready.value:
                data_rx = self.txDataQueue.get()
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
        while True:
            if dut.io_dataOut_valid.value & dut.io_dataOut_ready.value:
                cocotb.log.info("get a transaction in Output Monitor")
                self.recvQ.append([int(str(dut.io_dataOut_payload_fragment_data.value),2), int(str(dut.io_dataOut_payload_fragment_tkeep.value),2),bool(dut.io_dataOut_payload_last.value)])

            if dut.io_dataOut_payload_last.value:
                dataOut_eth = self.recvQ.popleft()
                eth = hex(dataOut_eth[0])
                #MAC
                preamble = eth[HEX_WIDTH:PREAMBLE_HEX_WIDTH]
                sdf = eth[PREAMBLE_HEX_WIDTH:SFD_HEX_WIDTH]
                dest_mac = eth[SFD_HEX_WIDTH:DEST_MAC_HEX_WIDTH]
                src_mac = eth[DEST_MAC_HEX_WIDTH:SRC_MAC_HEX_WIDTH]
                eth_type = eth[SRC_MAC_HEX_WIDTH:ETH_TYPE_HEX_WIDTH]
                #IP
                # version = int(eth[ETH_TYPE_HEX_WIDTH:VERSION_HEX_WIDTH],16)
                # ihl = int(eth[VERSION_HEX_WIDTH:IHL_HEX_WIDTH],16)
                version_ihl = int(eth[ETH_TYPE_HEX_WIDTH:IHL_HEX_WIDTH],16)
                tos = int(eth[IHL_HEX_WIDTH:TOS_HEX_WIDTH],16)
                total_len = int(eth[TOS_HEX_WIDTH:TOTAL_LEN_HEX_WIDTH],16)
                data_id = int(eth[TOTAL_LEN_HEX_WIDTH:ID_HEX_WIDTH],16)
                flag_deff = int(eth[ID_HEX_WIDTH:FLAG_DEFF_HEX_WIDTH],16)
                flag = int(bin(flag_deff)[2:4],2)
                deff = int(bin(flag_deff)[4:],2)
                ttl = int(eth[FLAG_DEFF_HEX_WIDTH:TTL_HEX_WIDTH],16)
                proto = int(eth[TTL_HEX_WIDTH:PROTO_HEX_WIDTH],16)
                head_checksum = int(eth[PROTO_HEX_WIDTH:CHECKSUM_HEX_WIDTH],16)
                src_ip = inet_aton(inet_ntoa(pack('I',htonl(int(eth[CHECKSUM_HEX_WIDTH:SRC_IP_HEX_WIDTH],16)))))
                dest_ip = inet_aton(inet_ntoa(pack('I',htonl(int(eth[SRC_IP_HEX_WIDTH:DEST_IP_HEX_WIDTH],16)))))
                #UDP
                src_port = int(eth[DEST_IP_HEX_WIDTH:SRC_PORT_HEX_WIDTH],16)
                print(src_port)
                dest_port = int(eth[SRC_PORT_HEX_WIDTH:DEST_PORT_HEX_WIDTH],16)
                udp_length = int(eth[DEST_PORT_HEX_WIDTH:UDP_LENGTH_HEX_WIDTH],16)

                udp_socket = socket(AF_INET, SOCK_RAW ,IPPROTO_UDP)

                local_addr = ('127.0.0.1',src_port) #ip地址和端口号，ip一般不用写，表示本机的任何一个ip  元组

                udp_socket.bind(local_addr)

                udp_socket.setsockopt(IPPROTO_IP,IP_HDRINCL,1)# 此选项设置使用我们自己构造的IP头部

                ip_eth = pack('!BBHHHBBH4s4s',version_ihl,deff,total_len,data_id,flag,ttl,proto,head_checksum,src_ip,dest_ip)
                udp_eth = pack('!HHH',src_port,dest_port,udp_length)
                dest_ip_addr = inet_ntoa(pack('I',htonl(int(eth[SRC_IP_HEX_WIDTH:DEST_IP_HEX_WIDTH],16))))


                data = ''
                data_len = len(self.recvQ)
                for i in range (data_len):
                    data = data + str(self.recvQ.popleft()[0])
                print(data[1:])

                data_byte=data.encode('utf-8')
                udp_socket.sendto(ip_eth+udp_eth+data_byte,(dest_ip_addr,dest_port))

                aim_data = ''
                while not self.aimResult.empty():
                    aim_data = aim_data + str(self.aimResult.get()[0])
                print(aim_data)

                if (aim_data == data[1:]):
                    raise TestSuccess("pass")
                else:
                    raise TestFailure("Failure")
            await edge

@cocotb.test(timeout_time=200000, timeout_unit="ns")
async def eth_tx_test(dut):
    await cocotb.start(Clock(dut.clk, 10, "ns").start())

    # set default values to all dut input ports
    dut.io_dataIn_valid.value = False
    dut.io_dataIn_payload_fragment_data.value = 0
    dut.io_dataIn_payload_fragment_tkeep.value = 0
    dut.io_dataIn_payload_last.value = False

    dut.io_dataOut_ready.value = False

    # start testing
    tester = TxTopTester(dut)
    await tester.reset_dut()
    await Timer(100, "ns")
    await cocotb.start(tester.data_input())
    await cocotb.start(tester.input_drv())
    await cocotb.start(tester.task_mon())

    while True:
        await RisingEdge(dut.clk)