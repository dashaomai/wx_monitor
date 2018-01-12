-- --------------------------------------------------------
-- Host:                         10.0.0.35
-- Server version:               10.1.26-MariaDB-0+deb9u1 - Debian 9.1
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for wx_monitor
DROP DATABASE IF EXISTS `wx_monitor`;
CREATE DATABASE IF NOT EXISTS `wx_monitor` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `wx_monitor`;

-- Dumping structure for table wx_monitor.chatrooms
DROP TABLE IF EXISTS `chatrooms`;
CREATE TABLE IF NOT EXISTS `chatrooms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '聊天群的名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table wx_monitor.chatrooms: ~0 rows (approximately)
DELETE FROM `chatrooms`;
/*!40000 ALTER TABLE `chatrooms` DISABLE KEYS */;
INSERT INTO `chatrooms` (`id`, `title`) VALUES
	(1, '鼓浪读书会');
/*!40000 ALTER TABLE `chatrooms` ENABLE KEYS */;

-- Dumping structure for view wx_monitor.formated_text_messages
DROP VIEW IF EXISTS `formated_text_messages`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `formated_text_messages` (
	`time` DATETIME NULL,
	`nickname` VARCHAR(100) NOT NULL COMMENT '发言者昵称' COLLATE 'utf8mb4_unicode_ci',
	`content` TEXT NOT NULL COMMENT '发言内容' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for table wx_monitor.recording_messages
DROP TABLE IF EXISTS `recording_messages`;
CREATE TABLE IF NOT EXISTS `recording_messages` (
  `create_time` int(11) NOT NULL,
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table wx_monitor.recording_messages: ~0 rows (approximately)
DELETE FROM `recording_messages`;
/*!40000 ALTER TABLE `recording_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_messages` ENABLE KEYS */;

-- Dumping structure for table wx_monitor.text_messages
DROP TABLE IF EXISTS `text_messages`;
CREATE TABLE IF NOT EXISTS `text_messages` (
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发言者昵称',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发言内容',
  PRIMARY KEY (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table wx_monitor.text_messages: ~106 rows (approximately)
DELETE FROM `text_messages`;
/*!40000 ALTER TABLE `text_messages` DISABLE KEYS */;
INSERT INTO `text_messages` (`create_time`, `nickname`, `content`) VALUES
	(1513207220, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1513293642, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1513581585, '晓晖', '@井所长 咱们鼓浪读书会联合举办哦，机遇空间很不错，读书活动质量很高，群发下，感兴趣可以报名的哦'),
	(1513675362, '井所长', '欢迎新朋友~'),
	(1513675408, 'Бизнесмен', '新人一枚 多多关照😂'),
	(1513675412, '井所长', '@Бизнесмен 平时喜欢看什么类型的书呀？'),
	(1513675822, '三儿', '[鼓掌][鼓掌]'),
	(1513675901, '喵君', '🎉🎉🎉'),
	(1513675908, '喵君', '欢迎新朋友'),
	(1513675924, 'Бизнесмен', '你好[耶]'),
	(1513675936, '    🏃陈越', '你好'),
	(1513676042, '井所长', '咱们鼓浪读书会“同书共读”第三季《24个比利》已经分享5次了，感兴趣的新朋友要是也想看这本书可以私聊我，我把之前分享过的章节给你们哈~'),
	(1513676114, '井所长', '明天持续分享书哦~分享是每周的周二——周五。希望大家在鼓浪读书会里度过美好的阅读时光~'),
	(1513681682, '井所长', '鼓浪读书会线下活动“九六书院 解密中华传统文化”报名持续进行中~\n盆友们请注意了！！！🔥活动时间上有改动哟！！！[怄火]大家不要迟到了呢。😜\n活动时间：12月22日9:00（到达北京石榴中心）—16:00\n（北京参加活动书友们的时间安排哦！！！鼓浪水镇金主爸爸贴心的为北京的书友们提供大巴接送往返~）[飞吻]\n          \n活动地点：天津鼓浪水镇接待中心\n\n北京出发需要乘坐大巴的书友们报名时间截止20日14:00.\n报名的书友们请22日9：00到达北京石榴中心进行签到出发。😘\n\n自行前往的书友们，金主爸爸这次同时也提供给每位书友可口的午餐哟~💪午餐报名时间截止20日14:00.\n请报名的书友22日12:00到达活动地点，就可享受美味的午餐。\n（请书友们在截止时间之前报名大巴和午餐，过了时间就不能再报名了）😱\n\n 如果您是天津的书友同时也不需要参与吃午餐，报名截止时间21日晚21点。\n22日请12:45到达活动现场，参与活动~\n\n本次活动不收取任何费用，都是鼓浪水镇金主爸爸为鼓浪读书会带来的福利哟~😘报名只招募20人，感兴趣的小伙伴们尽快报名哈。一定要仔细阅读报名详情哟！！！😱报满为止，先到先得~'),
	(1513681702, '井所长', '报名接龙（需要乘坐大巴往返和享用午餐的书友请在群中@井所长说明，报名截止时间：20日14:00！！！接龙报名自动归类只参与分享活动，报名截止时间21日晚21:00）：\n1、喵君\n2、井所长\n3、杨月\n4、王鸿玺\n5、許芮珩\n6、鹿晨\n7、晓晖\n8、杨畅\n9、赵婷\n10、老二\n11、吴曼雄\n12、吴会丽\n13、秦立\n14、晓宇\n15、\n16、\n17、\n18、\n19、\n20、\n21、\n22、\n23、\n24、\n25、'),
	(1513681734, '井所长', '请各位书友仔细阅读报名详情进行报名'),
	(1513681789, '井所长', '已经报名过得书友们如果需要乘坐大巴和享用午餐@井所长！！！[怄火]'),
	(1513725646, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1513775029, '樊北‖活动运营张世磊', '这个活动是樊登读书会与机遇空间最终要的一次合作活动，此次活动我们专门添加了群变的应用，相信会让您大开眼界，这是不同于以往新书发布会的新书发布会。名额也十分有限，在活动行一元报名，填写您的信息，现场有免费的杯装水果赠送给您。让我们来个大招一起跨年吧！在机遇空间机遇你的无限可能！'),
	(1513775081, '樊北‖活动运营张世磊', '这次活动鼓浪读书会也是联合举办哦！虽然当天有马未都老师的活动遗憾错过了'),
	(1513781981, '晓晖', '@樊北‖活动运营张世磊 对，马未都的活动主要是针对学生群体，咱们读书会的伙伴们还是可以参加机遇空间的活动的'),
	(1513783731, '樊北‖活动运营张世磊', '[太阳][太阳]明白'),
	(1513812027, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1513812114, '三儿', '早[太阳]'),
	(1513812144, '喵君', '[玫瑰][玫瑰][玫瑰]'),
	(1513814309, '🍋', '[咖啡]'),
	(1513850092, '井所长', '欢迎新盆友～'),
	(1513850114, '井所长', '希望你在鼓浪读书会度过美好的阅读时光～'),
	(1513850806, '🗽', '欢迎～'),
	(1513898457, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1513900388, '张东derek', '[强]@井所长 '),
	(1513901581, '🍋', '[强]'),
	(1513901721, '🗽', '[鼓掌][鼓掌][鼓掌]'),
	(1513901759, '喵君', '[玫瑰][玫瑰][玫瑰]'),
	(1513903803, '井所长', '“同书共读”这周分享结束～下周二至周五持续分享哈～'),
	(1513904201, '🗽', '辛苦群主'),
	(1513904853, '喵君', '棒棒哒！'),
	(1513906977, '井所长', '@喵君 哇～粗发了吗？'),
	(1513906986, '喵君', '鼓浪读书会线下九六书院活动的北京书友们已经出发啦'),
	(1513906992, '喵君', '[嘿哈][嘿哈][嘿哈]'),
	(1513907026, 'Бизнесмен', '[强]'),
	(1513907030, '井所长', '@喵君 哈哈，可以欣赏一下沿途的美景'),
	(1513907134, '晓宇', '天气真棒~[机智]   期待今天的分享~'),
	(1513916980, '喵君', '我们已经到啦，正在享用美味的午餐'),
	(1513917466, '井所长', '哇啊~好漂酿呀😍'),
	(1513917491, '🍋', '[色]'),
	(1513917518, '晓晖', '@喵君 尽快上来'),
	(1513917657, 'Бизнесмен', '[偷笑]'),
	(1513919301, '井所长', '[鼓掌][鼓掌][鼓掌]'),
	(1513919310, '晓宇', '张博士的分享[机智][机智][机智]'),
	(1513921984, '晓宇', '博士手把手教养生之术[转圈][转圈][转圈][跳跳][跳跳]'),
	(1513922042, '井所长', '我也好想学！你们谁回来教教我'),
	(1513922086, '喵君', '我会[坏笑][坏笑][坏笑]'),
	(1513922162, '井所长', '那你回来教我哈，我也要开始健康生活'),
	(1513923185, '喵君', '常博士在演讲，很生动[强]'),
	(1513923220, '心如海', '棒 '),
	(1513933110, '喵君', '活动结束啦🎉🎉🎉'),
	(1513933857, '达达男爵', '特别受教[强][强][强]'),
	(1513933873, '井所长', '[鼓掌][鼓掌][鼓掌]'),
	(1513933917, '喵君', '我这边网不太好，所以就不放太多照片了'),
	(1514200627, 'Derekcheung', '[强]'),
	(1514244087, '井所长', '@所有人\n“同书共读”第三季《24个比利》[呲牙]今日更新分享~[偷笑]\n本书分享Word和PDF版本，可在手机（掌阅APP）、kindle上进行阅读。大家可以选择其一。如有什么建设性的建议可在群中@井所长 提粗来哟~[勾引]希望能够让大家在鼓浪读书度过每天充实的阅读时光，我们为此而努力着！！！[爱情]'),
	(1514244117, '三儿', '[鼓掌][鼓掌]'),
	(1514246748, '🍋', '[强]'),
	(1514438352, '喵君', '“同书共读”第四季[胜利]正式开启~[耶]🎉。请大家在书单中进行投票[乱舞]。投票数最多的书籍会在群中进行分享[奸笑]~快来为你想阅读的书投票吧[机智]！！！\n投票时间：12月28日——1月2日中午12点'),
	(1514438402, '井所长', '“同书共读”第四季[胜利]正式开启~[耶]🎉。请大家在书单中进行投票[乱舞]。投票数最多的书籍会在群中进行分享[奸笑]~快来为你想阅读的书投票吧[机智]！！！\n投票时间：12月28日——1月2日中午12点'),
	(1514438511, '🗽', '投了～辛苦群主[玫瑰]'),
	(1514438915, '井所长', '@🗽 [机智]'),
	(1514439079, '三儿', '已投[奸笑]'),
	(1514439736, '豆豆', '投了!'),
	(1514522800, '🎩', '麻烦大家点进去投一下北京中心'),
	(1514522864, '井所长', '@🎭 群内不许发广告，请撤回！'),
	(1514523480, '井所长', '“同书共读”第四季[胜利]正式开启~[耶]🎉。请大家在书单中进行投票[乱舞]。投票数最多的书籍会在群中进行分享[奸笑]~快来为你想阅读的书投票吧[机智]！！！\n投票时间：12月28日——1月2日中午12点'),
	(1514523507, '井所长', '大家可以继续投票书单哈'),
	(1514523772, '袁尚尚', '请问，前三季书单有吗？@'),
	(1514523863, '井所长', '前三季已分享结束了@袁尚尚 [嘿哈]'),
	(1514523886, '袁尚尚', '都是哪些书呢？'),
	(1514524039, '井所长', '人类简史，上帝掷骰子吗，24个比利'),
	(1514524137, '袁尚尚', 'OK👌 多谢'),
	(1514552037, '樊北‖活动运营张世磊', '这是来自樊登读书会北京丰台分会长张世磊的祝福！感谢大家支持我们樊登读书会！'),
	(1514552086, '三儿', '@井所长 谢谢[玫瑰]'),
	(1514553600, '    🏃陈越', '@井所长 '),
	(1514723079, '晓晖', '祝鼓浪读书会朋友们新年快乐🍾️🎉🎊'),
	(1514724520, '井所长', '祝鼓浪读书会朋友们新年快乐🍾️🎉🎊'),
	(1514729208, '樊北‖活动运营张世磊', '罗振宇还是那么厉害！《时间的朋友》'),
	(1514736247, '房米露营广播站', '新年快乐[愉快][玫瑰][爱心]🎉[耶][耶][耶]'),
	(1514736371, '姜威', '新年快乐大家'),
	(1514736398, '井所长', '鼓浪读书会的小伙伴们新年快乐～'),
	(1514736446, 'Adayin', '新年快乐🍾️🎆🎉'),
	(1514736449, 'XP海盗', '@井所长 新年快乐'),
	(1514736480, '    🏃陈越', '@井所长 新年快乐'),
	(1514736515, '紫一', '新年快乐'),
	(1514736768, '癸酉', '谢谢'),
	(1514736792, '房米露营广播站', '🙏🙏🙏🙏'),
	(1514736797, '北游.', '新年快乐'),
	(1514736814, '🙈', '新年快乐⭐️ '),
	(1514736918, '化妆师💋尹亚丹', '新年快乐'),
	(1514737865, 'A 朴美仙', '新年快乐!!'),
	(1514737968, '🌺', '@张东derek 祝新年快乐!!'),
	(1514754412, 'baby_donot_cry', '@张东derek 谢谢'),
	(1514769325, '江波达', '大家新年快乐'),
	(1514773574, '晓晖', '新年礼物📦，分享一批非常棒的纪录片《博物馆的秘密》\n1、梵蒂冈博物馆：http://t.cn/RfSjqot\n2、巴黎卢浮宫：http://t.cn/RqLSuhq\n3、皇家安大略博物馆：http://t.cn/RqLSuhK\n4、埃及博物馆：http://t.cn/RqLSuhb\n5、英国自然历史博物馆：http://t.cn/RqLSuhM\n6、大都会艺术博物馆：http://t.cn/RqLSuh5\n7、美国自然历史博物馆：http://t.cn/RqLSuhi\n8、伦敦帝国战争博物馆：http://t.cn/RqLSuhx\n9、墨西哥城人类学国家博物馆：http://t.cn/RqLSuhc\n10、柏林博物馆：http://t.cn/RqLSuhG\n11、维也纳艺术史博物馆：http://t.cn/RqLSuhJ\n12、伊斯坦布尔博物馆：http://t.cn/RqLSuhV\n13、雅典国家考古博物馆：http://t.cn/RqLSuht\n14、国立艾尔米塔什博物馆：http://t.cn/RqLSuh6\n15、西班牙马德里皇宫：http://t.cn/RqFDcTI\n16、耶路撒冷以色列博物馆：http://t.cn/RqFNBGT\n17、莫斯科国家历史博物馆：http://t.cn/RqFNBrS\n18、意大利佛罗伦斯乌菲滋美术馆：http://t.cn/RqFNgYn\n19、英国伦敦航海博物馆：：http://t.cn/RqFNei0\n20、巴黎凡尔赛宫：http://t.cn/RqFND4k\n21、华盛顿特区史密森尼学会：http://t.cn/RqFNDkO\n22、突尼斯国立巴杜博物馆：http://t.cn/RXnkPMC'),
	(1514776844, '王海青@', '祝大家新年读书快乐![玫瑰][玫瑰][玫瑰]'),
	(1514776890, '～榴莲～', '@晓晖 真好[强]'),
	(1514810673, '井所长', '“同书共读”第四季[胜利]正式开启~[耶]🎉。请大家在书单中进行投票[乱舞]。投票数最多的书籍会在群中进行分享[奸笑]~快来为你想阅读的书投票吧[机智]！！！\n投票时间：12月28日——1月2日中午12点'),
	(1514810685, '井所长', '大家可以持续投票哈'),
	(1514810716, '三儿', '[OK][OK]'),
	(1514856593, '寂寞不语', '普及经济学知识');
/*!40000 ALTER TABLE `text_messages` ENABLE KEYS */;

-- Dumping structure for view wx_monitor.formated_text_messages
DROP VIEW IF EXISTS `formated_text_messages`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `formated_text_messages`;
CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `formated_text_messages` AS select from_unixtime(`text_messages`.`create_time`) AS `time`,`text_messages`.`nickname` AS `nickname`,`text_messages`.`content` AS `content` from `text_messages`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
