# 二维码生成器 2.1 版

### changelog:

**v2.1**

开放ini文件可以设置 QRCode 显示位置

**v2.0**

应产线要求，当检查到LID测试log后才退出二维码

### ini 文件说明：

- pox：QRCode展示位置X轴，可选，默认为X轴最大值
- poy：QRCode展示位置Y轴，可选，默认为0
- bompath：BOM路径
- mackey：MAC键名
- modelkey：MODEL键名
- panelkey：PANELTYPE信息
- imgsize：二维码尺寸
- timeout：二维码显示时长，当 exitflag 启用时无效
- separator：二维码信息分隔符
- exitflag：退出标志文件，当文件存在时退出二维码，可选
- imgname：保存的二维码图片文件名，可选