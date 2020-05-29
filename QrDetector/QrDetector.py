#!/usr/bin/python3

import cv2
import os

count_experiments = 1

# 0是默认的笔记本摄像头ID
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 创建一个 VideoCapture 对象

# cap.set(3, 960)
# cap.set(4, 960)

def display(im, bbox):
    n = len(bbox)
    for j in range(n):
        cv2.line(im, tuple(bbox[j][0]), tuple(bbox[(j + 1) % n][0]), (255, 0, 0), 3)

    # Display results
    # cv2.imshow("Results", im)

# cv2.isOpened()检查是否初始化成功，返回布尔值
while(cap.isOpened()):  # 循环读取每一帧

    ret,frame = cap.read()

    cv2.imshow("QRCode Detector", frame)  # 窗口显示，显示名为 QRCode Detector

    k = cv2.waitKey(1) & 0xFF  # 每帧数据延时 1ms，延时不能为 0，否则读取的结果会是静态帧

    for i in range(count_experiments):
        # 检测与识别
        result_detection,transform,straight_qrcode = cv2.QRCodeDetector().detectAndDecode(frame)

        if result_detection:
            # 将二维码内容写入文件
            f = open('result.txt', 'w+')
            f.write(result_detection)
            f.close()
            #print(result_detection)
            
            # 画线存图
            display(frame, transform)
            cv2.imwrite('result.jpg', frame)
            cap.release()  # 释放摄像头
            cv2.destroyAllWindows()  # 删除建立的全部窗口
            os._exit(0)

    #if k == ord('q'):  # 若检测到按键 ‘q’，退出
    if k == 27: # 若检测到按键 ‘Esc’，退出
        break

cap.release()  # 释放摄像头
cv2.destroyAllWindows()  # 删除建立的全部窗口
os._exit(0)
