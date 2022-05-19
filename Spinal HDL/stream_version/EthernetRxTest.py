# import cocotb
# import random
# import socket
# import math
# from cocotb.triggers import Timer
# from cocotb.clock import Clock
# from cocotb.result import TestSuccess, TestFailure
# from cocotb.triggers import RisingEdge
# from queue import Queue
#
# PREAMBLE_SDF = 0x55555555555555d5
# DEST_MAC = 0x111111111111
# ETH_TYPE = 0x0800
# DEST_IP = "192.168.31.110"
# DEST_PORT = 37984
# IP_HEAD_1 = 0x450000320000200040110000
#
#
#
#
# IP_HEAD_LENGTH = 28
#
#
# class RxTopTester:
#     def __init__(self, target) -> None:  # -> None为没有返回值
#         self.dut = target
#         self.rxDataQueue = Queue()
#         self.aimResult = Queue()
#         self.recvQ = Queue()
#         self.recvMty = Queue()
#
#     async def reset_dut(self):
#         dut = self.dut
#         dut.reset.value = 0
#         await RisingEdge(dut.clk)
#         dut.reset.value = 1
#         for i in range(10):
#             await RisingEdge(dut.clk)
#         dut.reset.value = 0
#
#     async def udp_transaction(self):
#         # while True:
#         # sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # Internet  # UDP
#         sock = socket.socket(socket.AF_INET,socket.SOCK_RAW, socket.SOCK_DGRAM)  # Internet  # UDP
#         sock.bind(("", DEST_PORT))
#         data_byte, addr = sock.recvfrom(2048)
#         print("received message:", data_byte, addr)
#         data = data_byte.decode("gbk")
#         src_port = "{0:016b}".format(addr[1])
#         # print(src_port)
#         dest_port = "{0:016b}".format(DEST_PORT)
#         src_ip = addr[0].split(".")
#         des_ip = DEST_IP.split(".")
#         udp_length = "{0:016b}".format(len(data) + 8)
#         preamble_sdf = "{0:064b}".format(PREAMBLE_SDF)
#         eth_type = "{0:016b}".format(ETH_TYPE)
#         dest_mac = "{0:048b}".format(DEST_MAC)
#         src_mac = "{0:048b}".format(random.randint(0, math.pow(2,48)-1))
#         ip_head_1 = "{0:096b}".format(IP_HEAD_1)
#         ip_head_2 = "{0:066b}".format(random.randint(0, math.pow(2,66)-1))
#         ip_head_last = False
#         ip_head_keep = str(bin(0x3ffffffffffff)[2:]) + "{0:014b}".format(0)
#         ip_head_fragment_str = preamble_sdf + eth_type + dest_mac + src_mac + eth_type + ip_head_1 + src_ip + des_ip + src_port + dest_port + udp_length + ip_head_2
#         ip_head_fragment = int(ip_head_fragment_str)
#         self.rxDataQueue.put([ip_head_fragment,ip_head_keep, ip_head_last])
#
#
#         data_len = math.ceil(len(data)/64)
#         data_mod = len(data)%64
#         for i in range(len(data)):
#             data_8bit = "{0:08h}".format(ord(data[i]))
#             data_fragment = data_fragment + data_8bit
#
#         for i in range(data_len):
#             ip_head_last = i == len(data_len) - 1
#             if(i == len(data) - 1):
#                 ip_head_fragment = data_fragment[128-data_mod*2:-1] +
#             else
#
#             self.rxDataQueue.put([ip_head_fragment, ip_head_last])
#             self.aimResult.put(ip_head_fragment)
#
#     async def input_drv(self):
#         dut = self.dut
#         edge = RisingEdge(dut.clk)
#         cnt = 0
#         while cnt < IP_HEAD_LENGTH:
#             data_last = []
#             if not self.rxDataQueue.empty():
#                 # dut.io_dataIn_valid.setimmediatevalue(1)
#                 # dut.io_dataOut_ready.setimmediatevalue(random.random() > 0.3)
#                 dut.io_dataIn_valid <= 1
#                 dut.io_dataOut_ready <= (random.random() > 0.3)
#                 data_last = self.rxDataQueue.get()
#                 data = data_last[0]
#                 # print(data)
#                 last = data_last[1]
#                 dut.io_dataIn_payload_fragment <= data
#                 # print(dut.io_dataIn_payload_fragment)
#                 dut.io_dataIn_payload_last <= last
#                 # await edge
#                 # if dut.io_dataIn_valid.value & dut.io_dataIn_ready.value:
#                 #     data_last = self.rxDataQueue.get()
#                 #     data = data_last[0]
#                 #     print(data)
#                 #     last = data_last[1]
#                 #     dut.io_dataIn_payload_fragment.setimmediatevalue(data)
#                 #     print(dut.io_dataIn_payload_fragment)
#                 #     dut.io_dataIn_payload_last.setimmediatevalue(last)
#             await edge
#             cnt = cnt + 1
#         while not self.rxDataQueue.empty():
#             data_last = []
#             dut.io_dataIn_valid <= 1
#             dut.io_dataOut_ready <= (random.random() > 0.3)
#             if dut.io_dataIn_valid.value & dut.io_dataIn_ready.value:
#                 data_last = self.rxDataQueue.get()
#                 data = data_last[0]
#                 last = data_last[1]
#                 dut.io_dataIn_payload_fragment <= data
#                 dut.io_dataIn_payload_last <= last
#             await edge
#
#     async def task_mon(self):
#         dut = self.dut
#         edge = RisingEdge(dut.clk)
#         case_cnt = 0
#         while True:
#             if dut.io_dataOut_valid.value & dut.io_dataOut_ready.value:
#                 cocotb.log.info("get a transaction in Output Monitor")
#                 self.recvQ.put(dut.io_dataOut_payload_fragment.value.integer)
#                 self.recvMty.put(dut.io_mty.value.binstr)
#                 # print(self.aimResult)
#                 # print(self.recvQ)
#             if dut.io_dataOut_payload_last.value:
#                 # print(self.aimResult)
#                 # print(self.recvQ)
#                 # assert self.aimResult == self.recvQ
#                 while not self.recvQ.empty():
#                     data_recv = "{0:08x}".format(self.recvQ.get())
#                     mty_recv = self.recvMty.get()
#                     print(
#                         chr(int(data_recv[0:2], 16))
#                         + chr(int(data_recv[2:4], 16))
#                         + chr(int(data_recv[4:6], 16))
#                         + chr(int(data_recv[6:], 16))
#                         + "     mty = "
#                         + mty_recv
#                     )
#                 case_cnt = case_cnt + 1
#             await edge
#
#             if case_cnt == 1:
#                 raise TestSuccess(" pass {} test cases".format(IP_HEAD_LENGTH))
#
#
# @cocotb.test(timeout_time=200000, timeout_unit="ns")
# async def rx_top_test(dut):
#     await cocotb.start(Clock(dut.clk, 10, "ns").start())
#
#     # set default values to all dut input ports
#     dut.io_dataIn_valid.value = False
#     dut.io_dataIn_payload_fragment.value = 0
#     dut.io_dataIn_payload_last.value = 0
#
#     dut.io_dataOut_ready = False
#
#     # start testing
#     tester = RxTopTester(dut)
#     await tester.reset_dut()
#     await Timer(100, "ns")
#     await cocotb.start(tester.input_drv())
#     await cocotb.start(tester.task_mon())
#     await cocotb.start(tester.udp_transaction())
#
#     while True:
#         await RisingEdge(dut.clk)

