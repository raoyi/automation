#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import qrcode
import tkinter, tkinter.messagebox
from PIL import Image, ImageTk
import configparser
import threading
import time

# get filename
name = os.path.split(__file__)[-1]
name = name[:name.rfind('.')]

# del log
if os.path.exists(name+'log.txt'):
    os.remove(name+'log.txt')

conf = configparser.ConfigParser()
conf.read(name+'.ini')

if 'imgname' in conf.options("Settings"):
    imgname = conf.get('Settings','imgname')
else:
    imgname = ''

if 'separator' in conf.options("Settings"):
    separator = conf.get('Settings','separator')
else:
    separator = ''

if 'timeout' in conf.options("Settings"):
    timeout = conf.getint('Settings','timeout')
else:
    timeout = ''
if 'exitflag' in conf.options("Settings"):
    exitflag = conf.get('Settings','exitflag')
else:
    exitflag = ''

if exitflag == '' and timeout == '':
    root = tkinter.Tk()
    root.withdraw() #主窗口隐藏
    tkinter.messagebox.showerror('ERROR','exit flag not exist!')
    os._exit(4)
    
bompath = conf.get('Settings','bompath')
mackey = conf.get('Settings','mackey')
modelkey = conf.get('Settings','modelkey')
panelkey = conf.get('Settings','panelkey')
imgsize = conf.getint('Settings','imgsize')

if not isinstance(imgsize,int):
    root = tkinter.Tk()
    root.withdraw() #主窗口隐藏
    tkinter.messagebox.showerror('ERROR','imgsize in INI file must be int!')
    os._exit(1)

if not isinstance(timeout,int) and timeout != '':
    root = tkinter.Tk()
    root.withdraw() #主窗口隐藏
    tkinter.messagebox.showerror('ERROR','timeout in INI file must be int or null value!')
    os._exit(2)

# check BOM
if os.path.exists(bompath):
    file = open(bompath,'r')
    for line in file.readlines():
        if mackey in line:
            mac = line.split('=')[1].replace('\n','').strip()
        if modelkey in line:
            model = line.split('=')[1].replace('\n','').strip()
        if panelkey in line:
            panel = line.split('=')[1].replace('\n','').strip()
            if panel == 'N/A':
                panel = 'N'
            else:
                panel = 'Y'
    file.close()
else:
    root = tkinter.Tk()
    root.withdraw() #主窗口隐藏
    tkinter.messagebox.showerror('ERROR','BOM.BAT NOT EXIST or BOMPATH ERROR!')
    os._exit(3)

strings = mac+separator+model+separator+panel
#print(strings)

#set QR
qr = qrcode.QRCode(
    #version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    #box_size=10,
    border=1,
)

#create QR, change size and output image
qr.add_data(strings)
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

if exitflag != '':
    def autoExit():
        time.sleep(1)
        while True:
            if os.path.exists(exitflag):
                f = open(name+'log.txt', 'w+')
                f.write('Show QRCode PASS')
                f.close()
                root.destroy()

    t = threading.Thread(target=autoExit)
    t.start()
    root.mainloop()
    os._exit(0)

if timeout != '':
    def autoClose():
        time.sleep(timeout)
        f = open(name+'log.txt', 'w+')
        f.write('Show QRCode PASS')
        f.close()
        root.destroy()

    t = threading.Thread(target=autoClose)
    t.start()
    root.mainloop()
    os._exit(0)
