-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 12, 2026 at 08:36 PM
-- Server version: 11.8.9-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u174200276_supapps`
--

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `id` int(11) NOT NULL,
  `iso` char(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `nicename` varchar(80) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  `phonecode` int(5) NOT NULL,
  `ordering` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`id`, `iso`, `name`, `nicename`, `iso3`, `numcode`, `phonecode`) VALUES
(1, 'AF', 'AFGHANISTAN', 'Afghanistan', 'AFG', 4, 93),
(2, 'AL', 'ALBANIA', 'Albania', 'ALB', 8, 355),
(3, 'DZ', 'ALGERIA', 'Algeria', 'DZA', 12, 213),
(4, 'AS', 'AMERICAN SAMOA', 'American Samoa', 'ASM', 16, 1684),
(5, 'AD', 'ANDORRA', 'Andorra', 'AND', 20, 376),
(6, 'AO', 'ANGOLA', 'Angola', 'AGO', 24, 244),
(7, 'AI', 'ANGUILLA', 'Anguilla', 'AIA', 660, 1264),
(8, 'AQ', 'ANTARCTICA', 'Antarctica', 'ATA', 10, 0),
(9, 'AG', 'ANTIGUA AND BARBUDA', 'Antigua and Barbuda', 'ATG', 28, 1268),
(10, 'AR', 'ARGENTINA', 'Argentina', 'ARG', 32, 54),
(11, 'AM', 'ARMENIA', 'Armenia', 'ARM', 51, 374),
(12, 'AW', 'ARUBA', 'Aruba', 'ABW', 533, 297),
(13, 'AU', 'AUSTRALIA', 'Australia', 'AUS', 36, 61),
(14, 'AT', 'AUSTRIA', 'Austria', 'AUT', 40, 43),
(15, 'AZ', 'AZERBAIJAN', 'Azerbaijan', 'AZE', 31, 994),
(16, 'BS', 'BAHAMAS', 'Bahamas', 'BHS', 44, 1242),
(17, 'BH', 'BAHRAIN', 'Bahrain', 'BHR', 48, 973),
(18, 'BD', 'BANGLADESH', 'Bangladesh', 'BGD', 50, 880),
(19, 'BB', 'BARBADOS', 'Barbados', 'BRB', 52, 1246),
(20, 'BY', 'BELARUS', 'Belarus', 'BLR', 112, 375),
(21, 'BE', 'BELGIUM', 'Belgium', 'BEL', 56, 32),
(22, 'BZ', 'BELIZE', 'Belize', 'BLZ', 84, 501),
(23, 'BJ', 'BENIN', 'Benin', 'BEN', 204, 229),
(24, 'BM', 'BERMUDA', 'Bermuda', 'BMU', 60, 1441),
(25, 'BT', 'BHUTAN', 'Bhutan', 'BTN', 64, 975),
(26, 'BO', 'BOLIVIA', 'Bolivia', 'BOL', 68, 591),
(27, 'BQ', 'BONAIRE, SINT EUSTATIUS AND SABA', 'Bonaire, Sint Eustatius and Saba', 'BES', 535, 599),
(28, 'BA', 'BOSNIA AND HERZEGOVINA', 'Bosnia and Herzegovina', 'BIH', 70, 387),
(29, 'BW', 'BOTSWANA', 'Botswana', 'BWA', 72, 267),
(30, 'BV', 'BOUVET ISLAND', 'Bouvet Island', 'BVT', 74, 0),
(31, 'BR', 'BRAZIL', 'Brazil', 'BRA', 76, 55),
(32, 'IO', 'BRITISH INDIAN OCEAN TERRITORY', 'British Indian Ocean Territory', 'IOT', 86, 246),
(33, 'BN', 'BRUNEI DARUSSALAM', 'Brunei Darussalam', 'BRN', 96, 673),
(34, 'BG', 'BULGARIA', 'Bulgaria', 'BGR', 100, 359),
(35, 'BF', 'BURKINA FASO', 'Burkina Faso', 'BFA', 854, 226),
(36, 'BI', 'BURUNDI', 'Burundi', 'BDI', 108, 257),
(37, 'CV', 'CABO VERDE', 'Cabo Verde', 'CPV', 132, 238),
(38, 'KH', 'CAMBODIA', 'Cambodia', 'KHM', 116, 855),
(39, 'CM', 'CAMEROON', 'Cameroon', 'CMR', 120, 237),
(40, 'CA', 'CANADA', 'Canada', 'CAN', 124, 1),
(41, 'KY', 'CAYMAN ISLANDS', 'Cayman Islands', 'CYM', 136, 1345),
(42, 'CF', 'CENTRAL AFRICAN REPUBLIC', 'Central African Republic', 'CAF', 140, 236),
(43, 'TD', 'CHAD', 'Chad', 'TCD', 148, 235),
(44, 'CL', 'CHILE', 'Chile', 'CHL', 152, 56),
(45, 'CN', 'CHINA', 'China', 'CHN', 156, 86),
(46, 'CX', 'CHRISTMAS ISLAND', 'Christmas Island', 'CXR', 162, 61),
(47, 'CC', 'COCOS (KEELING) ISLANDS', 'Cocos (Keeling) Islands', 'CCK', 166, 61),
(48, 'CO', 'COLOMBIA', 'Colombia', 'COL', 170, 57),
(49, 'KM', 'COMOROS', 'Comoros', 'COM', 174, 269),
(50, 'CG', 'CONGO', 'Congo', 'COG', 178, 242),
(51, 'CD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'Congo, the Democratic Republic of the', 'COD', 180, 243),
(52, 'CK', 'COOK ISLANDS', 'Cook Islands', 'COK', 184, 682),
(53, 'CR', 'COSTA RICA', 'Costa Rica', 'CRI', 188, 506),
(54, 'CI', 'COTE D\'IVOIRE', 'Côte d\'Ivoire', 'CIV', 384, 225),
(55, 'HR', 'CROATIA', 'Croatia', 'HRV', 191, 385),
(56, 'CU', 'CUBA', 'Cuba', 'CUB', 192, 53),
(57, 'CW', 'CURACAO', 'Curaçao', 'CUW', 531, 599),
(58, 'CY', 'CYPRUS', 'Cyprus', 'CYP', 196, 357),
(59, 'CZ', 'CZECHIA', 'Czechia', 'CZE', 203, 420),
(60, 'DK', 'DENMARK', 'Denmark', 'DNK', 208, 45),
(61, 'DJ', 'DJIBOUTI', 'Djibouti', 'DJI', 262, 253),
(62, 'DM', 'DOMINICA', 'Dominica', 'DMA', 212, 1767),
(63, 'DO', 'DOMINICAN REPUBLIC', 'Dominican Republic', 'DOM', 214, 1809),
(64, 'EC', 'ECUADOR', 'Ecuador', 'ECU', 218, 593),
(65, 'EG', 'EGYPT', 'Egypt', 'EGY', 818, 20),
(66, 'SV', 'EL SALVADOR', 'El Salvador', 'SLV', 222, 503),
(67, 'GQ', 'EQUATORIAL GUINEA', 'Equatorial Guinea', 'GNQ', 226, 240),
(68, 'ER', 'ERITREA', 'Eritrea', 'ERI', 232, 291),
(69, 'EE', 'ESTONIA', 'Estonia', 'EST', 233, 372),
(70, 'SZ', 'ESWATINI', 'Eswatini', 'SWZ', 748, 268),
(71, 'ET', 'ETHIOPIA', 'Ethiopia', 'ETH', 231, 251),
(72, 'FK', 'FALKLAND ISLANDS (MALVINAS)', 'Falkland Islands (Malvinas)', 'FLK', 238, 500),
(73, 'FO', 'FAROE ISLANDS', 'Faroe Islands', 'FRO', 234, 298),
(74, 'FJ', 'FIJI', 'Fiji', 'FJI', 242, 679),
(75, 'FI', 'FINLAND', 'Finland', 'FIN', 246, 358),
(76, 'FR', 'FRANCE', 'France', 'FRA', 250, 33),
(77, 'GF', 'FRENCH GUIANA', 'French Guiana', 'GUF', 254, 594),
(78, 'PF', 'FRENCH POLYNESIA', 'French Polynesia', 'PYF', 258, 689),
(79, 'TF', 'FRENCH SOUTHERN TERRITORIES', 'French Southern Territories', 'ATF', 260, 0),
(80, 'GA', 'GABON', 'Gabon', 'GAB', 266, 241),
(81, 'GM', 'GAMBIA', 'Gambia', 'GMB', 270, 220),
(82, 'GE', 'GEORGIA', 'Georgia', 'GEO', 268, 995),
(83, 'DE', 'GERMANY', 'Germany', 'DEU', 276, 49),
(84, 'GH', 'GHANA', 'Ghana', 'GHA', 288, 233),
(85, 'GI', 'GIBRALTAR', 'Gibraltar', 'GIB', 292, 350),
(86, 'GR', 'GREECE', 'Greece', 'GRC', 300, 30),
(87, 'GL', 'GREENLAND', 'Greenland', 'GRL', 304, 299),
(88, 'GD', 'GRENADA', 'Grenada', 'GRD', 308, 1473),
(89, 'GP', 'GUADELOUPE', 'Guadeloupe', 'GLP', 312, 590),
(90, 'GU', 'GUAM', 'Guam', 'GUM', 316, 1671),
(91, 'GT', 'GUATEMALA', 'Guatemala', 'GTM', 320, 502),
(92, 'GG', 'GUERNSEY', 'Guernsey', 'GGY', 831, 44),
(93, 'GN', 'GUINEA', 'Guinea', 'GIN', 324, 224),
(94, 'GW', 'GUINEA-BISSAU', 'Guinea-Bissau', 'GNB', 624, 245),
(95, 'GY', 'GUYANA', 'Guyana', 'GUY', 328, 592),
(96, 'HT', 'HAITI', 'Haiti', 'HTI', 332, 509),
(97, 'HM', 'HEARD ISLAND AND MCDONALD ISLANDS', 'Heard Island and McDonald Islands', 'HMD', 334, 0),
(98, 'VA', 'HOLY SEE', 'Holy See', 'VAT', 336, 379),
(99, 'HN', 'HONDURAS', 'Honduras', 'HND', 340, 504),
(100, 'HK', 'HONG KONG', 'Hong Kong', 'HKG', 344, 852),
(101, 'HU', 'HUNGARY', 'Hungary', 'HUN', 348, 36),
(102, 'IS', 'ICELAND', 'Iceland', 'ISL', 352, 354),
(103, 'IN', 'INDIA', 'India', 'IND', 356, 91),
(104, 'ID', 'INDONESIA', 'Indonesia', 'IDN', 360, 62),
(105, 'IR', 'IRAN, ISLAMIC REPUBLIC OF', 'Iran, Islamic Republic of', 'IRN', 364, 98),
(106, 'IQ', 'IRAQ', 'Iraq', 'IRQ', 368, 964),
(107, 'IE', 'IRELAND', 'Ireland', 'IRL', 372, 353),
(108, 'IM', 'ISLE OF MAN', 'Isle of Man', 'IMN', 833, 44),
(109, 'IL', 'ISRAEL', 'Israel', 'ISR', 376, 972),
(110, 'IT', 'ITALY', 'Italy', 'ITA', 380, 39),
(111, 'JM', 'JAMAICA', 'Jamaica', 'JAM', 388, 1876),
(112, 'JP', 'JAPAN', 'Japan', 'JPN', 392, 81),
(113, 'JE', 'JERSEY', 'Jersey', 'JEY', 832, 44),
(114, 'JO', 'JORDAN', 'Jordan', 'JOR', 400, 962),
(115, 'KZ', 'KAZAKHSTAN', 'Kazakhstan', 'KAZ', 398, 7),
(116, 'KE', 'KENYA', 'Kenya', 'KEN', 404, 254),
(117, 'KI', 'KIRIBATI', 'Kiribati', 'KIR', 296, 686),
(118, 'KP', 'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF', 'Korea, Democratic People\'s Republic of', 'PRK', 408, 850),
(119, 'KR', 'KOREA, REPUBLIC OF', 'Korea, Republic of', 'KOR', 410, 82),
(120, 'XK', 'KOSOVO', 'Kosovo', 'XKX', NULL, 383),
(121, 'KW', 'KUWAIT', 'Kuwait', 'KWT', 414, 965),
(122, 'KG', 'KYRGYZSTAN', 'Kyrgyzstan', 'KGZ', 417, 996),
(123, 'LA', 'LAO PEOPLE\'S DEMOCRATIC REPUBLIC', 'Lao People\'s Democratic Republic', 'LAO', 418, 856),
(124, 'LV', 'LATVIA', 'Latvia', 'LVA', 428, 371),
(125, 'LB', 'LEBANON', 'Lebanon', 'LBN', 422, 961),
(126, 'LS', 'LESOTHO', 'Lesotho', 'LSO', 426, 266),
(127, 'LR', 'LIBERIA', 'Liberia', 'LBR', 430, 231),
(128, 'LY', 'LIBYA', 'Libya', 'LBY', 434, 218),
(129, 'LI', 'LIECHTENSTEIN', 'Liechtenstein', 'LIE', 438, 423),
(130, 'LT', 'LITHUANIA', 'Lithuania', 'LTU', 440, 370),
(131, 'LU', 'LUXEMBOURG', 'Luxembourg', 'LUX', 442, 352),
(132, 'MO', 'MACAO', 'Macao', 'MAC', 446, 853),
(133, 'MG', 'MADAGASCAR', 'Madagascar', 'MDG', 450, 261),
(134, 'MW', 'MALAWI', 'Malawi', 'MWI', 454, 265),
(135, 'MY', 'MALAYSIA', 'Malaysia', 'MYS', 458, 60),
(136, 'MV', 'MALDIVES', 'Maldives', 'MDV', 462, 960),
(137, 'ML', 'MALI', 'Mali', 'MLI', 466, 223),
(138, 'MT', 'MALTA', 'Malta', 'MLT', 470, 356),
(139, 'MH', 'MARSHALL ISLANDS', 'Marshall Islands', 'MHL', 584, 692),
(140, 'MQ', 'MARTINIQUE', 'Martinique', 'MTQ', 474, 596),
(141, 'MR', 'MAURITANIA', 'Mauritania', 'MRT', 478, 222),
(142, 'MU', 'MAURITIUS', 'Mauritius', 'MUS', 480, 230),
(143, 'YT', 'MAYOTTE', 'Mayotte', 'MYT', 175, 262),
(144, 'MX', 'MEXICO', 'Mexico', 'MEX', 484, 52),
(145, 'FM', 'MICRONESIA, FEDERATED STATES OF', 'Micronesia, Federated States of', 'FSM', 583, 691),
(146, 'MD', 'MOLDOVA, REPUBLIC OF', 'Moldova, Republic of', 'MDA', 498, 373),
(147, 'MC', 'MONACO', 'Monaco', 'MCO', 492, 377),
(148, 'MN', 'MONGOLIA', 'Mongolia', 'MNG', 496, 976),
(149, 'ME', 'MONTENEGRO', 'Montenegro', 'MNE', 499, 382),
(150, 'MS', 'MONTSERRAT', 'Montserrat', 'MSR', 500, 1664),
(151, 'MA', 'MOROCCO', 'Morocco', 'MAR', 504, 212),
(152, 'MZ', 'MOZAMBIQUE', 'Mozambique', 'MOZ', 508, 258),
(153, 'MM', 'MYANMAR', 'Myanmar', 'MMR', 104, 95),
(154, 'NA', 'NAMIBIA', 'Namibia', 'NAM', 516, 264),
(155, 'NR', 'NAURU', 'Nauru', 'NRU', 520, 674),
(156, 'NP', 'NEPAL', 'Nepal', 'NPL', 524, 977),
(157, 'NL', 'NETHERLANDS', 'Netherlands', 'NLD', 528, 31),
(158, 'NC', 'NEW CALEDONIA', 'New Caledonia', 'NCL', 540, 687),
(159, 'NZ', 'NEW ZEALAND', 'New Zealand', 'NZL', 554, 64),
(160, 'NI', 'NICARAGUA', 'Nicaragua', 'NIC', 558, 505),
(161, 'NE', 'NIGER', 'Niger', 'NER', 562, 227),
(162, 'NG', 'NIGERIA', 'Nigeria', 'NGA', 566, 234),
(163, 'NU', 'NIUE', 'Niue', 'NIU', 570, 683),
(164, 'NF', 'NORFOLK ISLAND', 'Norfolk Island', 'NFK', 574, 672),
(165, 'MK', 'NORTH MACEDONIA', 'North Macedonia', 'MKD', 807, 389),
(166, 'MP', 'NORTHERN MARIANA ISLANDS', 'Northern Mariana Islands', 'MNP', 580, 1670),
(167, 'NO', 'NORWAY', 'Norway', 'NOR', 578, 47),
(168, 'OM', 'OMAN', 'Oman', 'OMN', 512, 968),
(169, 'PK', 'PAKISTAN', 'Pakistan', 'PAK', 586, 92),
(170, 'PW', 'PALAU', 'Palau', 'PLW', 585, 680),
(171, 'PS', 'PALESTINE, STATE OF', 'Palestine, State of', 'PSE', 275, 970),
(172, 'PA', 'PANAMA', 'Panama', 'PAN', 591, 507),
(173, 'PG', 'PAPUA NEW GUINEA', 'Papua New Guinea', 'PNG', 598, 675),
(174, 'PY', 'PARAGUAY', 'Paraguay', 'PRY', 600, 595),
(175, 'PE', 'PERU', 'Peru', 'PER', 604, 51),
(176, 'PH', 'PHILIPPINES', 'Philippines', 'PHL', 608, 63),
(177, 'PN', 'PITCAIRN', 'Pitcairn', 'PCN', 612, 64),
(178, 'PL', 'POLAND', 'Poland', 'POL', 616, 48),
(179, 'PT', 'PORTUGAL', 'Portugal', 'PRT', 620, 351),
(180, 'PR', 'PUERTO RICO', 'Puerto Rico', 'PRI', 630, 1787),
(181, 'QA', 'QATAR', 'Qatar', 'QAT', 634, 974),
(182, 'RE', 'REUNION', 'Réunion', 'REU', 638, 262),
(183, 'RO', 'ROMANIA', 'Romania', 'ROU', 642, 40),
(184, 'RU', 'RUSSIAN FEDERATION', 'Russian Federation', 'RUS', 643, 7),
(185, 'RW', 'RWANDA', 'Rwanda', 'RWA', 646, 250),
(186, 'BL', 'SAINT BARTHELEMY', 'Saint Barthélemy', 'BLM', 652, 590),
(187, 'SH', 'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA', 'Saint Helena, Ascension and Tristan da Cunha', 'SHN', 654, 290),
(188, 'KN', 'SAINT KITTS AND NEVIS', 'Saint Kitts and Nevis', 'KNA', 659, 1869),
(189, 'LC', 'SAINT LUCIA', 'Saint Lucia', 'LCA', 662, 1758),
(190, 'MF', 'SAINT MARTIN (FRENCH PART)', 'Saint Martin (French part)', 'MAF', 663, 590),
(191, 'PM', 'SAINT PIERRE AND MIQUELON', 'Saint Pierre and Miquelon', 'SPM', 666, 508),
(192, 'VC', 'SAINT VINCENT AND THE GRENADINES', 'Saint Vincent and the Grenadines', 'VCT', 670, 1784),
(193, 'WS', 'SAMOA', 'Samoa', 'WSM', 882, 685),
(194, 'SM', 'SAN MARINO', 'San Marino', 'SMR', 674, 378),
(195, 'ST', 'SAO TOME AND PRINCIPE', 'Sao Tome and Principe', 'STP', 678, 239),
(196, 'SA', 'SAUDI ARABIA', 'Saudi Arabia', 'SAU', 682, 966),
(197, 'SN', 'SENEGAL', 'Senegal', 'SEN', 686, 221),
(198, 'RS', 'SERBIA', 'Serbia', 'SRB', 688, 381),
(199, 'SC', 'SEYCHELLES', 'Seychelles', 'SYC', 690, 248),
(200, 'SL', 'SIERRA LEONE', 'Sierra Leone', 'SLE', 694, 232),
(201, 'SG', 'SINGAPORE', 'Singapore', 'SGP', 702, 65),
(202, 'SX', 'SINT MAARTEN (DUTCH PART)', 'Sint Maarten (Dutch part)', 'SXM', 534, 1721),
(203, 'SK', 'SLOVAKIA', 'Slovakia', 'SVK', 703, 421),
(204, 'SI', 'SLOVENIA', 'Slovenia', 'SVN', 705, 386),
(205, 'SB', 'SOLOMON ISLANDS', 'Solomon Islands', 'SLB', 90, 677),
(206, 'SO', 'SOMALIA', 'Somalia', 'SOM', 706, 252),
(207, 'ZA', 'SOUTH AFRICA', 'South Africa', 'ZAF', 710, 27),
(208, 'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'South Georgia and the South Sandwich Islands', 'SGS', 239, 500),
(209, 'SS', 'SOUTH SUDAN', 'South Sudan', 'SSD', 728, 211),
(210, 'ES', 'SPAIN', 'Spain', 'ESP', 724, 34),
(211, 'LK', 'SRI LANKA', 'Sri Lanka', 'LKA', 144, 94),
(212, 'SD', 'SUDAN', 'Sudan', 'SDN', 729, 249),
(213, 'SR', 'SURINAME', 'Suriname', 'SUR', 740, 597),
(214, 'SJ', 'SVALBARD AND JAN MAYEN', 'Svalbard and Jan Mayen', 'SJM', 744, 47),
(215, 'SE', 'SWEDEN', 'Sweden', 'SWE', 752, 46),
(216, 'CH', 'SWITZERLAND', 'Switzerland', 'CHE', 756, 41),
(217, 'SY', 'SYRIAN ARAB REPUBLIC', 'Syrian Arab Republic', 'SYR', 760, 963),
(218, 'TW', 'TAIWAN, PROVINCE OF CHINA', 'Taiwan, Province of China', 'TWN', 158, 886),
(219, 'TJ', 'TAJIKISTAN', 'Tajikistan', 'TJK', 762, 992),
(220, 'TZ', 'TANZANIA, UNITED REPUBLIC OF', 'Tanzania, United Republic of', 'TZA', 834, 255),
(221, 'TH', 'THAILAND', 'Thailand', 'THA', 764, 66),
(222, 'TL', 'TIMOR-LESTE', 'Timor-Leste', 'TLS', 626, 670),
(223, 'TG', 'TOGO', 'Togo', 'TGO', 768, 228),
(224, 'TK', 'TOKELAU', 'Tokelau', 'TKL', 772, 690),
(225, 'TO', 'TONGA', 'Tonga', 'TON', 776, 676),
(226, 'TT', 'TRINIDAD AND TOBAGO', 'Trinidad and Tobago', 'TTO', 780, 1868),
(227, 'TN', 'TUNISIA', 'Tunisia', 'TUN', 788, 216),
(228, 'TR', 'TURKIYE', 'Türkiye', 'TUR', 792, 90),
(229, 'TM', 'TURKMENISTAN', 'Turkmenistan', 'TKM', 795, 993),
(230, 'TC', 'TURKS AND CAICOS ISLANDS', 'Turks and Caicos Islands', 'TCA', 796, 1649),
(231, 'TV', 'TUVALU', 'Tuvalu', 'TUV', 798, 688),
(232, 'UG', 'UGANDA', 'Uganda', 'UGA', 800, 256),
(233, 'UA', 'UKRAINE', 'Ukraine', 'UKR', 804, 380),
(234, 'AE', 'UNITED ARAB EMIRATES', 'United Arab Emirates', 'ARE', 784, 971),
(235, 'GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826, 44),
(236, 'US', 'UNITED STATES', 'United States', 'USA', 840, 1),
(237, 'UM', 'UNITED STATES MINOR OUTLYING ISLANDS', 'United States Minor Outlying Islands', 'UMI', 581, 1),
(238, 'UY', 'URUGUAY', 'Uruguay', 'URY', 858, 598),
(239, 'UZ', 'UZBEKISTAN', 'Uzbekistan', 'UZB', 860, 998),
(240, 'VU', 'VANUATU', 'Vanuatu', 'VUT', 548, 678),
(241, 'VE', 'VENEZUELA', 'Venezuela', 'VEN', 862, 58),
(242, 'VN', 'VIET NAM', 'Viet Nam', 'VNM', 704, 84),
(243, 'VG', 'VIRGIN ISLANDS, BRITISH', 'Virgin Islands, British', 'VGB', 92, 1284),
(244, 'VI', 'VIRGIN ISLANDS, U.S.', 'Virgin Islands, U.S.', 'VIR', 850, 1340),
(245, 'WF', 'WALLIS AND FUTUNA', 'Wallis and Futuna', 'WLF', 876, 681),
(246, 'EH', 'WESTERN SAHARA', 'Western Sahara', 'ESH', 732, 212),
(247, 'YE', 'YEMEN', 'Yemen', 'YEM', 887, 967),
(248, 'ZM', 'ZAMBIA', 'Zambia', 'ZMB', 894, 260),
(249, 'ZW', 'ZIMBABWE', 'Zimbabwe', 'ZWE', 716, 263);

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
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
  `deleted` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `matches`
--

CREATE TABLE `matches` (
  `id` char(36) NOT NULL,
  `conversation_id` char(36) DEFAULT NULL,
  `traveler_id` int(10) UNSIGNED DEFAULT NULL,
  `sender_id` int(10) UNSIGNED DEFAULT NULL,
  `traveler_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `sender_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `trip_id` char(36) DEFAULT NULL,
  `request_id` char(36) DEFAULT NULL,
  `agreed_price` decimal(10,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `prohibited_ack` tinyint(1) NOT NULL DEFAULT 0,
  `handover_photo_url` varchar(255) DEFAULT NULL,
  `delivery_code` char(6) DEFAULT NULL,
  `qr_token` char(36) DEFAULT NULL,
  `status` enum('pending','confirmed','handed_over','delivered','disputed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` char(36) NOT NULL,
  `conversation_id` char(36) NOT NULL,
  `sender_id` int(10) UNSIGNED NOT NULL,
  `body` text NOT NULL,
  `attachment_url` varchar(255) DEFAULT NULL,
  `message_type` enum('text','image','file') NOT NULL DEFAULT 'text',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` varchar(500) NOT NULL,
  `related_match_id` char(36) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prohibited_items`
