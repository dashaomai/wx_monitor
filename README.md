# wx_monitor

基于 itchat 开发的微信群聊天内容监控工具。

将指定的群（wx_monitor/chatrooms 表内容）进行监控，然后把其中的文本消息及语音消息，保存到数据库内（wx_monitor/text_messages、recording_messages）

程序基于 python 3.6.x 开发，需要安装以下插件：
1. pip3 install itchat
1. pip3 install mysql-connector-python --allow-external mysql-connector-python

如果 mysql-connector-python 安装失败，可以试试另外一个替代驱动：
pip3 install mysql-connector

### 执行
将需要监控的群名称保存于数据库：wx_monitor/chatrooms 表内，运行 src/wx_monitor.py，扫码登录微信即可
