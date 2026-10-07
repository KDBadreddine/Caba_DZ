-- CabaDZ chat migration
-- Database: u174200276_supapps
-- Run once in phpMyAdmin / MariaDB (safe if tables already exist)

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- ── users: photo + last seen (for chat list / online) ────────────────────────
ALTER TABLE `users`
  ADD COLUMN IF NOT EXISTS `avatar_url` varchar(255) DEFAULT NULL AFTER `id_document_url`,
  ADD COLUMN IF NOT EXISTS `last_seen_at` datetime DEFAULT NULL AFTER `updated_at`;

-- ── conversations (1-to-1 thread) ────────────────────────────────────────────
-- Always store the smaller user id in user_one_id so a pair is unique.
CREATE TABLE IF NOT EXISTS `conversations` (
  `id` char(36) NOT NULL,
  `user_one_id` int(10) UNSIGNED NOT NULL,
  `user_two_id` int(10) UNSIGNED NOT NULL,
  `match_id` char(36) DEFAULT NULL,
  `last_message` varchar(500) DEFAULT NULL,
  `last_message_at` datetime DEFAULT NULL,
  `last_sender_id` int(10) UNSIGNED DEFAULT NULL,
  `user_one_unread` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `user_two_unread` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_conversations_users` (`user_one_id`,`user_two_id`),
  KEY `idx_conversations_user_one` (`user_one_id`,`last_message_at`),
  KEY `idx_conversations_user_two` (`user_two_id`,`last_message_at`),
  KEY `idx_conversations_match` (`match_id`),
  CONSTRAINT `fk_conversations_user_one` FOREIGN KEY (`user_one_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_conversations_user_two` FOREIGN KEY (`user_two_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_conversations_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── messages ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `messages` (
  `id` char(36) NOT NULL,
  `conversation_id` char(36) NOT NULL,
  `sender_id` int(10) UNSIGNED NOT NULL,
  `body` text NOT NULL,
  `attachment_url` varchar(255) DEFAULT NULL,
  `message_type` enum('text','image','file') NOT NULL DEFAULT 'text',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_messages_conversation` (`conversation_id`,`created_at`),
  KEY `idx_messages_sender` (`sender_id`),
  KEY `idx_messages_unread` (`conversation_id`,`is_read`),
  CONSTRAINT `fk_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
