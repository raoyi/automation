import datetime
datetime.timedelta(days=0,seconds=0,microseconds=0,milliseconds=0,minutes=0,hours=0,weeks=0)
nowDate = datetime.datetime.now()
# 将时间调慢2小时
updateDate = nowDate - datetime.timedelta(hours=2)
print(updateDate)

delta = nowDate - updateDate
print(delta.days)
# 输出 0
print(delta.seconds)
# 输出 7200

