# -*- coding: utf-8 -*-

import mysql.connector

db_config = {'user': 'root', 'password': 'docker', 'database': 'wx_monitor'}


def select_id_by_account(account_name):
	return _db_template(_select_id_by_account, account_name=account_name)


def _select_id_by_account(_, cursor, account_name):
	cursor.execute('SELECT id FROM accounts WHERE `name`=%s LIMIT 1', [account_name])
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


def _insert_text_message(conn, cursor, chatroom_id, nickname, content, create_time):
	# 先根据 username 和 nickname 取得对应 Person 的 id
	person_id = _get_person_id(conn, cursor, nickname)

	cursor.execute(
		'INSERT INTO text_messages (create_time, chatroom_id, person_id, content) VALUES (%s, %s, %s, %s);',
		(create_time, chatroom_id, person_id, content)
	)

	if cursor.rowcount > 0:
		conn.commit()

	return 1 == cursor.rowcount


# 插入一条聊天内容
def insert_text_message(chatroom_id, nickname, content, create_time):
	return _db_template(
		_insert_text_message,
		chatroom_id=chatroom_id, nickname=nickname, content=content, create_time=create_time)


def _insert_recording_message(conn, cursor, chatroom_id, nickname, filename, create_time):
	# 先根据 username 和 nickname 取得对应 Person 的 id
	person_id = _get_person_id(conn, cursor, nickname)

	cursor.execute(
		'INSERT INTO recording_messages (create_time, chatroom_id, person_id, filename) VALUES(%s, %s, %s, %s);',
		(create_time, chatroom_id, person_id, filename)
	)

	if cursor.rowcount > 0:
		conn.commit()

	return 1 == cursor.rowcount


# 插入一条语音记录
def insert_recording_message(chatroom_id, nickname, filename, create_time):
	return _db_template(_insert_recording_message, chatroom_id=chatroom_id, nickname=nickname, filename=filename, create_time=create_time)


def _get_person_id(conn, cursor, nickname):
	cursor.execute(
		'SELECT id FROM persons WHERE nickname=%s LIMIT 1;',
		[nickname]
	)

	results = cursor.fetchall()

	if len(results) > 0:
		# 已有该人名存在
		person_id = results[0][0]

	else:
		# 该人不存在
		cursor.execute(
			'INSERT INTO persons (nickname) VALUES(%s);',
			[nickname]
		)

		# 找到 person_id
		person_id = cursor.lastrowid

		if cursor.rowcount > 0:
			conn.commit()

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
