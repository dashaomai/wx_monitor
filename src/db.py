# -*- coding: utf-8 -*-

import mysql.connector

db_config = {'user': 'root', 'password': 'docker', 'database': 'wx_monitor'}


def select_id_by_account(account_name):
	return _db_template(_select_id_by_account, account_name=account_name)


def _select_id_by_account(_, cursor, account_name):
	cursor.execute('SELECT id FROM accounts WHERE name=%s LIMIT 1', [account_name])
	values = cursor.fetchall()

	if len(values) > 0:
		return values[0][0]
	else:
		return 0


def _select_chatrooms(_, cursor, account_id):
	cursor.execute('SELECT id, title FROM chatrooms WHERE account_id=%s;', [account_id])
	values = cursor.fetchall()

	# return [x[0] for x in values]
	return values


# 选出要监控的聊天群名称
def select_chatrooms(account_name):
	account_id = select_id_by_account(account_name)

	if 0 == account_id:
		return []
	else:
		return _db_template(_select_chatrooms, account_id=account_id)


def _insert_text_message(conn, cursor, username, nickname, content, create_time):
	# 先根据 username 和 nickname 取得对应 Person 的 id

	cursor.execute(
		'INSERT INTO text_messages (create_time, nickname, content) VALUES (%s, %s, %s);',
		[create_time, nickname, content]
	)

	conn.commit()

	return 1 == cursor.rowcount


# 插入一条聊天内容
def insert_text_message(username, nickname, content, create_time):
	return _db_template(_insert_text_message, username=username, nickname=nickname, content=content, create_time=create_time)


def _insert_recording_message(conn, cursor, nickname, filename, create_time):
	cursor.execute(
		'INSERT INTO recording_messages (create_time, nickname, filename) VALUES(%s, %s, %s);',
		[create_time, nickname, filename]
	)

	conn.commit()

	return 1 == cursor.rowcount


# 插入一条语音记录
def insert_recording_message(nickname, filename, create_time):
	return _db_template(_insert_recording_message, nickname=nickname, filename=filename, create_time=create_time)


def _get_person_id(conn, cursor, username, nickname):
	cursor.execute(
		'SELECT id FROM persons WHERE username=%s LIMIT 1;',
		[username]
	)

	results = cursor.fetchall()

	if len(results) > 0:
		# 已有该人存在
		person_id = results[0][0]

		# 更新昵称
		cursor.execute(
			'UPDATE persons SET nickname=%s WHERE id=%s AND nickname!=%s',
			[nickname, person_id, nickname]
		)

		effected = cursor.fetchall()
		print(effected)

		if conn.afffected_rows() > 0:
			conn.commit()
		else:
			print("未能更新 persons：%d, %s, %s" % (person_id, username, nickname))

	else:
		# 该人不存在
		cursor.execute(
			'INSERT INTO persons SET username=%s, nickname=%s;',
			[username, nickname]
		)

		# 找到 person_id
		person_id = conn.insert_id()

	# 返回 person_id
	return person_id


def _db_template(callback, **other):
	try:
		conn = mysql.connector.connect(**db_config)
		cursor = conn.cursor()

		cursor.execute('SET NAMES utf8mb4')
		cursor.execute('SET CHARACTER SET utf8mb4')
		cursor.execute('SET character_set_connection=utf8mb4')

		return callback(conn, cursor, **other)

	finally:
		cursor.close()
		conn.close()
