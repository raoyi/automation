# 自动连Wifi
# pip install pywifi
# pip install comtypes

import pywifi
from pywifi import const
import time
import configparser
class GetINI:
    #'提供读写ini类型文件和读取值得一些方法'
    def __init__(self):
        #'实例化ConfigParser()对象'
        self.conf = configparser.ConfigParser()

    def Read(self, inifilename):
        #'读取ini文件'
        self.conf.read(inifilename,encoding="utf-8")

    #'获取指定section中option的值，返回为string类型'
    def Get(self,section,option):
        return self.conf.get(section,option)

def is_connected(wifi_inter):
    if wifi_inter.status() in [const.IFACE_CONNECTED, const.IFACE_INACTIVE]:
        return True
    else:
        return False


def connet_wifi(wifi_inter, wifi_profile):
    wifi_inter.remove_all_network_profiles()  # 删除其它配置文件
    tmp_profile = wifi_inter.add_network_profile(wifi_profile)  # 加载配置文件
    wifi_inter.connect(tmp_profile)
    time.sleep(2)
    if wifi_inter.status() == const.IFACE_CONNECTED:
        return True
    else:
        return False


def set_profile():
    wifi_profile = pywifi.Profile()  # 配置文件
    wifi_profile.ssid = name  # wifi名称
    wifi_profile.auth = const.AUTH_ALG_OPEN  # 需要密码
    wifi_profile.akm.append(const.AKM_TYPE_WPA2PSK)  # 加密类型
    wifi_profile.cipher = const.CIPHER_TYPE_CCMP  # 加密单元
    wifi_profile.key = pw  # wifi密码
    return wifi_profile

iniInfo = GetINI()
iniInfo.Read('wifi.ini')
name = iniInfo.Get('Config','ssid')
pw = iniInfo.Get('Config','password')
#print(name, pw)

if __name__ == '__main__':
    wifi = pywifi.PyWiFi()
    interface = wifi.interfaces()[0]
    profile = set_profile()
    n = 0
    state = True
    while state:
        if not is_connected(interface):
            #print('网络已断开，重新连接中……')
            con = connet_wifi(interface, profile)
            n += 1
            if not con and n <= 3:
                continue
            else:
                res = 'success' if con else 'fail'
                print(f'Try {n} times, connect {res}!')
                n = 0
                if res == 'success':
                    state = False
        time.sleep(2)
