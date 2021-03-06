-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.19 - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for wx_monitor
CREATE DATABASE IF NOT EXISTS `wx_monitor` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `wx_monitor`;

-- Dumping structure for table wx_monitor.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '监控账号的 id，负数 id 表示特殊保留账号',
  `name` varchar(50) NOT NULL COMMENT '监控账号的名称',
  `description` text COMMENT '监控账号的描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='监控账号列表';

-- Dumping data for table wx_monitor.accounts: ~1 rows (approximately)
DELETE FROM `accounts`;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` (`id`, `name`, `description`) VALUES
	(1, '特房集团天津鼓浪水镇开发分公司', '厦门特房集团在天津滨海新区，以鼓浪屿为背景，搬移到此的相关内容');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table wx_monitor.chatrooms
CREATE TABLE IF NOT EXISTS `chatrooms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL COMMENT '所属账号的 id',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '聊天群的名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table wx_monitor.chatrooms: ~1 rows (approximately)
DELETE FROM `chatrooms`;
/*!40000 ALTER TABLE `chatrooms` DISABLE KEYS */;
INSERT INTO `chatrooms` (`id`, `account_id`, `title`) VALUES
	(1, 1, '鼓浪读书会'),
	(2, 1, '两弹一星');
/*!40000 ALTER TABLE `chatrooms` ENABLE KEYS */;

-- Dumping structure for view wx_monitor.formated_recording_messages
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `formated_recording_messages` (
	`time` DATETIME NULL,
	`group_name` VARCHAR(100) NOT NULL COMMENT '聊天群的名称' COLLATE 'utf8mb4_unicode_ci',
	`nickname` VARCHAR(100) NOT NULL COMMENT '微信联系人昵称' COLLATE 'utf8mb4_general_ci',
	`filename` VARCHAR(50) NOT NULL COMMENT '文件名' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view wx_monitor.formated_text_messages
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `formated_text_messages` (
	`time` DATETIME NULL,
	`group_name` VARCHAR(100) NOT NULL COMMENT '聊天群的名称' COLLATE 'utf8mb4_unicode_ci',
	`nickname` VARCHAR(100) NOT NULL COMMENT '微信联系人昵称' COLLATE 'utf8mb4_general_ci',
	`content` TEXT NOT NULL COMMENT '发言内容' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for table wx_monitor.persons
CREATE TABLE IF NOT EXISTS `persons` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nickname` varchar(100) NOT NULL COMMENT '微信联系人昵称',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE USERNAME` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='个人信息记录';

-- Dumping data for table wx_monitor.persons: ~0 rows (approximately)
DELETE FROM `persons`;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;

-- Dumping structure for table wx_monitor.recording_messages
CREATE TABLE IF NOT EXISTS `recording_messages` (
  `create_time` int(11) NOT NULL,
  `chatroom_id` bigint(20) unsigned NOT NULL COMMENT '所属聊天群的 id',
  `person_id` bigint(20) unsigned NOT NULL COMMENT '所属联系人的 id',
  `filename` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名',
  PRIMARY KEY (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table wx_monitor.recording_messages: ~0 rows (approximately)
DELETE FROM `recording_messages`;
/*!40000 ALTER TABLE `recording_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_messages` ENABLE KEYS */;

-- Dumping structure for table wx_monitor.text_messages
CREATE TABLE IF NOT EXISTS `text_messages` (
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `chatroom_id` bigint(20) unsigned NOT NULL,
  `person_id` bigint(20) unsigned NOT NULL COMMENT '发言者 id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发言内容',
  PRIMARY KEY (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table wx_monitor.text_messages: ~0 rows (approximately)
DELETE FROM `text_messages`;
/*!40000 ALTER TABLE `text_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `text_messages` ENABLE KEYS */;

-- Dumping structure for view wx_monitor.formated_recording_messages
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `formated_recording_messages`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `formated_recording_messages` AS select from_unixtime(`rm`.`create_time`) AS `time`,`cr`.`title` AS `group_name`,`p`.`nickname` AS `nickname`,`rm`.`filename` AS `filename` from ((`recording_messages` `rm` join `persons` `p` on((`rm`.`person_id` = `p`.`id`))) join `chatrooms` `cr` on((`rm`.`chatroom_id` = `cr`.`id`)));

-- Dumping structure for view wx_monitor.formated_text_messages
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `formated_text_messages`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `formated_text_messages` AS select from_unixtime(`tm`.`create_time`) AS `time`,`cr`.`title` AS `group_name`,`p`.`nickname` AS `nickname`,`tm`.`content` AS `content` from ((`text_messages` `tm` join `persons` `p` on((`tm`.`person_id` = `p`.`id`))) join `chatrooms` `cr` on((`tm`.`chatroom_id` = `cr`.`id`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
