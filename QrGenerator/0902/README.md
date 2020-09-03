# QRCode显示工具 version 20200902

## changelog：

- 增加 ESC 键退出功能
- 增加 键盘背光标识位
- 增加 GSKU 标识位

## ini文件说明：
- pox：QRCode展示位置X轴，可选，默认为X轴最大值
- poy：QRCode展示位置Y轴，可选，默认为0
- imgsize：二维码尺寸
- separator：二维码信息分隔符
- exitflag：退出标志文件，当文件存在时退出二维码，可选
- imgname：保存的二维码图片文件名，可选
- bompath：BOM路径
- uutidkey：测试机唯一标识符键名
- modelkey：MODEL键名
- panelkey：PANELTYPE信息
- kbbglval：键盘背光标识，KBPN倒数第三位
- gskuval：用来标识GSKU的字符串

## 二维码内容格式：

UUTID(string)|机型ID(string)|是否触屏(Y/N)|是否背光键盘(Y/N)|是否GSKU(Y/N)
