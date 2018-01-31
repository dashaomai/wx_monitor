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


def _insert_text_message(conn, cursor, chatroom_id, member_count, nickname, content, create_time):
    # 先根据 username 和 nickname 取得对应 Person 的 id
    person_id = _get_person_id(conn, cursor, nickname)

    cursor.execute(
        'INSERT INTO text_messages (create_time, chatroom_id, person_id, content) VALUES (%s, %s, %s, %s);',
        (create_time, chatroom_id, person_id, content)
    )

    if cursor.rowcount > 0:
        conn.commit()

        # 更新成员数到 chatrooms 表当中
        _update_member_count(conn, cursor, chatroom_id, member_count)

    return 1 == cursor.rowcount


# 插入一条聊天内容
def insert_text_message(chatroom_id, member_count, nickname, content, create_time):
    return _db_template(
        _insert_text_message,
        chatroom_id=chatroom_id, member_count=member_count, nickname=nickname, content=content, create_time=create_time)


def _insert_recording_message(conn, cursor, chatroom_id, member_count, nickname, filename, create_time):
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
def insert_recording_message(chatroom_id, member_count, nickname, filename, create_time):
    return _db_template(_insert_recording_message, chatroom_id=chatroom_id, member_count=member_count,
                        nickname=nickname, filename=filename, create_time=create_time)


def _update_member_count(conn, cursor, chatroom_id, member_count):
    cursor.execute(
        'UPDATE chatrooms SET member_count=%s WHERE id=%s LIMIT 1;',
        [member_count, chatroom_id]
    )

    if cursor.rowcount > 0:
        conn.commit()


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


# 从数据库中确定某个聊天组的开始时间
# def check_chatroom_begin(chatroom_id, begin):
#     db_begin = _db_template(_get_analysed_time_from_chatrooms, chatroom_id=chatroom_id)
#
#     return max(db_begin, begin)


# def _get_analysed_time_from_chatrooms(_, cursor, chatroom_id):
#     cursor.execute(
#         'SELECT analysed_time FROM chatrooms WHERE id=%s LIMIT 1;',
#         [chatroom_id]
#     )
#
#     row = cursor.fetchone()
#
#     if row is not None:
#         return row[0]
#     else:
#         return 0


# 选出指定聊天组在指定时间范围内的所有文字记录
def select_text_messages(chatroom_id, begin, end):
    return _db_template(_select_text_messages, chatroom_id=chatroom_id, begin=begin, end=end)


def _select_text_messages(_, cursor, chatroom_id, begin, end):
    cursor.execute(
        'SELECT person_id, content FROM text_messages WHERE chatroom_id=%s AND create_time>=%s AND create_time<=%s;',
        [chatroom_id, begin, end]
    )

    results = cursor.fetchall()

    return results


# 保存一条聊天组某天的统计结果
def save_chatroom_analyse(chatroom_id, date, member_active, talk_count, sentence_count, sentiment_mean):
    return _db_template(
        _save_chatroom_analyse,
        chatroom_id=chatroom_id, date=date, member_active=member_active, talk_count=talk_count,
        sentence_count=sentence_count, sentiment_mean=sentiment_mean
    )


def _save_chatroom_analyse(conn, cursor, chatroom_id, date, member_active, talk_count, sentence_count, sentiment_mean):
    # 先取出组内当前成员数量
    cursor.execute(
        'SELECT member_count FROM chatrooms WHERE id=%s LIMIT 1;',
        [chatroom_id]
    )

    row = cursor.fetchone()

    if row is not None:
        member_count = row[0]

        print(
            '聊天组 #{} 在 {} 时统计结果：member_count = {}, member_active = {}, talk_count = {}, sentence_count = {}, sentiment_mean = {}'.format(chatroom_id, date, member_count, member_active, talk_count, sentence_count, sentiment_mean)
        )

        # 现在开始保存动作
        cursor.execute(
            'REPLACE INTO chatroom_analyse(chatroom_id, `date`, member_count, member_active, talk_count, sentence_count, sentiment_mean) VALUES(%s, %s, %s, %s, %s, %s, %s)',
            [chatroom_id, date, member_count, member_active, talk_count, sentence_count, sentiment_mean]
        )

        conn.commit()

    else:
        print('无法找到聊天组 #%s 的信息' % chatroom_id)


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
