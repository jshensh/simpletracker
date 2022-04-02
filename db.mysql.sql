-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2022-04-02 16:49:30
-- 服务器版本： 10.4.19-MariaDB-log
-- PHP 版本： 7.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- 数据库： `pt`
--

-- --------------------------------------------------------

--
-- 表的结构 `invitations`
--

CREATE TABLE `invitations` (
  `invitation_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `invitation_key` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `peers`
--

CREATE TABLE `peers` (
  `peer_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `torrent_id` int(10) UNSIGNED NOT NULL,
  `chosen_peer_id` char(40) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `port` int(11) NOT NULL,
  `uploaded` bigint(20) NOT NULL DEFAULT 0,
  `downloaded` bigint(20) NOT NULL DEFAULT 0,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `last_announce` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `torrents`
--

CREATE TABLE `torrents` (
  `torrent_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) DEFAULT 0,
  `name` varchar(1023) NOT NULL,
  `description` text NOT NULL,
  `data` longblob NOT NULL,
  `submitted` timestamp NOT NULL DEFAULT current_timestamp(),
  `info_hash` char(40) NOT NULL,
  `total_size` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `invited_by` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `passkey` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转储表的索引
--

--
-- 表的索引 `invitations`
--
ALTER TABLE `invitations`
  ADD PRIMARY KEY (`invitation_id`),
  ADD UNIQUE KEY `unique_index` (`email`,`invitation_key`),
  ADD KEY `invited` (`user_id`);

--
-- 表的索引 `peers`
--
ALTER TABLE `peers`
  ADD PRIMARY KEY (`peer_id`),
  ADD UNIQUE KEY `unique_index` (`user_id`,`torrent_id`,`chosen_peer_id`),
  ADD KEY `peer_torrent` (`torrent_id`);

--
-- 表的索引 `torrents`
--
ALTER TABLE `torrents`
  ADD PRIMARY KEY (`torrent_id`),
  ADD KEY `torrent_user_fk` (`user_id`);

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `invitations`
--
ALTER TABLE `invitations`
  MODIFY `invitation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `peers`
--
ALTER TABLE `peers`
  MODIFY `peer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `torrents`
--
ALTER TABLE `torrents`
  MODIFY `torrent_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 限制导出的表
--

--
-- 限制表 `invitations`
--
ALTER TABLE `invitations`
  ADD CONSTRAINT `invited` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `peers`
--
ALTER TABLE `peers`
  ADD CONSTRAINT `peer_torrent` FOREIGN KEY (`torrent_id`) REFERENCES `torrents` (`torrent_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `peer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `torrents`
--
ALTER TABLE `torrents`
  ADD CONSTRAINT `torrent_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

