import psutil
import os

# 杀进程 ffplay.exe

pid_list = psutil.pids()
for i in pid_list:
	ps_name = (psutil.Process(i)).name()
	if ps_name == 'ffplay.exe':
		taskkill_cmd = 'TASKKILL /F /IM '+ps_name+' /T'
		os.system(taskkill_cmd)