# import cocotb
# import random
# from socket import * #导入socket模块
# from struct import *  #导入解包加密包的模块
# from cocotb.triggers import Timer
# from cocotb.clock import Clock
# from cocotb.result import TestSuccess, TestFailure
# from cocotb.triggers import RisingEdge
# from queue import Queue
#
# BYTE_WIDTH = 8
# DATA_WIDTH = 512
# KEEP_WIDTH = 64
# IP_ETH_WIDTH = 32
#
# #MAC报头
# PREAMBLE = 0x55555555555555
# SFD = 0xd5
# DEST_MAC = 0x111111111111
# SRC_MAC = 0x111111111111
# MAC_WIDTH = 48
# ETH_TYPE = 0x0800
# ETH_TYPE_WIDTH = 16
#
# MAC_ETH_LENGTH = 22
#
# #IP报头
# IHL_WIDTH = 4
# TOS = 0x0
# TOS_WIDTH = 8
# TOTAL_LEN_WIDTH = 16
# FLAG_WIDTH = 3
# DEFF_WIDTH = 13
# PROTO_WIDTH = 8
# UDP_CHECKSUM_WIDTH = 16
# UDP_CHECKSUM = 0x0
# IP_ETH_LENGTH = 20
#
# #UDP报头
# PORT_WIDTH = 16
# UDP_ETH_LENGTH = 8
#
# ETH_TOTAL_LENGTH = MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH
#
# class RxTopTester:
#     def __init__(self, target) -> None:  # -> None为没有返回值
#         self.dut = target
#         self.rxDataQueue = Queue()
#         self.aimResult = Queue()
#         self.recvQ = Queue()
#
#
#     async def reset_dut(self):
#         dut = self.dut
#         dut.reset.value = 0
#         await RisingEdge(dut.clk)
#         dut.reset.value = 1
#         for i in range(10):
#             await RisingEdge(dut.clk)
#         dut.reset.value = 0
#
#     async def socket_package(self):
#
#         #1.创建一个udp套接字
#
#         udp_socket = socket(AF_INET, SOCK_RAW ,IPPROTO_UDP)
#
#         #2.绑定本地的相关信息，如果一个网络程序不绑定，则系统会随机分配
#
#         local_addr = ('',37984) #ip地址和端口号，ip一般不用写，表示本机的任何一个ip  元组
#
#         udp_socket.bind(local_addr)
#
#         udp_socket.setsockopt(IPPROTO_IP,IP_HDRINCL,1)
#
#         #设置混杂类型,必须是单张网卡
#         # udp_socket.ioctl(SIO_RCVALL, RCVALL_ON)
#
#         #3.等待接收对方发送的数据
#
#
#         recv_data = udp_socket.recvfrom(65535) #1024表示本次接收的最大字节数
#         #4.显示接收到的数据
#         data = recv_data[0]  #存储接收到的数据
#         print ('帧总长度：'+str(len(data))+'字节')
#         #提取去除IP头20字节和UDP头8字节剩余的数据内容
#         msg = data[28:]
#         print ('数据总长度：'+str(len(msg))+'字节')
#
#         #使用！BBHHHBBH4s4s解析IP头
#         ip_header = unpack('!BBHHHBBH4s4s',data[0:20])
#
#         #将十六进制的源ip地址转换成十进制的源IP
#         s_addr = inet_ntoa(ip_header[-2])
#         src_ip = int.from_bytes(ip_header[-2], "big")
#
#         #将十六进制的目的IP转换为十进制的目的IP
#         d_addr = inet_ntoa(ip_header[-1])
#         dest_ip = int.from_bytes(ip_header[-1], "big")
#
#         #提取版本及头长度
#         v_h = '{:0>8}'.format(str(bin(ip_header[0]))[2:])
#         version = int('0b'+v_h[0:4],2)
#         ihl = int('0b'+v_h[4:],2)
#
#
#         #提取数据包的区分服务位
#         deff = ip_header[1]
#
#         #获取数据包总长度
#         total_len = ip_header[2]
#
#         #获取数据包的标识
#         data_id = ip_header[3]
#
#         #获取标志位
#         flag = ip_header[4]
#
#         #获取数据包的TTL值
#         ttl = ip_header[5]
#
#         #获取上层协议
#         proto = ip_header[6]
#
#         #获取头校验和
#         head_checksum = ip_header[7]
#
#         #使用！HH解析UDP头
#         udp_header = unpack('!HH',data[20:24])
#
#         src_port = udp_header[0]
#         dest_port = udp_header[1]
#
#         print ('源IP是:'+ str(s_addr))
#
#         print ('目的IP是：'+str(d_addr))
#
#         print ('IP包的版本是：'+str(version))
#
#         print ('IP包的首部长度' + str(ihl))
#
#         print ('ip包的区分服务标记是：'+hex(deff))
#
#         print ("数据包的长度是："+str(total_len))
#
#         print ('数据包的id是：'+str(data_id))
#
#         print ('数据包的标志位是：'+str(flag))
#
#         print ('数据包的TTL值是：'+str(ttl))
#
#         print ('上层协议的编号是：'+str(proto))
#
#         print ('IP头的校验和是：'+hex(head_checksum))
#
#         print ('源端口号是：'+str(src_port))
#
#         print ('目的端口号是：'+str(dest_port))
#
#
#         try:
#             print ('数据内容是：'+msg.decode())
#         except:
#             print ('数据包的内容是：',end='')
#             print (msg)
#         print ("\n\n\n")
#
#         #MAC报头拼接
#         eth_mac = (((((((PREAMBLE << BYTE_WIDTH) + SFD) << MAC_WIDTH) + DEST_MAC) << MAC_WIDTH) + SRC_MAC) << ETH_TYPE_WIDTH) + ETH_TYPE
#         #IP报头拼接
#         eth_ip_0 = (((((version << IHL_WIDTH) + ihl) << TOS_WIDTH) + TOS) << TOTAL_LEN_WIDTH) + total_len
#         eth_ip_1 = (((data_id << FLAG_WIDTH) + flag) << DEFF_WIDTH) + deff
#         eth_ip_2 = (((ttl << PROTO_WIDTH) + proto) << UDP_CHECKSUM_WIDTH) + head_checksum
#         eth_ip_3 = src_ip
#         eth_ip_4 = dest_ip
#         eth_ip = (((((((eth_ip_0 << IP_ETH_WIDTH) + eth_ip_1) << IP_ETH_WIDTH) + eth_ip_2) << IP_ETH_WIDTH) + eth_ip_3) << IP_ETH_WIDTH) + eth_ip_4
#         #UDP报头拼接
#         eth_udp = (((((src_port << PORT_WIDTH) + dest_port) << PORT_WIDTH) + (len(msg)+8)) << PORT_WIDTH )+ UDP_CHECKSUM
#
#         #以太网帧报头
#         eth = (((eth_mac << (IP_ETH_LENGTH*BYTE_WIDTH)) + eth_ip) << (UDP_ETH_LENGTH*BYTE_WIDTH)) + eth_udp
#
#         #5.关闭套接字
#         udp_socket.close()
#         data_in_fragment = eth << (DATA_WIDTH - ETH_TOTAL_LENGTH*BYTE_WIDTH)
#         # print(hex(data_in_fragment))
#         data_in_keep = ((2**ETH_TOTAL_LENGTH) -1) << (KEEP_WIDTH-ETH_TOTAL_LENGTH)
#         # print(hex(data_in_keep))
#         data_in_last = False
#         self.rxDataQueue.put([data_in_fragment,data_in_keep, data_in_last]) #以太网帧头
#         data_num = len(msg)*BYTE_WIDTH // DATA_WIDTH
#         data_mod = len(msg)*BYTE_WIDTH % DATA_WIDTH
#
#         for i in range(data_num):
#             data_512bit = ''
#             for j in range(DATA_WIDTH//BYTE_WIDTH):
#                 data_8bit = "{0:08b}".format(msg[i*64+j])
#                 data_512bit = data_512bit + data_8bit
#             data_in_fragment = int(data_512bit, base=2)
#             data_in_keep = (2**KEEP_WIDTH) -1
#             if(data_mod == 0 & (i ==data_num-1)):
#                 data_in_last = True
#             else:
#                 data_in_last = False
#             self.rxDataQueue.put([data_in_fragment,data_in_keep, data_in_last])
#             self.aimResult.put([data_in_fragment,data_in_keep, data_in_last])
#
#         if(data_mod != 0):
#             data_512bit = ''
#             for k in range(data_mod//BYTE_WIDTH):
#                 data_8bit = "{0:08b}".format(msg[k-1])
#                 data_512bit = data_8bit + data_512bit
#             data_in_fragment = int(data_512bit, base=2) << (DATA_WIDTH - data_mod)
#             data_in_keep = (2**(data_mod//BYTE_WIDTH)) -1 << (KEEP_WIDTH-data_mod//BYTE_WIDTH)
#             data_in_last = True
#             self.rxDataQueue.put([data_in_fragment,data_in_keep, data_in_last])
#             self.aimResult.put([data_in_fragment,data_in_keep, data_in_last])
#
#     async def input_drv(self):
#         dut = self.dut
#         edge = RisingEdge(dut.clk)
#         while not self.rxDataQueue.empty():
#             dut.io_dataIn_valid.setimmediatevalue(1)
#             dut.io_dataOut_ready.setimmediatevalue(random.random() > 0.3)
#             if dut.io_dataIn_valid.value & dut.io_dataIn_ready.value:
#                 data_rx = self.rxDataQueue.get()
#                 data = data_rx[0]
#                 tkeep = data_rx[1]
#                 last = data_rx[2]
#                 dut.io_dataIn_payload_fragment_data.setimmediatevalue(data)
#                 dut.io_dataIn_payload_fragment_tkeep.setimmediatevalue(tkeep)
#                 dut.io_dataIn_payload_last.setimmediatevalue(last)
#             await edge
#
#     async def task_mon(self):
#         dut = self.dut
#         edge = RisingEdge(dut.clk)
#         flag = 0
#         while True:
#             if dut.io_dataOut_valid.value & dut.io_dataOut_ready.value:
#                 cocotb.log.info("get a transaction in Output Monitor")
#                 self.recvQ.put([int(str(dut.io_dataOut_payload_fragment_data.value),2), int(str(dut.io_dataOut_payload_fragment_tkeep.value),2),bool(dut.io_dataOut_payload_last.value)])
#
#             if dut.io_dataOut_payload_last.value:
#                 # while not self.aimResult.empty():
#                 #     recvQ_data = self.recvQ.get()
#                 #     aimResult_data = self.aimResult.get()
#                 #     if(recvQ_data != aimResult_data):
#                 #         flag = flag + 1
#                 if(flag == 0):
#                     raise TestSuccess("pass")
#                 else:
#                     raise TestFailure("Failure")
#             await edge
#
# @cocotb.test(timeout_time=200000, timeout_unit="ns")
# async def eth_rx_test(dut):
#     await cocotb.start(Clock(dut.clk, 10, "ns").start())
#
#     # set default values to all dut input ports
#     dut.io_dataIn_valid.value = False
#     dut.io_dataIn_payload_fragment_data.value = 0
#     dut.io_dataIn_payload_fragment_tkeep.value = 0
#     dut.io_dataIn_payload_last.value = False
#
#     dut.io_dataOut_ready.value = False
#
#     # start testing
#     tester = RxTopTester(dut)
#     await tester.reset_dut()
#     await Timer(100, "ns")
#     await cocotb.start(tester.socket_package())
#     await cocotb.start(tester.input_drv())
#     await cocotb.start(tester.task_mon())
#
#     while True:
#         await RisingEdge(dut.clk)
#############################################################################################
import cocotb
import random
from socket import * #导入socket模块
from struct import *  #导入解包加密包的模块
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.result import TestSuccess, TestFailure
from cocotb.triggers import RisingEdge
from queue import Queue

