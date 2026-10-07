-- CabaDZ two-sided match + QR delivery
-- Database: u174200276_supapps
-- Run once in phpMyAdmin / MariaDB AFTER migrate_chat.sql

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- Allow chat-only matches (trip / shipment optional until linked)
ALTER TABLE `matches`
  MODIFY `trip_id` char(36) DEFAULT NULL,
  MODIFY `request_id` char(36) DEFAULT NULL;

ALTER TABLE `matches`
  ADD COLUMN IF NOT EXISTS `conversation_id` char(36) DEFAULT NULL AFTER `id`,
  ADD COLUMN IF NOT EXISTS `traveler_id` int(10) UNSIGNED DEFAULT NULL AFTER `conversation_id`,
  ADD COLUMN IF NOT EXISTS `sender_id` int(10) UNSIGNED DEFAULT NULL AFTER `traveler_id`,
  ADD COLUMN IF NOT EXISTS `traveler_confirmed` tinyint(1) NOT NULL DEFAULT 0 AFTER `sender_id`,
  ADD COLUMN IF NOT EXISTS `sender_confirmed` tinyint(1) NOT NULL DEFAULT 0 AFTER `traveler_confirmed`,
  ADD COLUMN IF NOT EXISTS `qr_token` char(36) DEFAULT NULL AFTER `delivery_code`;

CREATE UNIQUE INDEX IF NOT EXISTS `uq_matches_conversation` ON `matches` (`conversation_id`);
CREATE INDEX IF NOT EXISTS `idx_matches_qr_token` ON `matches` (`qr_token`);
CREATE INDEX IF NOT EXISTS `idx_matches_traveler` ON `matches` (`traveler_id`);
CREATE INDEX IF NOT EXISTS `idx_matches_sender` ON `matches` (`sender_id`);
