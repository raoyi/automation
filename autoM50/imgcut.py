# pip install pywin32
from win32 import win32gui, win32print
from win32.lib import win32con
from PIL import ImageGrab
import sys

def get_real_resolution():
    """获取真实的分辨率"""
    hDC = win32gui.GetDC(0)
    # 横向分辨率
    w = win32print.GetDeviceCaps(hDC, win32con.DESKTOPHORZRES)
    # 纵向分辨率
    h = win32print.GetDeviceCaps(hDC, win32con.DESKTOPVERTRES)
    return w, h

screensize = get_real_resolution()

img = ImageGrab.grab()
img = ImageGrab.grab(bbox=(0, 0, screensize[0]/4, screensize[1]/4))
img.save(sys.argv[1])
