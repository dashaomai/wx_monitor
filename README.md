# wx_monitor

基于 itchat 开发的微信群聊天内容监控工具。

将指定的群（wx_monitor/chatrooms 表内容）进行监控，然后把其中的文本消息及语音消息，保存到数据库内（wx_monitor/text_messages、recording_messages）

程序基于 python 3.6.x 开发，需要安装以下插件：
1. pip3 install itchat
1. pip3 install mysql-connector-python --allow-external mysql-connector-python
1. pip3 install snownlp

如果 mysql-connector-python 安装失败，可以试试另外一个替代驱动：
pip3 install mysql-connector

### 执行
将需要监控的群名称保存于数据库：wx_monitor/chatrooms 表内，运行 src/wx_monitor.py，扫码登录微信即可。

需要监控某个账号下的全部微信群时，运行 src/sentiment_analyse.py <账号名>，就能将当天内关联在该账号下的全部聊天群的聊天内容做舆情扫描和分析，并将结果保存进数据库当中。

当前在树莓派当中，使用 crontab -e，然后添加以下规则，以定时运行 sentiment_analyse.py 进行舆情监控。
``` 0 */1 * * * <path to sentiment_anallyse.py> >> <path to log>

### 二维码
在基于 Linux 的树莓派上，纯命令行模式下运行时，需要给系统配置中文运行环境
``` sudo dpkg-reconfigure locales

选择 zh_CN.UTF-8 作为默认语言