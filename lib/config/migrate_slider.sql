-- CabaDZ home sliders
-- Run once in phpMyAdmin / MariaDB
-- Used by the home-screen swiper.

SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS `slider` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(150) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `ordering` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_slider_status` (`status`,`ordering`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `slider` (`title`, `subtitle`, `image_url`, `link`, `ordering`, `status`, `deleted`) VALUES
('CabaDZ', 'فرص جديدة في كل رحلة', 'https://images.unsplash.com/photo-1556388158-158ea5ccacbd?auto=format&fit=crop&w=1400&q=80', '/add-trip', 1, 'active', 0),
('سافر ووصل', 'أضف رحلتك وساعد المرسلين', 'https://images.unsplash.com/photo-1436491865331-4ffd72457395?auto=format&fit=crop&w=1400&q=80', '/add-trip', 2, 'active', 0),
('أرسل شحنتك', 'اعثر على مسافر في طريقك', 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1400&q=80', '/add-shipment', 3, 'active', 0);
