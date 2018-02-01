# -*- coding: utf-8 -*-
from email.mime.text import MIMEText
from smtplib import SMTP_SSL

from_addr = 'xxxxx@163.com'
password = 'yyyyy'

smtp_server = 'smtp.163.com'
smtp_port = 465  # SSL 端口


# 发送预警邮件（基于 163.com 的 SSL SMTP 服务器）
def send_alert_email(to_addr, username, chatroom_name, sentiment_mean):
    content = '{} 您好：\n您所属的微信群：{} 检测到负向舆情，负向级别为：{}。\n建议您尽快介入处理！'.format(username, chatroom_name,
                                                                        _get_sentiment(sentiment_mean))

    email = MIMEText(content, 'plain', 'utf-8')
    email['Subject'] = '微信群：{} 舆情预警！'.format(chatroom_name)
    email['From'] = from_addr
    email['To'] = to_addr

    with SMTP_SSL(smtp_server, smtp_port) as server:
        server.set_debuglevel(1)
        server.login(from_addr, password)
        server.sendmail(from_addr, [to_addr], email.as_string())

    print('成功的向：{} 发送了微信群：{} 的舆情预警。'.format(username, chatroom_name))


def _get_sentiment(sentiment_mean):
    if sentiment_mean >= 0.75:
        return '非常正向'
    elif sentiment_mean >= 0.55:
        return '比较正向'
    elif sentiment_mean >= 0.45:
        return '正常'
    elif sentiment_mean >= 0.35:
        return '比较负向'
    else:
        return '非常负向'
