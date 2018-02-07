#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import itchat
from itchat.content import *
from db import *
import platform, os


def get_nickname(msg):
    # username = msg['ActualUserName']
    nickname = msg['ActualNickName']

    if '' == nickname:
        # 群主发言，没有 ActualNickName
        slf = msg['User']['Self']
        nickname = slf['NickName']

    return nickname


# def monitor(group_id, group_name):
def monitor(db_groups):
    # 把聊天组的数组转化成字典
    groups_dict = {}

    for group_id, group_name in db_groups:
        groups_dict[group_name] = group_id

    # 保存文字消息
    @itchat.msg_register([TEXT], isGroupChat=True)
    def print_messages(msg):
        group_name2 = msg['User']['NickName']
        if group_name2 in groups_dict:
            group_id2 = groups_dict[group_name2]
            nickname = get_nickname(msg)

            member_count = msg['User']['MemberCount']

            content = msg['Content']
            create_time = msg['CreateTime']
            insert_text_message(group_id2, member_count, nickname, content, create_time)

            print('消息 ' + content + '已保存')

    # 保存语音消息
    @itchat.msg_register([RECORDING], isGroupChat=True)
    def download_files(msg):
        if not os.path.exists('records'):
            os.makedirs('records')

        group_name2 = msg['User']['NickName']
        if group_name2 in groups_dict:
            group_id2 = groups_dict[group_name2]

            msg.download('records/' + msg.fileName)

            member_count = msg['User']['MemberCount']

            nickname = get_nickname(msg)
            filename = msg.fileName
            create_time = msg['CreateTime']
            insert_recording_message(group_id2, member_count, nickname, filename, create_time)

            print('文件 ' + msg.fileName + ' 已下载')


def main():
    # 从 MySQL 中读取要监控的聊天室的名字
    db_groups = select_chatrooms('特房集团天津鼓浪水镇开发分公司')
    if len(db_groups) > 0:

        if platform.platform().find('Windows') == 0:
            cmd_qr = True
        else:
            cmd_qr = 2

        # 以字符界面显示登录用二维码
        itchat.auto_login(enableCmdQR=cmd_qr)

        # 监控对应的聊天组
        monitor(db_groups)

        itchat.run(True)

    else:
        print('无法从数据库内加载要监视的微信群')

        exit(-1)


if __name__ == '__main__':
    main()
