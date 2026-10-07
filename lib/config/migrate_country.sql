-- CabaDZ country ordering
-- Run once in phpMyAdmin / MariaDB
-- Lower `ordering` values appear first in search / country lists.

SET NAMES utf8mb4;

ALTER TABLE `country`
  ADD COLUMN IF NOT EXISTS `ordering` int(11) NOT NULL DEFAULT 0 AFTER `phonecode`;
