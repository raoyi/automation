import configparser
import re

conf = configparser.ConfigParser()
conf.read('QrDetector.ini',encoding='utf-8')

#separator = conf['Settings']['separator']

for key in conf['Settings']:
    if re.match("qrstr\d+",key):
        try:
            qrstrx
        except NameError:
            qrstrx = []
        qrstrx.append(conf['Settings'][key].split(conf['Settings']['separator']))
print(qrstrx)
for i in range(len(qrstrx)):
    print(qrstrx[i])
