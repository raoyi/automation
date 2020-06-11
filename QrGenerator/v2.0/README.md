# 二维码生成器 2.0 版

### changelog:

应产线要求，当检查到LID测试log后才退出二维码

### ini 文件说明：

- bompath：BOM路径
- mackey：MAC键名
- modelkey：MODEL键名
- panelkey：PANELTYPE信息
- imgsize：二维码尺寸
- timeout：二维码显示时长，当 exitflag 启用时无效
- separator：二维码信息分隔符
- exitflag：退出标志文件，当文件存在时退出二维码，可选
- imgname：保存的二维码图片文件名，可选