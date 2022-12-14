import sys
import serial

if (len(sys.argv) == 1) or ((sys.argv[1]).upper() == 'HELP'):
    print('Send info to serial port\n\
usage:\n\
    com.txt include required serial port, if file not exist, default COM3.\n\n\
    SendSerial.exe para1 para2 para3\n\
    para1   read/write (0/1)\n\
    para2   register address, M50~M60，D192~D196\n\
    para3   written content, value: M-reg:0/1; D-reg:0~32767\n\
    version show software verion info.')
    sys.exit()
    # os._exit()
if (sys.argv[1]).upper() == 'VERSION':
    print('Send info to serial port\nversion: 0.2.2\nChangelog:\n\
        1. Bug fixed.\n\
        2. Add read action.')
    sys.exit()
    # os._exit()

# 默认串口
try:
    with open('com.txt','r',encoding='utf-8') as f:
        port = (f.readline()).strip()
except:
    port = 'COM3'

ascii_data = [['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F'],
              ['10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '1A', '1B', '1C', '1D', '1E', '1F'],
              ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '2A', '2B', '2C', '2D', '2E', '2F'],
              ['30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '3A', '3B', '3C', '3D', '3E', '3F'],
              ['40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '4A', '4B', '4C', '4D', '4E', '4F'],
              ['50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '5A', '5B', '5C', '5D', '5E', '5F'],
              ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '6A', '6B', '6C', '6D', '6E', '6F'],
              ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '7A', '7B', '7C', '7D', '7E', '7F'],
              ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '8A', '8B', '8C', '8D', '8E', '8F'],
              ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '9A', '9B', '9C', '9D', '9E', '9F'],
              ['A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF'],
              ['B0', 'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B9', 'BA', 'BB', 'BC', 'BD', 'BE', 'BF'],
              ['C0', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'CA', 'CB', 'CC', 'CD', 'CE', 'CF'],
              ['D0', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 'DB', 'DC', 'DD', 'DE', 'DF'],
              ['E0', 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', 'EA', 'EB', 'EC', 'ED', 'EE', 'EF'],
              ['F0', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'FA', 'FB', 'FC', 'FD', 'FE', 'FF']]
 
