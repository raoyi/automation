from bs4 import BeautifulSoup

htmlfile = open('C:/Users/RaoYi/Desktop/SerialPort/sleepstudy/123.html','r',encoding='utf-8')
soup=BeautifulSoup(htmlfile,'html.parser')

res = soup.find_all(name='td', attrs={'class':"percentLowPowerStateTime"})

out_list = []

for i in range(len(res)):
	res[i].find('xsl-text')
	x = (res[i].getText()).strip()
	if x != '-':
		out_list.append(x)

print(out_list)


"""
# 从列表b中删除与列表a相同的元素
a = ['1','2','3','4','5']
b = ['1','2','3','4','5','1','2']
for i in a:
	if i in b:
		b.remove(i)

if len(b) == 0:
	print('no different!')
else:
	print(b)
"""