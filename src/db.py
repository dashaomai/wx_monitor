#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import mysql.connector

dbConfig = {'user': 'root', 'password': 'docker', 'database': 'wx_monitor'}

def _selectChatrooms(_, cursor):
    cursor.execute('SELECT * FROM chatrooms;')
    values = cursor.fetchall()

    #return [x[0] for x in values]
    return values

# 选出要监控的聊天群名称
def selectChatrooms():
    return _dbTemplate(_selectChatrooms)

def _insertTextMessage(conn, cursor, nickname, content, createTime):
    cursor.execute('INSERT INTO text_messages (create_time, nickname, content) VALUES (%s, %s, %s);', [createTime, nickname, content])

    conn.commit()

    return 1 == cursor.rowcount

# 插入一条聊天内容
def insertTextMessage(nickname, content, createTime):
    return _dbTemplate(_insertTextMessage, nickname=nickname, content=content, createTime=createTime)

def _insertRecordingMessage(conn, cursor, nickname, filename, createTime):
    cursor.execute('INSERT INTO recording_messages (create_time, nickname, filename) VALUES(%s, %s, %s);', [createTime, nickname, filename])

    conn.commit()

    return 1 == cursor.rowcount

# 插入一条语音记录
def insertRecordingMessage(nickname, filename, createTime):
    return _dbTemplate(_insertRecordingMessage, nickname=nickname, filename=filename, createTime=createTime)

def _dbTemplate(callback, **other):
    try:
        conn = mysql.connector.connect(**dbConfig)
        cursor = conn.cursor()

        cursor.execute('SET NAMES utf8mb4');
        cursor.execute('SET CHARACTER SET utf8mb4');
        cursor.execute('SET character_set_connection=utf8mb4');

        return callback(conn, cursor, **other)

    finally:
        cursor.close()
        conn.close()
