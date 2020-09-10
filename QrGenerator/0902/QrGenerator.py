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

imgsize = conf.getint('Settings','imgsize')

if 'separator' in conf.options("Settings"):
    separator = conf.get('Settings','separator')
else:
    separator = ''
    
if 'exitflag' in conf.options("Settings"):
    exitflag = conf.get('Settings','exitflag')
else:
    exitflag = ''

if 'pox' in conf.options("Settings"):
    pox = conf.get('Settings','pox')
else:
    pox = ''

if 'poy' in conf.options("Settings"):
    poy = conf.get('Settings','poy')
else:
    poy = ''
    
if exitflag == '':
    root = tkinter.Tk()
    root.withdraw() # hide main window
    tkinter.messagebox.showerror('ERROR','exit flag not exist!')
    os._exit(4)
    
#bom key settings
bompath = conf.get('BOMinfo','bompath')
uutidkey = conf.get('BOMinfo','uutidkey')
modelkey = conf.get('BOMinfo','modelkey')
panelkey = conf.get('BOMinfo','panelkey')
kbbglval = conf.get('BOMinfo','kbbglval').split(',')
gskuval = conf.get('BOMinfo','gskuval')

if not isinstance(imgsize,int):
    root = tkinter.Tk()
    root.withdraw() # hide main window
    tkinter.messagebox.showerror('ERROR','imgsize in INI file must be int!')
    os._exit(1)

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
    root = tkinter.Tk()
    root.withdraw() # hide main window
    tkinter.messagebox.showerror('ERROR','BOM.BAT NOT EXIST or BOMPATH ERROR!')
    os._exit(3)

strings = separator.join([uutid, model, panel, kbbgl, gskuflag])
#print(strings)

def esc():
    root.destroy()
    os._exit(0)

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
root.bind_all("<Escape>", lambda event: esc())
root.mainloop()
os._exit(0)
