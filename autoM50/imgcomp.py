# https://blog.csdn.net/qq_38641985/article/details/118304624

# pip install opencv-python
import cv2
import numpy as np
import sys

# 通过得到RGB每个通道的直方图来计算相似度
def classify_hist_with_split(image1, image2, size=(256, 256)):
    # 将图像resize后，分离为RGB三个通道，再计算每个通道的相似值
    image1 = cv2.resize(image1, size)
    image2 = cv2.resize(image2, size)
    sub_image1 = cv2.split(image1)
    sub_image2 = cv2.split(image2)
    sub_data = 0
    for im1, im2 in zip(sub_image1, sub_image2):
        sub_data += calculate(im1, im2)
    sub_data = sub_data / 3
    return sub_data


# 计算单通道的直方图的相似值
def calculate(image1, image2):
    hist1 = cv2.calcHist([image1], [0], None, [256], [0.0, 255.0])
    hist2 = cv2.calcHist([image2], [0], None, [256], [0.0, 255.0])
    # 计算直方图的重合度
    degree = 0
    for i in range(len(hist1)):
        if hist1[i] != hist2[i]:
            degree = degree + (1 - abs(hist1[i] - hist2[i]) / max(hist1[i], hist2[i]))
        else:
            degree = degree + 1
    degree = degree / len(hist1)
    return degree



def main():
    if (len(sys.argv) == 1) or ((sys.argv[1]).upper() == 'HELP'):
        print('Compare the difference between the two pictures.\n\
usage:\n\
    imgcomp.exe para1 para2 [para3]\n\
    para1   picture 1\n\
    para2   picture 2\n\
    para3   log name or path. if not exist, print result to terminal.\n\
    eg: imgcomp.exe 1.jpg .\log\2.jpg comp.log\n\n\
    version show software verion info.')
        sys.exit()
        # os._exit()
    if (sys.argv[1]).upper() == 'VERSION':
        print('Compare the difference between the two pictures.\nversion: 0.1\nChangelog:\n\
    1. Add help info.')
        sys.exit()
        # os._exit()

    img1 = cv2.imread(sys.argv[1])
    img2 = cv2.imread(sys.argv[2])
    n = classify_hist_with_split(img1, img2)
    if type(n) == float:
        res = 'same'
    elif n[0] < 0.7:
        res = 'different'
    else:
        res = 'similar'

    if len(sys.argv == 4):
        with open(sys.argv[3],'w') as f:
            f.write(res)
    elif len(sys.argv == 3):
        print(res)

if __name__=="__main__":
    main()
