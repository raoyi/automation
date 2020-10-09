#!/usr/bin/env python3

import cv2
import tkinter.messagebox
import configparser
import re
import os
import time
from datetime import datetime
from threading import Thread

def error(msg):
    root = tkinter.Tk()
    root.withdraw() # hide main window
    tkinter.messagebox.showerror('ERROR',msg)
    os._exit(0)

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

# 处理中的qrstrx列表的ID
strindex = 0

# 设置截图间隔时间
if 'shotinterval' in conf['Settings']:
    try:
        if int(conf['Settings']['shotinterval']) > 0:
            shotinterval = int(conf['Settings']['shotinterval'])
    except:
        error('SHOTINTERVAL should be int>0 !!!')

# 设置autoexit标记
autoexit = conf['Settings']['autoexit'].upper()
if autoexit != 'Y':
    autoexit = 'N'

count_experiments = 1

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象
if cap.isOpened():
    frame = cap.read()[1]
else:
    error('camera initialization failed !!!')

prev_result = ''

def shot():
    if os.path.exists('debug') == False:
        os.mkdir('debug')
    while True:
        imgname = str(datetime.now().strftime('%H:%M:%S.%f'))+'.jpg'
        cv2.imwrite('./debug/'+imgname, frame)
        time.sleep(shotinterval/1000)

thread = Thread(target=shot)
if 'shotinterval' in locals().keys():
    thread.start()

# cv2.isOpened()检查是否初始化成功，返回布尔值
while True:  # 循环读取每一帧
    if qrstrx[0] != '' and strindex < len(qrstrx):
        frame = cv2.putText(frame, 'waitQR'+str(qrstrx[strindex]), (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 1)
    
    cv2.imshow("QrDetector - V3.0 | Author:RaoYi", frame)  # 窗口显示，并设置窗口标题

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    for i in range(count_experiments):
        # 检测与识别
        try:
            result_detection = cv2.QRCodeDetector().detectAndDecode(frame)[0]
        except cv2.error:
            pass

        if result_detection:
            if qrstrx[0] == ''and result_detection != prev_result:
                ff = open('scanlog.txt', 'a')
                ff.write(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())+' get string : '+result_detection+'\n')
                ff.close()
                prev_result = result_detection

            if strindex < len(qrstrx) and qrstrx[strindex].count(result_detection) != 0:
                # 将二维码内容写入文件
                f = open('result.txt', 'w')
                f.write(result_detection)
                f.close()
                if strindex < len(qrstrx):
                    strindex = strindex + 1
                if strindex >= len(qrstrx) and autoexit == 'Y':
                    cap.release()   # 释放摄像头
                    cv2.destroyAllWindows() # 删除建立的全部窗口
                    os._exit(0)

    if k == 27: # 若检测到按键 ‘Esc’，退出
        break

cap.release()  # 释放摄像头
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