--

CREATE TABLE `prohibited_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `category` varchar(80) NOT NULL,
  `description_ar` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `prohibited_items`
--

INSERT INTO `prohibited_items` (`id`, `category`, `description_ar`) VALUES
(1, 'نقود وعملات', 'مبالغ نقدية تتجاوز الحد المسموح به قانونيًا لدى الجمارك'),
(2, 'مواد خطرة', 'مواد قابلة للاشتعال أو الانفجار أو أي سوائل مضغوطة'),
(3, 'أدوية بدون وصفة', 'أدوية طبية لا تحمل وصفة رسمية سارية المفعول'),
(4, 'أسلحة', 'أي نوع من الأسلحة أو الذخيرة أو أجزائها'),
(5, 'سلع مقلدة', 'منتجات تحمل علامات تجارية مقلدة');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` char(36) NOT NULL,
  `sender_id` char(36) NOT NULL,
  `item_description` varchar(255) NOT NULL,
  `item_category` varchar(50) NOT NULL,
  `weight_kg` decimal(5,1) NOT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  `origin_city` varchar(80) NOT NULL,
  `destination_city` varchar(80) NOT NULL,
  `max_budget` decimal(10,2) DEFAULT NULL,
  `status` enum('open','matched','completed','cancelled') NOT NULL DEFAULT 'open',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `match_id` char(36) NOT NULL,
  `reviewer_id` char(36) NOT NULL,
  `reviewee_id` char(36) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `match_id` char(36) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `commission` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `payment_provider` varchar(40) NOT NULL DEFAULT 'stripe',
  `provider_ref` varchar(120) DEFAULT NULL,
  `escrow_status` enum('held','released','refunded') NOT NULL DEFAULT 'held',
  `released_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--

CREATE TABLE `trips` (
  `id` int(11) NOT NULL,
  `traveler_id` char(36) NOT NULL,
  `origin_country_id` int(11) NOT NULL,
  `origin_city` varchar(80) NOT NULL,
  `destination_country_id` int(11) NOT NULL,
  `travel_date` date NOT NULL,
  `available_kg` int(11) NOT NULL DEFAULT 1,
  `price_per_kg` int(11) NOT NULL DEFAULT 1,
  `currency` enum('EUR','USD','DZD') NOT NULL DEFAULT 'EUR',
  `accepted_categories` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`accepted_categories`)),
  `notes` varchar(500) DEFAULT NULL,
  `status` enum('active','matched','completed','cancelled') NOT NULL DEFAULT 'active',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_by` int(11) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trips`
--

INSERT INTO `trips` (`id`, `traveler_id`, `origin_country_id`, `origin_city`, `destination_country_id`, `travel_date`, `available_kg`, `price_per_kg`, `currency`, `accepted_categories`, `notes`, `status`, `created_by`, `created_at`, `modified_by`, `modified_at`, `updated_at`, `deleted`) VALUES
(1, '2', 3, '', 5, '2026-09-30', 100, 100, 'EUR', NULL, '', 'active', 1, '2026-09-12 18:24:42', 1, '2026-09-12 18:41:11', '2026-09-12 19:18:25', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` enum('superadmin','client') NOT NULL DEFAULT 'client',
  `full_name` varchar(120) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `id_verified` tinyint(1) NOT NULL DEFAULT 0,
  `id_document_url` varchar(255) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `role` enum('sender','traveler','both') NOT NULL DEFAULT 'both',
  `rating_avg` decimal(2,1) NOT NULL DEFAULT 0.0,
  `rating_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `country` varchar(80) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `status` enum('active','suspended','banned') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_seen_at` datetime DEFAULT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `type`, `full_name`, `phone`, `email`, `password`, `id_verified`, `id_document_url`, `role`, `rating_avg`, `rating_count`, `country`, `city`, `status`, `created_at`, `updated_at`, `deleted`) VALUES