BYTE_WIDTH = 8
DATA_WIDTH = 512
KEEP_WIDTH = 64
IP_ETH_WIDTH = 32

#MAC报头
PREAMBLE = 0x55555555555555
SFD = 0xd5
DEST_MAC = 0x111111111111
SRC_MAC = 0x111111111111
MAC_WIDTH = 48
ETH_TYPE = 0x0800
ETH_TYPE_WIDTH = 16

MAC_ETH_LENGTH = 22

#IP报头
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

#UDP报头
PORT_WIDTH = 16
UDP_ETH_LENGTH = 8

ETH_TOTAL_LENGTH = MAC_ETH_LENGTH + IP_ETH_LENGTH + UDP_ETH_LENGTH

class RxTopTester:
    def __init__(self, target) -> None:  # -> None为没有返回值
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

        def eth_split(version,ihl,total_len,data_id,flag,deff,ttl,proto,head_checksum,src_ip,dest_ip,udp_length):
            #MAC报头拼接
            eth_mac = (((((((PREAMBLE << BYTE_WIDTH) + SFD) << MAC_WIDTH) + DEST_MAC) << MAC_WIDTH) + SRC_MAC) << ETH_TYPE_WIDTH) + ETH_TYPE
            #IP报头拼接
            eth_ip_0 = (((((version << IHL_WIDTH) + ihl) << TOS_WIDTH) + TOS) << TOTAL_LEN_WIDTH) + total_len
            eth_ip_1 = (((data_id << FLAG_WIDTH) + flag) << DEFF_WIDTH) + deff
            eth_ip_2 = (((ttl << PROTO_WIDTH) + proto) << UDP_CHECKSUM_WIDTH) + head_checksum
            eth_ip_3 = src_ip
            eth_ip_4 = dest_ip
            eth_ip = (((((((eth_ip_0 << IP_ETH_WIDTH) + eth_ip_1) << IP_ETH_WIDTH) + eth_ip_2) << IP_ETH_WIDTH) + eth_ip_3) << IP_ETH_WIDTH) + eth_ip_4
            #UDP报头拼接
            eth_udp = (((((src_port << PORT_WIDTH) + dest_port) << PORT_WIDTH) + udp_length) << PORT_WIDTH )+ UDP_CHECKSUM
            #以太网帧报头
            eth = (((eth_mac << (IP_ETH_LENGTH*BYTE_WIDTH)) + eth_ip) << (UDP_ETH_LENGTH*BYTE_WIDTH)) + eth_udp
            return  eth

        #1.创建一个udp套接字

        udp_socket = socket(AF_INET, SOCK_RAW ,IPPROTO_UDP)

        #2.绑定本地的相关信息，如果一个网络程序不绑定，则系统会随机分配

        local_addr = ('127.0.0.1',37984) #ip地址和端口号，ip一般不用写，表示本机的任何一个ip  元组

        udp_socket.bind(local_addr)

        udp_socket.setsockopt(IPPROTO_IP,IP_HDRINCL,1)

        #设置混杂类型,必须是单张网卡
        # udp_socket.ioctl(SIO_RCVALL, RCVALL_ON)

        #3.等待接收对方发送的数据


        recv_data = udp_socket.recvfrom(65535) #1024表示本次接收的最大字节数
        #4.显示接收到的数据
        data = recv_data[0]  #存储接收到的数据
        print ('帧总长度：'+str(len(data))+'字节')
        #提取去除IP头20字节和UDP头8字节剩余的数据内容
        msg = data[28:]
        print ('数据总长度：'+str(len(msg))+'字节')

        #使用！BBHHHBBH4s4s解析IP头
        ip_header = unpack('!BBHHHBBH4s4s',data[0:20])
        print(ip_header)

        #将十六进制的源ip地址转换成十进制的源IP
        s_addr = inet_ntoa(ip_header[-2])
        src_ip = int.from_bytes(ip_header[-2], "big")

        #将十六进制的目的IP转换为十进制的目的IP
        d_addr = inet_ntoa(ip_header[-1])
        dest_ip = int.from_bytes(ip_header[-1], "big")

        #提取版本及头长度
        v_h = '{:0>8}'.format(str(bin(ip_header[0]))[2:])
        version = int('0b'+v_h[0:4],2)
        ihl = int('0b'+v_h[4:],2)


        #提取数据包的区分服务位
        deff = ip_header[1]

        #获取数据包总长度
        total_len = ip_header[2]

        #获取数据包的标识
        data_id = ip_header[3]

        #获取标志位
        flag = ip_header[4]

        #获取数据包的TTL值
        ttl = ip_header[5]

        #获取上层协议
        proto = ip_header[6]

        #获取头校验和
        head_checksum = ip_header[7]

        #使用！HH解析UDP头
        udp_header = unpack('!HH',data[20:24])

        src_port = udp_header[0]
        dest_port = udp_header[1]

        print ('源IP是:'+ str(s_addr))

        print ('目的IP是：'+str(d_addr))

        print ('IP包的版本是：'+str(version))

        print ('IP包的首部长度' + str(ihl))

        print ('ip包的区分服务标记是：'+hex(deff))

        print ("数据包的长度是："+str(total_len))

        print ('数据包的id是：'+str(data_id))

        print ('数据包的标志位是：'+str(flag))

        print ('数据包的TTL值是：'+str(ttl))

        print ('上层协议的编号是：'+str(proto))

        print ('IP头的校验和是：'+hex(head_checksum))

        print ('源端口号是：'+str(src_port))

        print ('目的端口号是：'+str(dest_port))


        try:
            print ('数据内容是：'+msg.decode())
        except:
            print ('数据包的内容是：',end='')
            print (msg)
        print ("\n\n\n")


        udp_length = len(msg)+8
        #以太网帧报头
        eth = eth_split(version,ihl,total_len,data_id,flag,deff,ttl,proto,head_checksum,src_ip,dest_ip,udp_length)

        #5.关闭套接字
        udp_socket.close()
        data_in_fragment = eth << (DATA_WIDTH - ETH_TOTAL_LENGTH*BYTE_WIDTH)
        # print(hex(data_in_fragment))
        data_in_keep = ((2**ETH_TOTAL_LENGTH) -1) << (KEEP_WIDTH-ETH_TOTAL_LENGTH)
        # print(hex(data_in_keep))
        data_in_last = False
        self.rxDataQueue.put([data_in_fragment,data_in_keep, data_in_last]) #以太网帧头
        data_num = len(msg)*BYTE_WIDTH // DATA_WIDTH
        data_mod = len(msg)*BYTE_WIDTH % DATA_WIDTH

        for i in range(data_num):
            data_512bit = ''
            for j in range(DATA_WIDTH//BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[i*64+j])
                data_512bit = data_512bit + data_8bit
            data_in_fragment = int(data_512bit, base=2)
            data_in_keep = (2 ** KEEP_WIDTH) - 1
            if data_mod == 0 and (i == data_num - 1):
                data_in_last = True
            else:
                data_in_last = False
            self.rxDataQueue.put([data_in_fragment,data_in_keep, data_in_last])
            self.aimResult.put([data_in_fragment,data_in_keep, data_in_last])

        if data_mod != 0:
            data_512bit = ''
            for k in range(data_mod//BYTE_WIDTH):
                data_8bit = "{0:08b}".format(msg[k-1])
                data_512bit = data_8bit + data_512bit
            data_in_fragment = int(data_512bit, base=2) << (DATA_WIDTH - data_mod)
            data_in_keep = (2**(data_mod//BYTE_WIDTH)) -1 << (KEEP_WIDTH-data_mod//BYTE_WIDTH)
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
                self.recvQ.put([int(str(dut.io_dataOut_payload_fragment_data.value),2), int(str(dut.io_dataOut_payload_fragment_tkeep.value),2),bool(dut.io_dataOut_payload_last.value)])

            if dut.io_dataOut_payload_last.value:
                if self.recvQ.empty():
                    raise TestFailure("Ethernet frame header mismatch")
                else:
                    while not self.aimResult.empty():
                        recvQ_data = self.recvQ.get()
                        aimResult_data = self.aimResult.get()
                        if(recvQ_data != aimResult_data):
                            flag = flag + 1
                    if(flag == 0):
                        raise TestSuccess("pass")
                    else:
                        raise TestFailure("Failure")
            await edge

@cocotb.test(timeout_time=200000, timeout_unit="ns")
async def eth_rx_test(dut):
    await cocotb.start(Clock(dut.clk, 10, "ns").start())

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