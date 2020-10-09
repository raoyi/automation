#!/usr/bin/env python3

import cv2
import tkinter.messagebox
import configparser
import re
import os
import time
from datetime import datetime

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
if not 'qrstrx' in locals().keys():
    qrstrx = []

# 处理中的qrstrx列表的ID
strindex = 0

# 设置autoexit标记
if 'autoexit' in conf['Settings']:
    autoexit = conf['Settings']['autoexit'].upper()
    if autoexit != 'Y':
        autoexit = 'N'

# 设置保存视频标记
if 'saveavi' in conf['Settings']:
    saveavi = conf['Settings']['saveavi'].upper()
    if saveavi == 'Y':
        if os.path.exists('debug') == False:
            os.mkdir('debug')
    else:
        saveavi = 'N'
else:
    saveavi = 'N'

# 设置保存二维码图片标记
if 'qrpic' in conf['Settings']:
    qrpic = conf['Settings']['qrpic'].upper()
    if qrpic == 'Y':
        if os.path.exists('qrpic') == False:
            os.mkdir('qrpic')
    else:
        qrpic = 'N'
else:
    qrpic = 'N'

count_experiments = 1

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象

##############################
if saveavi == 'Y':
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    fps = 24
    size = (int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    out = cv2.VideoWriter('debug\\'+str(len(os.listdir('debug'))+1)+'.avi', fourcc, fps, size)
##############################

prev_result = ''

# cv2.isOpened()检查是否初始化成功，返回布尔值
while(cap.isOpened()):  # 循环读取每一帧
    frame = cap.read()[1]
    if len(qrstrx) != 0 and strindex < len(qrstrx):
        frame = cv2.putText(frame, 'waitQR'+str(qrstrx[strindex]), (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 1)
    
    cv2.imshow("QrDetector - 20201009 | Author:RaoYi", frame)  # 窗口显示，并设置窗口标题

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    #####################
    if saveavi == 'Y':
        out.write(frame)
    #####################
    
    for i in range(count_experiments):
        # 检测与识别
        try:
            result_detection = cv2.QRCodeDetector().detectAndDecode(frame)[0]
        except cv2.error:
            pass

        if result_detection:
            if result_detection != prev_result:
                if qrpic == 'Y':
                    cv2.imwrite('qrpic\\'+str(len(os.listdir('qrpic'))+1)+'.jpg', frame)
                ff = open('scanlog.txt', 'a')
                ff.write(datetime.now().strftime('[%Y/%m/%d-%H:%M:%S.%f]')+' get string : '+result_detection+'\n')
                ff.close()
                prev_result = result_detection
                if qrstrx == [] and autoexit == 'Y':
                    cap.release()   # 释放摄像头
                    cv2.destroyAllWindows() # 删除建立的全部窗口
                    os._exit(0)

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
if saveavi == 'Y':
    out.release()
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
