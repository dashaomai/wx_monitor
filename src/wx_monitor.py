#!/usr/local/bin/python3
# -*- coding: utf-8 -*-

import itchat
from itchat.content import *
from db import *

# 从 MySQL 中读取要监控的聊天室的名字
groups = selectChatrooms()
if len(groups) > 0:
    group = groups[0]
    groupName = group[1]

    # 以字符界面显示登录用二维码
    itchat.auto_login(enableCmdQR=2)

    groups = itchat.search_chatrooms(name=groupName)
    if len(groups) > 0:
        group = groups[0]
        #print(group)
        groupUserName = group['UserName']

        # 保存文字消息
        @itchat.msg_register([TEXT], isGroupChat=True)
        def print_messages(msg):
            groupName2 = msg['User']['NickName']
            if groupName2 == groupName:
                #print('符合')
                nickname = msg['ActualNickName']
                content = msg['Content']
                createTime = msg['CreateTime']
                insertTextMessage(nickname, content, createTime)

                print('消息 ' + content + '已保存')

            #else:
                #print('不符')

        # 保存语音消息
        @itchat.msg_register([RECORDING], isGroupChat=True)
        def download_files(msg):
            msg.download('records/' + msg.fileName)

            nickname = msg['ActualNickName']
            filename = msg.fileName
            createTime = msg['CreateTime']
            insertRecordingMessage(nickname, filename, createTime)

            print('文件 ' + msg.fileName + ' 已下载')
    else:
        print('未能找到名为：' + groupName + '的聊天群')

else:
    print('无法从数据库内加载要监视的微信群')

itchat.run(True)
