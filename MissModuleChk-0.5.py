import os
import subprocess
import xml.etree.ElementTree as ET
import tkinter as tk
from  tkinter import filedialog
from tkinter.messagebox import *

window=tk.Tk()
window.title('MissModuleChk for LNB - v0.5')
window.geometry('400x130')
window.resizable(False,False)
    
tk.Label(window,text="XML Path:").place(x=10,y=15)
var_name = tk.StringVar() #文件输入路径变量
lab_show = tk.StringVar()   #显示信息

entry_name=tk.Entry(window,textvariable=var_name,width=31,state='readonly')
entry_name.place(x=80,y=15)

#输入文件路径
def selectPath_file():
    path_ = filedialog.askopenfilename(title='Select XML', filetypes=[("XML files",[".xml"])])
    var_name.set(path_)
    if var_name.get() == '':
        lab_show.set('Select XML and click Start.')
    elif var_name.get() != '':
        tree = ET.parse(var_name.get())
        root = tree.getroot()
        lab_show.set('Process : 0 / '+str(len(root)))

def start():
    # 0 pass, 1 fail
    res = subprocess.call('ping 100.105.16.2 -n 1',shell=True,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    if (res == 0) and (var_name.get() != ''):
        lab_show.set('Accessing preload server...')
        # create net use Z
        subprocess.call('net use * /del /y',shell=True,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        subprocess.call('net use Z: \\\\100.105.16.2\\cpp2\\Images sx=123 /user:administrator',shell=True,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        if os.path.exists('MissModule.txt'):
            os.remove('MissModule.txt')
        tree = ET.parse(var_name.get())
        root = tree.getroot()

        count = 0
        missnum = 0
        
        with open('MissModule.txt', 'w') as f:
            for Module in root:
                count+=1
                aodname = Module.get("aod")
                if os.path.exists('z:\\'+aodname+'.cri') == False:
                    missnum+=1
                    f.write(aodname+'\n')
                lab_show.set('Process : '+str(count)+' / '+str(len(root)))
        if missnum == 0:
            showinfo('Result','Calm, no module missing.')
        else:
            showinfo('Result','Finished, '+str(missnum)+' module missing.\nListed in MissModule.txt')
    elif res == 1:
        showerror('Error','Cannot access LNB preload server!')
    elif var_name.get() == '':
        showerror('Error','XML path is blank!')

tk.Button(window, text = "Select XML", command = selectPath_file).place(x=310,y=10)
tk.Label(window,textvariable=lab_show).place(x=10,y=60)
tk.Button(window, text = "Start Check", command = start).place(x=250,y=50)

tk.Label(window,text="Feedback: yi.rao@samxvm.com").place(x=10,y=90)

window.mainloop()