# -*- coding: utf-8 -*-

import mysql.connector

db_config = {'user': 'root', 'password': 'docker', 'database': 'wx_monitor'}


def _select_chatrooms(_, cursor):
    cursor.execute('SELECT * FROM chatrooms;')
    values = cursor.fetchall()

    # return [x[0] for x in values]
    return values


# 选出要监控的聊天群名称
def select_chatrooms():
    return _db_template(_select_chatrooms)


def _insert_text_message(conn, cursor, nickname, content, create_time):
    cursor.execute(
	    'INSERT INTO text_messages (create_time, nickname, content) VALUES (%s, %s, %s);',
      [create_time, nickname, content]
    )

    conn.commit()

    return 1 == cursor.rowcount


# 插入一条聊天内容
def insert_text_message(nickname, content, create_time):
    return _db_template(_insert_text_message, nickname=nickname, content=content, createTime=create_time)


def _insert_recording_message(conn, cursor, nickname, filename, createTime):
    cursor.execute(
	    'INSERT INTO recording_messages (create_time, nickname, filename) VALUES(%s, %s, %s);',
	    [createTime, nickname, filename]
    )

    conn.commit()

    return 1 == cursor.rowcount


# 插入一条语音记录
def insert_recording_message(nickname, filename, create_time):
    return _db_template(_insert_recording_message, nickname=nickname, filename=filename, createTime=create_time)


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
