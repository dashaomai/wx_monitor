#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 舆情分析程序，为指定 chatroom 分析今天之内所有文本聊天内容的语料舆情信息
import datetime
import time
import sys

from snownlp import SnowNLP

from db import select_chatrooms, select_text_messages, save_chatroom_analyse, select_email
from mail import send_alert_email


def main():
    # 查找输入参数
    if len(sys.argv) < 2:
        print('Usage: sentiment_analyse.py <name of account>')
        exit(-1)

    account_name = sys.argv[1]

    # 获取要查询的时间范围
    yesterday = time.mktime(datetime.date.today().timetuple())
    end = yesterday + 1000 * 60 * 60 * 24

    # 获取指定聊天室的 id 和已存在的分析过的时间戳
    db_groups = select_chatrooms(account_name)
    if len(db_groups) > 0:

        # 选出舆情预警发送的电子邮件地址
        email = select_email(account_name)

        # 遍历每一个对应的聊天组
        for group in db_groups:
            group_id = group[0]
            group_name = group[1]

            print('开始分析聊天组 #%s 的舆情' % group_name)

            # 取消了聊天室记录已分析时间戳的优化，因为这样无法统计整天内发言人数等活跃统计
            # begin = check_chatroom_begin(group_id, yestoday)
            begin = yesterday

            rows = select_text_messages(group_id, begin, end)
            if len(rows) > 0:

                # 初始化累加器变量
                talk_count = 0
                sentiment_count = 0
                accumulation = 0.

                grouped_person_id = set()

                # 遍历每一句话，计算当天该聊天组的舆情正负向
                for row in rows:
                    talk_count += 1

                    person_id = row[0]
                    content = row[1]

                    grouped_person_id.add(person_id)
                    s = SnowNLP(content)

                    accumulation += s.sentiments
                    sentiment_count += len(s.sentences)

                # 得到平均正负向数值
                sentiment_mean = accumulation / talk_count

                # 统计发言过的人数
                member_active = len(grouped_person_id)

                # 将该条结果保存入数据库中
                save_chatroom_analyse(group_id, begin, end, member_active, talk_count, sentiment_count, sentiment_mean)

                # 如果舆情有问题，则发起主动预警
                if sentiment_mean < 0.35 and None is not email:
                    # 发送邮件预警
                    send_alert_email(email, account_name, group_name, sentiment_mean)

            else:
                print('聊天组 #%s 没有聊天记录供舆情分析' % group_name)

    else:
        print('无法从数据库内加载账号：%s 的监控信息' % account_name)

        exit(-1)


if __name__ == '__main__':
    main()
