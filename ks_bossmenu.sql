CREATE TABLE IF NOT EXISTS `ks_bossmenu_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` text DEFAULT NULL,
  `employee` text DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `job` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `ks_bossmenu_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` text DEFAULT NULL,
  `employee` text DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `job` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
