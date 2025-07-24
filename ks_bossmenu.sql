CREATE TABLE IF NOT EXISTS `ks_bossmenu_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` text DEFAULT NULL,
  `employee` text DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `job` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `ks_bossmenu_bonus_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `job` varchar(50) NOT NULL,
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