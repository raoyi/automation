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

settings = ['pox','poy','imgsize','separator','exitflag','imgname']
for i in settings:
    globals()[i] = ''

config = configparser.ConfigParser()
config.read(name+'.ini',encoding='utf-8')

# variables assignment
globals().update(dict(config._sections['Settings']))
globals().update(dict(config._sections['BOMinfo']))

def error(msg):
    root = tkinter.Tk()
    root.withdraw() # hide main window
    tkinter.messagebox.showerror('ERROR',msg)
    os._exit(0)
    
try:
    imgsize = int(imgsize)
except ValueError:
    error('imgsize in INI file must be int!')
else:
    pass

if exitflag == '':
    error('exit flag not exist!')

# check BOM
if os.path.exists(bompath):
    with open(bompath,'r',encoding='utf-8') as file:
        if file.read().find(gskuval) == -1:
            gskuflag = 'N'
        else:
            gskuflag = 'Y'

        file.seek(0)
        for line in file.readlines():
            if uutidkey+'=' in line:
                uutid = line.split('=')[1].replace('\n','').strip()

            if modelkey+'=' in line:
                model = line.split('=')[1].replace('\n','').strip()

            if panelkey+'=' in line:
                panel = line.split('=')[1].replace('\n','').strip()
                if panel == 'N/A':
                    panel = 'N'
                else:
                    panel = 'Y'

            if 'KBPN'+'=' in line:
                kbpn = line.split('=')[1].replace('\n','').strip()
                kbbglflag = kbpn[-3]
                if kbbglval.count(kbbglflag) != 0:
                    kbbgl = 'Y'
                else:
                    kbbgl = 'N'

    file.close()
else:
    error('BOM.BAT NOT EXIST or BOMPATH ERROR!')

strings = separator.join([uutid, model, panel, kbbgl, gskuflag])
#print(strings)

# set QR
qr = qrcode.QRCode(
    #version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    #box_size=10,
    border=1,
)

# create QR, change size and output image
qr.add_data(strings)
qr.make(fit=True)
img = qr.make_image()
(x,y) = img.size
img = img.resize((imgsize,imgsize), Image.ANTIALIAS)

if imgname != '':
    img.save(imgname)

# create window
uisize = str(imgsize)+"x"+str(imgsize)

root = tkinter.Tk()
# set window top
root.wm_attributes('-topmost',1)
# hide the title bar
root.overrideredirect(True)

imglb = ImageTk.PhotoImage(img)
tkinter.Label(root, image=imglb).pack(side="top")

if pox == '':
    pox = str(root.winfo_screenwidth()-imgsize)
if poy == '':
    poy = str(0)
    
root.geometry(uisize+"+"+pox+"+"+poy)

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
root.bind_all("<Escape>", lambda event: root.destroy())
root.mainloop()
os._exit(0)