(1, 'superadmin', 'ياسين كمال', '+33612345678', 'yacine@example.com', '7c222fb2927d828af22f592134e8932480637c0d', 1, NULL, 'traveler', 4.9, 23, 'فرنسا', 'باريس', 'active', '2026-09-07 20:55:23', '2026-09-07 21:14:24', 0),
(2, 'client', 'سارة بلقاسم', '+33698765432', 'sara@example.com', '7c222fb2927d828af22f592134e8932480637c0d', 1, NULL, 'traveler', 4.7, 11, 'فرنسا', 'ليون', 'active', '2026-09-07 20:55:23', '2026-09-07 21:14:27', 0),
(3, 'client', 'كريم زياني', '+213551234567', 'karim@example.com', '7c222fb2927d828af22f592134e8932480637c0d', 1, NULL, 'sender', 0.0, 0, 'الجزائر', 'الجزائر العاصمة', 'active', '2026-09-07 20:55:23', '2026-09-07 21:14:30', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_conversations_users` (`user_one_id`,`user_two_id`),
  ADD KEY `idx_conversations_user_one` (`user_one_id`,`last_message_at`),
  ADD KEY `idx_conversations_user_two` (`user_two_id`,`last_message_at`),
  ADD KEY `idx_conversations_match` (`match_id`);

--
-- Indexes for table `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_matches_request` (`request_id`),
  ADD UNIQUE KEY `uq_matches_conversation` (`conversation_id`),
  ADD KEY `idx_matches_qr_token` (`qr_token`),
  ADD KEY `idx_matches_traveler` (`traveler_id`),
  ADD KEY `idx_matches_sender` (`sender_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_messages_conversation` (`conversation_id`,`created_at`),
  ADD KEY `idx_messages_sender` (`sender_id`),
  ADD KEY `idx_messages_unread` (`conversation_id`,`is_read`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `prohibited_items`
--
ALTER TABLE `prohibited_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_requests_sender` (`sender_id`),
  ADD KEY `idx_requests_search` (`destination_city`,`status`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reviews_once` (`match_id`,`reviewer_id`),
  ADD KEY `fk_reviews_reviewer` (`reviewer_id`),
  ADD KEY `fk_reviews_reviewee` (`reviewee_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_transactions_match` (`match_id`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_trips_traveler` (`traveler_id`),
  ADD KEY `idx_trips_search` (`destination_country_id`,`travel_date`,`status`),
  ADD KEY `idx_trips_origin` (`origin_city`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_phone` (`phone`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=250;

--
-- AUTO_INCREMENT for table `prohibited_items`
--
ALTER TABLE `prohibited_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `fk_conversations_user_one` FOREIGN KEY (`user_one_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conversations_user_two` FOREIGN KEY (`user_two_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conversations_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `fk_matches_request` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
