#!/usr/bin/python3

import cv2
import configparser
import os
import time

conf = configparser.ConfigParser()
conf.read('QrDetector.ini',encoding='utf-8')

setchar = conf.get('Settings','setchar')
separator = conf.get('Settings','separator')

if 'debug' in conf.options("Settings"):
    debug = conf.get('Settings','debug')
    if debug == 'Y' or debug == 'y':
        debug = 'Y'
else:
    debug = 'N'
        
setchar = setchar.split(separator)

count_experiments = 1

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象

# cap.set(3, 960)
# cap.set(4, 960)

def display(im, bbox):
    n = len(bbox)
    for j in range(n):
        cv2.line(im, tuple(bbox[j][0]), tuple(bbox[(j + 1) % n][0]), (255, 0, 0), 3)

prev_result = ''

# cv2.isOpened()检查是否初始化成功，返回布尔值
while(cap.isOpened()):  # 循环读取每一帧

    ret,frame = cap.read()

    cv2.imshow("QrDetector - V2.0 | Author:RaoYi", frame)  # 窗口显示，并设置窗口标题

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    for i in range(count_experiments):
        # 检测与识别
        result_detection,transform,straight_qrcode = cv2.QRCodeDetector().detectAndDecode(frame)

        if result_detection:
            if debug == 'Y' and result_detection != prev_result:
                if os.path.exists('debug') == False:
                    os.mkdir('debug')
                display(frame, transform)
                cv2.imwrite('./debug/'+str(time.time())+'.jpg', frame)
                prev_result = result_detection
                
            if setchar.count(result_detection) != 0:
                # 将二维码内容写入文件
                f = open('result.txt', 'w+')
                f.write(result_detection)
                f.close()
                #print(result_detection)

                cap.release()  # 释放摄像头
                cv2.destroyAllWindows()  # 删除建立的全部窗口
                os._exit(0)

    if k == 27: # 若检测到按键 ‘Esc’，退出
        break

cap.release()  # 释放摄像头
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
