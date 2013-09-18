CREATE DATABASE IF NOT EXISTS `powerdns`;
USE `powerdns`;

CREATE TABLE IF NOT EXISTS `cryptokeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `flags` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  KEY `domainidindex` (`domain_id`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `domainmetadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `kind` varchar(16) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  KEY `domainmetaidindex` (`domain_id`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `master` varchar(128) DEFAULT NULL,
  `last_check` int(11) DEFAULT NULL,
  `type` varchar(6) NOT NULL,
  `notified_serial` int(11) DEFAULT NULL,
  `account` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_index` (`name`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `perm_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `descr` text NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=62 ;

INSERT IGNORE INTO `perm_items` SET `id` = 41,`name` = 'zone_master_add',`descr` = 'User is allowed to add new master zones.';
INSERT IGNORE INTO `perm_items` SET `id` = 42,`name` = 'zone_slave_add',`descr` = 'User is allowed to add new slave zones.';
INSERT IGNORE INTO `perm_items` SET `id` = 43,`name` = 'zone_content_view_own',`descr` = 'User is allowed to see the content and meta data of zones he owns.';
INSERT IGNORE INTO `perm_items` SET `id` = 44,`name` = 'zone_content_edit_own',`descr` = 'User is allowed to edit the content of zones he owns.';
INSERT IGNORE INTO `perm_items` SET `id` = 45,`name` = 'zone_meta_edit_own',`descr` = 'User is allowed to edit the meta data of zones he owns.';
INSERT IGNORE INTO `perm_items` SET `id` = 46,`name` = 'zone_content_view_others',`descr` = 'User is allowed to see the content and meta data of zones he does not own.';
INSERT IGNORE INTO `perm_items` SET `id` = 47,`name` = 'zone_content_edit_others',`descr` = 'User is allowed to edit the content of zones he does not own.';
INSERT IGNORE INTO `perm_items` SET `id` = 48,`name` = 'zone_meta_edit_others',`descr` = 'User is allowed to edit the meta data of zones he does not own.';
INSERT IGNORE INTO `perm_items` SET `id` = 49,`name` = 'search',`descr` = 'User is allowed to perform searches.';
INSERT IGNORE INTO `perm_items` SET `id` = 50,`name` = 'supermaster_view',`descr` = 'User is allowed to view supermasters.';
INSERT IGNORE INTO `perm_items` SET `id` = 51,`name` = 'supermaster_add',`descr` = 'User is allowed to add new supermasters.';
INSERT IGNORE INTO `perm_items` SET `id` = 52,`name` = 'supermaster_edit',`descr` = 'User is allowed to edit supermasters.';
INSERT IGNORE INTO `perm_items` SET `id` = 53,`name` = 'user_is_ueberuser',`descr` = 'User has full access. God-like. Redeemer.';
INSERT IGNORE INTO `perm_items` SET `id` = 54,`name` = 'user_view_others',`descr` = 'User is allowed to see other users and their details.';
INSERT IGNORE INTO `perm_items` SET `id` = 55,`name` = 'user_add_new',`descr` = 'User is allowed to add new users.';
INSERT IGNORE INTO `perm_items` SET `id` = 56,`name` = 'user_edit_own',`descr` = 'User is allowed to edit their own details.';
INSERT IGNORE INTO `perm_items` SET `id` = 57,`name` = 'user_edit_others',`descr` = 'User is allowed to edit other users.';
INSERT IGNORE INTO `perm_items` SET `id` = 58,`name` = 'user_passwd_edit_others',`descr` = 'User is allowed to edit the password of other users.';
INSERT IGNORE INTO `perm_items` SET `id` = 59,`name` = 'user_edit_templ_perm',`descr` = 'User is allowed to change the permission template that is assigned to a user.';
INSERT IGNORE INTO `perm_items` SET `id` = 60,`name` = 'templ_perm_add',`descr` = 'User is allowed to add new permission templates.';
INSERT IGNORE INTO `perm_items` SET `id` = 61,`name` = 'templ_perm_edit',`descr` = 'User is allowed to edit existing permission templates.';

CREATE TABLE IF NOT EXISTS `perm_templ` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `descr` text NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=2 ;

INSERT IGNORE INTO `perm_templ` SET `id` = 1,`name` = 'Administrator',`descr` = 'Administrator template with full rights.';

CREATE TABLE IF NOT EXISTS `perm_templ_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `templ_id` int(11) NOT NULL,
  `perm_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=2 ;

INSERT IGNORE INTO `perm_templ_items` SET `id` = 1,`templ_id` = 1,`perm_id` = 53;

CREATE TABLE IF NOT EXISTS `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `content` varchar(64000) DEFAULT NULL,
  `ttl` int(11) DEFAULT NULL,
  `prio` int(11) DEFAULT NULL,
  `change_date` int(11) DEFAULT NULL,
  `ordername` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `auth` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nametype_index` (`name`,`type`),
  KEY `domain_id` (`domain_id`),
  KEY `recordorder` (`domain_id`,`ordername`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `supermasters` (
  `ip` varchar(64) NOT NULL,
  `nameserver` varchar(255) NOT NULL,
  `account` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `tsigkeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `algorithm` varchar(50) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namealgoindex` (`name`,`algorithm`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(128) NOT NULL DEFAULT '',
  `fullname` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `perm_templ` tinyint(11) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=2 ;

INSERT IGNORE INTO `users` SET `id` = 1,`username` = 'admin',`password` = '21232f297a57a5a743894a0e4a801fc3',`fullname` = 'Administrator',`email` = 'admin@example.net',`description` = 'Administrator with full rights.',`perm_templ` = 1,`active` = 1;

CREATE TABLE IF NOT EXISTS `zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL DEFAULT '0',
  `comment` text,
  `zone_templ_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `zone_templ` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `descr` text NOT NULL,
  `owner` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `zone_templ_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone_templ_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(6) NOT NULL,
  `content` varchar(255) NOT NULL,
  `ttl` int(11) NOT NULL,
  `prio` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `records` ADD CONSTRAINT `records_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE;
