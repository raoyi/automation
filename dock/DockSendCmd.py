import sys
# pip install pyserial
import serial

reg_dic = {'R104':'PLC提醒工控机复位软件','R105':'PLC提醒工控机可以测试了','R106':'工控机提醒PLC测试已经结束了','R107':'PLC提醒工控机收到测试信号',\
'R108':'PLC提醒工控机收到接口号','R111':'T1从公座拔到母座','R112':'T1从母座拔出','R113':'T1插入母座','R114':'T1从母座到公座','R115':'按电脑键盘',\
'R116':'按小键盘','R117':'按电脑电源开机键','R118':'移动鼠标','R119':'升起相机','R120':'下降相机','R121':'合盖轴开盖','R122':'合盖轴合盖',\
'R129':'发送接口位号拉高','R130':'机械手回待机位(机型顶上相机拍照时）','R132':'U1头至母座','R133':'U1头从母座拔出','R134':'U1头插入母座',\
'R135':'U1头从母座到公座','R136':'H1从头拔到母座','R137':'H1从母座拔出','R138':'H1插入母座','R139':'H1从母座拔到公座','R140':'DP1从公拔到母座',\
'R141':'DP1从母座拔起','R142':'DP1插入母座','R143':'DP1从母座插到公座','R144':'H2从头座拔到母座','R145':'H2头从母座拔起','R146':'H2插入母座',\
'R147':'H2从母座拔到到公座','R150':'DP2从公拔到母座','R151':'DP2从母座拔起','R152':'DP2插入母座','R153':'DP2从母座插到公座','DT112':'T1母座位号  1~4',\
'DT114':'U1母座位号  1~4','DT116':'DP1母座位号  1~10','DT118':'H1母座位号  1~10','DT120':'DP2母座位号  1~10','DT122':'H2母座位号  1~10'}

if (len(sys.argv) == 1) or ((sys.argv[1]).upper() == 'HELP'):
    print('Send command to PLC for dock automation.\n\
usage:\n\
    com.txt include required serial port, if file not exist, default COM3.\n\n\
    SendSerial.exe param [value]\n\
    param:\n\
    registerAddress\n\
        Rxxx : set value 1\n\
        DTxxx : int, default set value 1\n\
    list    show register address list\n\
    version show software verion info.')
    sys.exit()
    # os._exit()
if (sys.argv[1]).upper() == 'VERSION':
    print('Send command to PLC for dock automation.\nversion: 230228')
    sys.exit()
    # os._exit()
if (sys.argv[1]).upper() == 'LIST':
    print('Register address list:')
    for x in reg_dic.keys():
        print(x,'\t',reg_dic[x])
    sys.exit()

# 默认串口
try:
    with open('com.txt','r',encoding='utf-8') as f:
        port = (f.readline()).strip()
except:
    port = 'COM3'

def to_hexstring(data='0123456789ABCDEF'):  # 字符转ASCII
    result=''
    for i in data:
        tmp=hex(ord(i))[2:].upper()
        if len(tmp)==1:
            result += str(0)+str(tmp) + ' '
        else:
            result+=str(tmp)+' '
    return result
#############################################
if sys.argv[1].upper() in reg_dic.keys():
    if sys.argv[1].upper()[0] == 'R':
        pre = 'CSR0'+sys.argv[1][-3:]+'1'
    elif sys.argv[1].upper()[0] == 'D':
        pre = 'DD00'+sys.argv[1][-3:]+'00'+sys.argv[1][-3:]
        if len(sys.argv) == 2:
            pre = pre+'0100'
        else:
            if sys.argv[2].isdigit():
                if sys.argv[1][-3:] == '112' or sys.argv[1][-3:] == '114':
                    if int(sys.argv[2]) < 5 and int(sys.argv[2]) > 0:
                        pre = pre+'0'+sys.argv[2]+'00'
                    else:
                        print(sys.argv[1].upper(),'accept 1~4, default value 1')
                        sys.exit()
                else:
                    if int(sys.argv[2]) < 10 and int(sys.argv[2]) > 0:
                        pre = pre+'0'+sys.argv[2]+'00'
                    elif int(sys.argv[2]) == 10:
                        pre = pre+'0A00'
                    else:
                        print(sys.argv[1].upper(),'accept 1~10, default value 1')
                        sys.exit()
            else:
                print('DT register accept int as parameter, default value 1')
                sys.exit()
else:
    print('Register address list:')
    for x in reg_dic.keys():
        print(x,'\t',reg_dic[x])
    sys.exit()

send_str = '%01#W'+pre

send_asc = to_hexstring(data=send_str)
#print(send_asc)
asc_list = send_asc.strip().split(' ')
#print(asc_list)

bcc = '0'
for i in asc_list:
    bcc = hex(int(bcc,16)^int(i,16))
bcc = bcc[-2:].upper()
#print(bcc)

send_str = send_str+bcc+'\r'
print(send_str)

# 端口配置
ser = serial.Serial(
    port,
    baudrate = 115200,
    bytesize = 8,
    parity = serial.PARITY_NONE,
    stopbits = 1,
    timeout = None,
    xonxoff = 0,
    rtscts = 0,
    interCharTimeout = None
    )

#print(ser)

if ser.isOpen():
    ser.write(send_str.encode())
    ser_out = ser.read()
    print(ser_out)
else:
    print('Serial Port Open ERROR!')
