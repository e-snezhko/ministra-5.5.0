--

CREATE TABLE IF NOT EXISTS `acl`(
  `id` int NOT NULL auto_increment,
  `gid` int NOT NULL default 0,
  `page` varchar(128) NOT NULL default '',
  `view` tinyint NOT NULL default 0,
  `create` tinyint NOT NULL default 0,
  `delete` tinyint NOT NULL default 0,
  `edit` tinyint NOT NULL default 0,
  `page_action` tinyint NOT NULL default 0,
  `context_action` tinyint NOT NULL default 0,
  `changed` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

ALTER TABLE `administrators` ADD `gid` int NOT NULL default 0;

CREATE TABLE IF NOT EXISTS `admin_groups`(
  `id` int NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `changed` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `admin_groups` VALUES (1,'video manager', NOW()),(2,'video moderator',NOW());

INSERT INTO `acl` VALUES
(1,1,'add_epg',1,0,0,0,0,0,NOW()),
(2,1,'add_itv',1,0,0,0,0,0,NOW()),
(3,1,'add_karaoke',1,1,1,1,1,1,NOW()),
(4,1,'add_moderator_mac',1,0,0,0,0,0,NOW()),
(5,1,'add_radio',1,0,0,0,0,0,NOW()),
(6,1,'add_video',1,1,1,1,1,1,NOW()),
(7,1,'all_userlog',1,1,1,1,1,1,NOW()),
(8,1,'anecdote',1,1,1,1,1,1,NOW()),
(9,1,'city_info',1,1,1,1,1,1,NOW()),
(10,1,'claims',1,1,1,1,1,1,NOW()),
(11,1,'claims_log',1,1,1,1,1,1,NOW()),
(12,1,'close_task',1,1,1,1,1,1,NOW()),
(13,1,'help_city_info',1,1,1,1,1,1,NOW()),
(14,1,'karaoke_archive',1,1,1,1,1,1,NOW()),
(15,1,'last_closed_karaoke',1,1,1,1,1,1,NOW()),
(16,1,'last_closed_tasks',1,1,1,1,1,1,NOW()),
(17,1,'msg',1,1,1,1,1,1,NOW()),
(18,1,'msgs',1,1,1,1,1,1,NOW()),
(19,1,'myvideolog',1,1,1,1,1,1,NOW()),
(20,1,'other_city_info',1,1,1,1,1,1,NOW()),
(21,1,'profile',1,0,0,0,0,0,NOW()),
(22,1,'reject_task',1,1,1,1,1,1,NOW()),
(23,1,'reply',1,1,1,1,1,1,NOW()),
(24,1,'send_to',1,1,1,1,1,1,NOW()),
(25,1,'stat_anec_users',1,1,1,1,1,1,NOW()),
(26,1,'stat_daily_video',1,1,1,1,1,1,NOW()),
(27,1,'stat_moderators',1,1,1,1,1,1,NOW()),
(28,1,'stat_not_active_users',1,1,1,1,1,1,NOW()),
(29,1,'stat_tv',1,1,1,1,1,1,NOW()),
(30,1,'stat_tv_archive',1,1,1,1,1,1,NOW()),
(31,1,'stat_tv_users',1,1,1,1,1,1,NOW()),
(32,1,'stat_video',1,1,1,1,1,1,NOW()),
(33,1,'stat_video_genres',1,1,1,1,1,1,NOW()),
(34,1,'stat_video_users',1,1,1,1,1,1,NOW()),
(35,1,'stbgroup_members',1,0,0,0,0,0,NOW()),
(36,1,'stbgroups',1,0,0,0,0,0,NOW()),
(37,1,'subscribe',1,1,1,1,1,1,NOW()),
(38,1,'subscribe_import',1,1,1,1,1,1,NOW()),
(39,1,'tariffs',1,0,0,0,0,0,NOW()),
(40,1,'tasks',1,1,1,1,1,1,NOW()),
(41,1,'tasks_archive',1,1,1,1,1,1,NOW()),
(42,1,'testers',1,0,0,0,0,0,NOW()),
(43,1,'today_user_status_report',1,1,1,1,1,1,NOW()),
(44,1,'unique_video',1,1,1,1,1,1,NOW()),
(45,1,'user',1,1,1,1,1,1,NOW()),
(46,1,'userlog',1,1,1,1,1,1,NOW()),
(47,1,'users',1,1,1,1,1,1,NOW()),
(48,1,'users_on_storage',1,1,1,1,1,1,NOW()),
(49,1,'vclub_ad',1,0,0,0,0,0,NOW()),
(50,1,'vclub_schedule',1,1,1,1,1,1,NOW()),
(51,1,'video_search',1,1,1,1,1,1,NOW()),
(52,1,'videolog',1,1,1,1,1,1,NOW()),
(53,2,'add_epg',1,0,0,0,0,0,NOW()),
(54,2,'add_itv',1,0,0,0,0,0,NOW()),
(55,2,'add_karaoke',1,0,0,0,0,0,NOW()),
(56,2,'add_moderator_mac',1,0,0,0,0,0,NOW()),
(57,2,'add_radio',1,0,0,0,0,0,NOW()),
(58,2,'add_video',1,0,0,0,0,0,NOW()),
(59,2,'admin_groups',1,0,0,0,0,0,NOW()),
(60,2,'anecdote',1,0,0,0,0,0,NOW()),
(61,2,'city_info',1,0,0,0,0,0,NOW()),
(62,2,'claims',1,0,0,0,0,0,NOW()),
(63,2,'claims_log',1,0,0,0,0,0,NOW()),
(64,2,'close_task',1,0,0,0,0,0,NOW()),
(65,2,'epg_setting',1,0,0,0,0,0,NOW()),
(66,2,'events',1,0,0,0,0,0,NOW()),
(67,2,'help_city_info',1,0,0,0,0,0,NOW()),
(68,2,'karaoke_archive',1,0,0,0,0,0,NOW()),
(69,2,'last_closed_karaoke',1,0,0,0,0,0,NOW()),
(70,2,'last_closed_tasks',1,0,0,0,0,0,NOW()),
(71,2,'master_log',1,0,0,0,0,0,NOW()),
(72,2,'msg',1,1,0,1,0,0,NOW()),
(73,2,'msgs',1,1,0,1,0,0,NOW()),
(74,2,'myvideolog',1,0,0,0,0,0,NOW()),
(75,2,'other_city_info',1,0,0,0,0,0,NOW()),
(76,2,'playlist',1,0,0,0,0,0,NOW()),
(77,2,'playlists'  ,1,0,0,0,0,0,NOW()),
(78,2,'profile',1,0,0,0,0,0,NOW()),
(79,2,'reject_task',1,0,0,0,0,0,NOW()),
(80,2,'reply',1,1,0,1,0,0,NOW()),
(81,2,'services_packages',1,0,0,0,0,0,NOW()),
(82,2,'setting_common',1,0,0,0,0,0,NOW()),
(83,2,'stat_anec_users',1,0,0,0,0,0,NOW()),
(84,2,'stat_daily_video',1,0,0,0,0,0,NOW()),
(85,2,'stat_moderators',1,0,0,0,0,0,NOW()),
(86,2,'stat_not_active_users',1,0,0,0,0,0,NOW()),
(87,2,'stat_tv',1,0,0,0,0,0,NOW()),
(88,2,'stat_tv_archive',1,0,0,0,0,0,NOW()),
(89,2,'stat_tv_users',1,0,0,0,0,0,NOW()),
(90,2,'stat_video',1,0,0,0,0,0,NOW()),
(91,2,'stat_video_genres',1,0,0,0,0,0,NOW()),
(92,2,'stat_video_users',1,0,0,0,0,0,NOW()),
(93,2,'stbgroup_members',1,0,0,0,0,0,NOW()),
(94,2,'stbgroups',1,0,0,0,0,0,NOW()),
(95,2,'storages',1,0,0,0,0,0,NOW()),
(96,2,'stream_servers',1,0,0,0,0,0,NOW()),
(97,2,'stream_zones',1,0,0,0,0,0,NOW()),
(98,2,'subscribe',1,0,0,0,0,0,NOW()),
(99,2,'subscribe_import',1,0,0,0,0,0,NOW()),
(100,2,'tariffs',1,0,0,0,0,0,NOW()),
(101,2,'tasks',1,0,0,0,0,0,NOW()),
(102,2,'tasks_archive',1,0,0,0,0,0,NOW()),
(103,2,'testers',1,0,0,0,0,0,NOW()),
(104,2,'today_user_status_report',1,0,0,0,0,0,NOW()),
(105,2,'unique_video',1,0,0,0,0,0,NOW()),
(106,2,'user',1,0,0,0,0,0,NOW()),
(107,2,'userlog',1,0,0,0,0,0,NOW()),
(108,2,'users',1,0,0,0,0,0,NOW()),
(109,2,'users_on_storage',1,0,0,0,0,0,NOW()),
(110,2,'vclub_ad',1,0,0,0,0,0,NOW()),
(111,2,'vclub_schedule',1,0,0,0,0,0,NOW()),
(112,2,'video_search',1,0,0,0,0,0,NOW()),
(113,2,'videolog',1,0,0,0,0,0,NOW());

UPDATE `administrators` SET gid=1 WHERE access=1;
UPDATE `administrators` SET gid=2 WHERE access=2;

-- //@UNDO

DROP TABLE `acl`;

ALTER TABLE `administrators` DROP `gid`;

DROP TABLE `admin_groups`;

--