#!/usr/bin/env python
# -*- coding: utf-8 -*-
#Runing with Python3
import os
import qrcode
import tkinter
from PIL import Image, ImageTk
import configparser
import threading
import time

conf = configparser.ConfigParser()
conf.read('qrinfo.ini')

if 'imgname' in conf.options("Settings"):
    imgname = conf.get('Settings','imgname')
else:
    imgname = ''

if 'separator' in conf.options("Settings"):
    separator = conf.get('Settings','separator')
else:
    separator = ''

bompath = conf.get('Settings','bompath')
mackey = conf.get('Settings','mackey')
modelkey = conf.get('Settings','modelkey')
imgsize = conf.getint('Settings','imgsize')
timeout = conf.getint('Settings','timeout')

file = open(bompath,'r')
for line in file.readlines():
    if mackey in line:
        mac = line.split('=')[1].replace('\n','').strip()
    if modelkey in line:
        model = line.split('=')[1].replace('\n','').strip()
file.close()
mactype = mac+separator+model
#print(mactype)

#set QR
qr = qrcode.QRCode(
    #version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    #box_size=10,
    border=1,
)

#create QR, change size and output image
qr.add_data(mactype)
qr.make(fit=True)
img = qr.make_image()
(x,y) = img.size
img = img.resize((imgsize,imgsize), Image.ANTIALIAS)

if imgname != '':
    img.save(imgname)

#create window
uisize = str(imgsize)+"x"+str(imgsize)

root = tkinter.Tk()
#set window top
root.wm_attributes('-topmost',1)
#hide the title bar
root.overrideredirect(True)

imglb = ImageTk.PhotoImage(img)
tkinter.Label(root, image=imglb).pack(side="top")

sw = str(root.winfo_screenwidth()-imgsize)

root.geometry(uisize+"+"+sw+"+0")

def autoClose():
    time.sleep(timeout)
    root.destroy()

t = threading.Thread(target=autoClose)
t.start()
root.mainloop()
os._exit(0)