hex_data = [['\\x00', '\\x01', '\\x02', '\\x03', '\\x04', '\\x05', '\\x06', '\\x07', '\\x08', '\\t', '\\n', '\\x0b', '\\x0c','\\r', '\\x0e', '\\x0f'],
    ['\\x10', '\\x11', '\\x12', '\\x13', '\\x14', '\\x15', '\\x16', '\\x17', '\\x18', '\\x19', '\\x1a', '\\x1b', '\\x1c', '\\x1d', '\\x1e', '\\x1f'],
    [' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/'],
    ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?'],
    ['@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'],
    ['P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\\\', ']', '^', '_'],
    ['`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'],
    ['p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '\\x7f'],
    ['\\x80', '\\x81', '\\x82', '\\x83', '\\x84', '\\x85', '\\x86', '\\x87', '\\x88', '\\x89', '\\x8a', '\\x8b', '\\x8c', '\\x8d', '\\x8e', '\\x8f'],
    ['\\x90', '\\x91', '\\x92', '\\x93', '\\x94', '\\x95', '\\x96', '\\x97', '\\x98', '\\x99', '\\x9a', '\\x9b', '\\x9c', '\\x9d', '\\x9e', '\\x9f'],
    ['\\xa0', '\\xa1', '\\xa2', '\\xa3', '\\xa4', '\\xa5', '\\xa6', '\\xa7', '\\xa8', '\\xa9', '\\xaa', '\\xab', '\\xac', '\\xad', '\\xae', '\\xaf'],
    ['\\xb0', '\\xb1', '\\xb2', '\\xb3', '\\xb4', '\\xb5', '\\xb6', '\\xb7', '\\xb8', '\\xb9', '\\xba', '\\xbb', '\\xbc', '\\xbd', '\\xbe', '\\xbf'],
    ['\\xc0', '\\xc1', '\\xc2', '\\xc3', '\\xc4', '\\xc5', '\\xc6', '\\xc7', '\\xc8', '\\xc9', '\\xca', '\\xcb', '\\xcc', '\\xcd', '\\xce', '\\xcf'],
    ['\\xd0', '\\xd1', '\\xd2', '\\xd3', '\\xd4', '\\xd5', '\\xd6', '\\xd7', '\\xd8', '\\xd9', '\\xda', '\\xdb', '\\xdc', '\\xdd', '\\xde', '\\xdf'],
    ['\\xe0', '\\xe1', '\\xe2', '\\xe3', '\\xe4', '\\xe5', '\\xe6', '\\xe7', '\\xe8', '\\xe9', '\\xea', '\\xeb', '\\xec', '\\xed', '\\xee', '\\xef'],
    ['\\xf0', '\\xf1', '\\xf2', '\\xf3', '\\xf4', '\\xf5', '\\xf6', '\\xf7', '\\xf8', '\\xf9', '\\xfa', '\\xfb', '\\xfc', '\\xfd', '\\xfe', '\\xff']]

# 地址字典
address_dic = {'D192':'1180','D193':'1182','D194':'1184','D195':'1186','D196':'1188'}
m_content_dic = {'M50':'30,34,30,30','M51':'30,43,30,30','M52':'31,34,30,30',
                'M53':'32,34,30,30','M54':'34,34,30,30','M55':'38,34,30,30',
                'M56':'30,34,30,31','M57':'30,34,30,32','M58':'30,34,30,34',
                'M59':'30,34,30,38','M60':'30,34,31,30'}

def ascii_to_hex_dict(ascii_data=ascii_data,hex_data=hex_data):#对应的字典编码
    ascii_to_hex_dict={}
    for i in range(len(ascii_data)):
        for j in range(len(ascii_data[0])):
            name=ascii_data[i][j]
            name_value=hex_data[i][j]
            ascii_to_hex_dict[name]=name_value
    return ascii_to_hex_dict
 
def hex_to_ascii_dict(ascii_data=ascii_data,hex_data=hex_data):#对应的字典编码
    hex_to_ascii_dict={}
    for i in range(len(ascii_data)):
        for j in range(len(ascii_data[0])):
            name=hex_data[i][j]
            name_value=ascii_data[i][j]
            hex_to_ascii_dict[name]=name_value
    return hex_to_ascii_dict

def hex_to_dec(string_num):#16进制变成10进制
    # print(string_num.upper())#如果输入的16进制中有小写，则通过upper将小写字符换成大写字符
    # int('A',16)#将16进制的转化成10进制
    result=str(int(string_num.upper(), 16))
    return result

def dec_to_hex(string_num):#10进制变成16进制，（'10'）
    base = [str(x) for x in range(10)] + [chr(x) for x in range(ord('A'), ord('A') + 6)]#对应的16进制编码(0-9,A-F)
    num = int(string_num)#对输入的数据进行int转化
    mid = []
    while True:#通过不断的除以16取余数实现10进制转16进制
        if num == 0: break#如果商为0则停止循环
        num, rem = divmod(num, 16)#对输入的10进制数进行：取整，取余
        mid.append(base[rem])#将余数转化成对应的16进制数，并添加到数组中
    return ''.join([str(x) for x in mid[::-1]])#字符串拼接并取反，最后返回16进制数

def to_hexstring(data='0123456789ABCDEF'):  # 字符转ASCII
    result=''
    for i in data:
        tmp=hex(ord(i))[2:].upper()
        if len(tmp)==1:
            result += str(0)+str(tmp) + ' '
        else:
            result+=str(tmp)+' '
    return result

def to_asciistring(data='31 32 33 41 42 43'):   # ASCII转字符
    data=data.split(' ')
    result=''
    datalength=len(data)
    for i in range(datalength):
        #print(data[i])
        tmp = chr(int(data[i], 16))
        result += tmp
    return result

#############################################
# ascii列表
asc_list = ['02']

# 判断读写，第一个参数，读为0，写为1
if sys.argv[1] == '1':
    asc_list.append('31')
elif sys.argv[1] == '0':
    asc_list.append('30')

# print(asc_list)

# 从字典中找地址对应的编号，字符串
#################################################################
if (sys.argv[2])[0].upper() == 'M':
    address = '0106'
elif (sys.argv[2])[0].upper() == 'D':
    address = address_dic[(sys.argv[2]).upper()]

address_hex = ((to_hexstring(data=address)).strip()).split(' ')
for x in address_hex:
    asc_list.append(x)
# print(asc_list)
#################################################################

# 添加 bit 位数
asc_list.append('30')
asc_list.append('32')

if sys.argv[1] == '1':  # 如果为写操作，则最后一个参数为写入的内容
    if (sys.argv[2])[0].upper() == 'D':
        # 10转16
        res = dec_to_hex(sys.argv[-1])

        # 高位补0
        if len(res) == 0:
            res_16 = '0000'
        elif len(res) == 1:
            res_16 = '000'+res
        elif len(res) == 2:
            res_16 = '00'+res
        elif len(res) == 3:
            res_16 = '0'+res
        elif len(res) == 4:
            res_16 = res
        else:
            print('ERROR!')

        # print('res_16 = '+res_16)

        # 16转ascii
        res_asc = to_hexstring(res_16)
        res_asc = (res_asc.strip()).split(' ')
        res_asc = res_asc[-2:]+res_asc[:2]
        # print(res_asc)

    elif (sys.argv[2])[0].upper() == 'M':
        if sys.argv[-1] == '1':
            res_asc = m_content_dic[(sys.argv[2]).upper()]
        elif sys.argv[-1] == '0':
            if sys.argv[2] == 'M50':
                res_asc = '30,30,30,30'
            else:
                res_asc = '30,34,30,30'
        res_asc = (res_asc.strip()).split(',')

    # 加入数组
    for x in res_asc:
        asc_list.append(x)

# 结束标记 03
asc_list.append('03')

# print(asc_list)

# 算总和
# 计算16进制的和，[1:]表示已经除掉第一位 02
check_sum_str = hex(sum([int(i, 16) for i in asc_list[1:]]))
check_sum_str = check_sum_str.upper()
# print(check_sum_str)    # string

# 将 check_sum_str 后2位转为 ASCII
sum_asc = to_hexstring(data=check_sum_str[-2:])
# print(sum_asc)

sum_asc = (sum_asc.strip()).split(' ')
for x in sum_asc:
    asc_list.append(x)

# 列表 asc_list 转为字符串
send_hex = ' '.join(asc_list)
# print(send_hex)
# 转为字符，以待发送
send_str = to_asciistring(data=send_hex)
print(send_str)


# 端口配置
ser = serial.Serial(
    port,
    baudrate = 9600,
    bytesize = 7,
    parity = serial.PARITY_EVEN,
    stopbits = 1,
    timeout = None,
    xonxoff = 0,
    rtscts = 0,
    interCharTimeout = None
    )

# print(ser)

if ser.isOpen():
    ser.write(send_str.encode())
    ser_out = ser.read()
    print(ser_out)
    # print(ser_out.encode('hex'))
else:
    print('Serial Port Open ERROR!')
