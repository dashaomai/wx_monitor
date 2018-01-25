#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import itchat
from itchat.content import *
from db import *
import platform


def monitor(group_id, group_name):
	groups = itchat.search_chatrooms(name=group_name)
	if len(groups) > 0:
		group = groups[0]
		# print(group)
		group_user_name = group['UserName']

		# 保存文字消息
		@itchat.msg_register([TEXT], isGroupChat=True)
		def print_messages(msg):
			group_name2 = msg['User']['NickName']
			if group_name2 == group_name:
				# print('符合')
				nickname = msg['ActualNickName']
				content = msg['Content']
				create_time = msg['CreateTime']
				insert_text_message(nickname, content, create_time)

				print('消息 ' + content + '已保存')

		# else:
		# print('不符')

		# 保存语音消息
		@itchat.msg_register([RECORDING], isGroupChat=True)
		def download_files(msg):
			msg.download('records/' + msg.fileName)

			nickname = msg['ActualNickName']
			filename = msg.fileName
			create_time = msg['CreateTime']
			insert_recording_message(nickname, filename, create_time)

			print('文件 ' + msg.fileName + ' 已下载')

	else:
		print('未能找到名为：' + group_name + '的聊天群')


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

		# 监控每一个对应的聊天组
		for group in db_groups:
			group_id = group[0]
			group_name = group[1]

			monitor(group_id, group_name)

	else:
		print('无法从数据库内加载要监视的微信群')

	itchat.run(True)


if __name__ == '__main__':
	main()
