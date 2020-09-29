import configparser
import re

conf = configparser.ConfigParser()
conf.read('QrDetector.ini',encoding='utf-8')

separator = conf['Settings']['separator']

for key in conf['Settings']:
    if re.match("str\d+",key):
        try:
            strx
        except NameError:
            strx = []
        strx.append(conf['Settings'][key].split(separator))
print(strx)
for i in range(len(strx)):
    print(strx[i])
    
