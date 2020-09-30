#!/usr/bin/python3

import cv2
import configparser
import re
import os

conf = configparser.ConfigParser()
conf.read('QrDetector.ini',encoding='utf-8')

# 检查是否有变量 qrstr1 等，并组成列表
for key in conf['Settings']:
    if re.match("qrstr\d+",key):
        try:
            qrstrx
        except NameError:
            qrstrx = []
        if conf['Settings'][key] != '':
            qrstrx.append(conf['Settings'][key].split(conf['Settings']['separator']))
    else:
        qrstrx = ['']

# 处理中的qrstrx列表的ID
strindex = 0

# 设置截图间隔时间
try:
    shotinterval = int(conf['Settings']['shotinterval'])
except:
    print("debug Error!!!")
if shotinterval > 0:
    debug = shotinterval

count_experiments = 1

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象

prev_result = ''

# cv2.isOpened()检查是否初始化成功，返回布尔值
while(cap.isOpened()):  # 循环读取每一帧

    frame = cap.read()[1]

    if qrstrx[0] != '':
        frame = cv2.putText(frame, 'waitQR'+str(qrstrx[0]), (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 1)
    
    cv2.imshow("QrDetector - V3.0 | Author:RaoYi", frame)  # 窗口显示，并设置窗口标题

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    for i in range(count_experiments):
        # 检测与识别
        try:
            result_detection = cv2.QRCodeDetector().detectAndDecode(frame)[0]
        except cv2.error:
            pass

        if result_detection:
            if 'debug' in locals().keys() and result_detection != prev_result:
                ff = open('scanlist.txt', 'a')
                ff.write(result_detection+'\n')
                ff.close()
                prev_result = result_detection
                
            if qrstrx[0].count(result_detection) != 0:
                # 将二维码内容写入文件
                f = open('result.txt', 'w')
                f.write(result_detection)
                f.close()

                cap.release()  # 释放摄像头
                cv2.destroyAllWindows()  # 删除建立的全部窗口
                os._exit(0)

    if k == 27: # 若检测到按键 ‘Esc’，退出
        break

cap.release()  # 释放摄像头
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
