#!/usr/bin/python3

import cv2
import configparser
import os
import time

conf = configparser.ConfigParser()
conf.read('QrDetector.ini',encoding='utf-8')

setchar = conf.get('Settings','setchar')
separator = conf.get('Settings','separator')
rate = conf.getint('Settings','rate')

if 'debug' in conf.options("Settings"):
    debug = conf.get('Settings','debug')
    if debug == 'Y' or debug == 'y':
        debug = 'Y'
else:
    debug = 'N'
        
setchar = setchar.split(separator)

if os.path.exists('result.txt') == True:
    os.remove('result.txt')

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象

# cv2.isOpened()检查是否初始化成功，返回布尔值
while(cap.isOpened()):  # 循环读取每一帧

    ret,frame = cap.read()

    cv2.imshow("QrDetector | Author:RaoYi", frame)  # 窗口显示，并设置窗口标题

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    if debug == 'Y':
        if os.path.exists('debug') == False:
            os.mkdir('debug')
        imgname = str(time.time())+'.jpg'
        time.sleep(rate/1000)
        cv2.imwrite('./debug/'+imgname, frame)
        img = cv2.imread('./debug/'+imgname)
        # 检测与识别
        data, bbox, rectifiedImage = cv2.QRCodeDetector().detectAndDecode(img)
    else:
        imgname = 'qrimg.jpg'
        if os.path.exists('qrimg.jpg') == True:
            os.remove('qrimg.jpg')
        time.sleep(rate/1000)
        cv2.imwrite(imgname, frame)
        img = cv2.imread(imgname)
        data, bbox, rectifiedImage = cv2.QRCodeDetector().detectAndDecode(img)

    if len(data) > 0:
        if setchar.count(data) != 0:
            # 将二维码内容写入文件
            f = open('result.txt', 'w')
            f.write(data)
            f.close()
            #print(data)

            cap.release()  # 释放摄像头
            cv2.destroyAllWindows()  # 删除建立的全部窗口
            os._exit(0)

    if k == 27: # 若检测到按键 ‘Esc’，退出
        break

cap.release()  # 释放摄像头
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
