import hashlib
 
# 创建MD5对象，可以直接传入要加密的数据
m = hashlib.md5('123456'.encode(encoding='utf-8'))
# m = hashlib.md5(b'123456') 与上面等价
print(hashlib.md5('123456'.encode(encoding='utf-8')).hexdigest())
print(m) 
print(m.hexdigest()) # 转化为16进制打印md5值