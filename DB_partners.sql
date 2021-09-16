-- Create DB `affiliate_program`

CREATE DATABASE IF NOT EXISTS `partners_program` DEFAULT CHARACTER SET utf8;
USE `partners_program`;

-- Table `statuses`

CREATE TABLE IF NOT EXISTS `statuses` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `alias` char(19) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Статусы';

-- Table `partners`

CREATE TABLE IF NOT EXISTS `partners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `name` char(20) DEFAULT NULL,
  `phone` char(13) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `code_1c` int(10) DEFAULT NULL,
  `personal_discount` float DEFAULT '3.00',
  PRIMARY KEY (`id`),
  INDEX (`name`, `phone`),
  INDEX (`name`, `email`),
  INDEX (`name`, `personal_discount`),
  INDEX (`code_1c`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Организации';

-- Table `images_types`

CREATE TABLE IF NOT EXISTS `images_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mem_type` char(4) NOT NULL DEFAULT 'jpg',
  `width` varchar(255) NOT NULL,
  `height` varchar(255) NOT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`status`) REFERENCES `statuses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (`mem_type`, `status`),
  INDEX (`mem_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Типы изображений';

-- Table `images_dirs`

CREATE TABLE IF NOT EXISTS `images_dirs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dir` varchar(255) NOT NULL DEFAULT '',
  `mem_type_id` int(10) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`mem_type_id`) REFERENCES `images_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (`mem_type_id`, `dir`),
  INDEX (`dir`, `mem_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Путь к каталогу изображений';

-- Table `partners_modules_subtypes`

CREATE TABLE IF NOT EXISTS `partners_modules_subtypes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(96) DEFAULT NULL,
  `position` int(10) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Подтипы модулей';

-- Table `partners_modules_subtypes_descriptions`

CREATE TABLE IF NOT EXISTS `partners_modules_subtypes_descriptions` (
  `module_subtype_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`module_subtype_id`,`name`),
  FOREIGN KEY (`module_subtype_id`) REFERENCES `partners_modules_subtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Описание подтипов модулей';

-- Table `partners_modules_types`

CREATE TABLE IF NOT EXISTS `partners_modules_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(192) DEFAULT NULL,
  `position` int(10) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Типы модулей';

-- Table `partners_modules`

CREATE TABLE IF NOT EXISTS `partners_modules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_type` int(10) unsigned DEFAULT NULL,
  `module_subtype` int(10) unsigned DEFAULT NULL,
  `alias` varchar(192) DEFAULT NULL,
  `budget` float unsigned NOT NULL DEFAULT '0',
  `amount_products` int(10) unsigned NOT NULL DEFAULT '1',
  `amount_stands` int(10) unsigned NOT NULL DEFAULT '1',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remainder` int(10) NOT NULL DEFAULT '1',
  `position` int(10) NOT NULL DEFAULT '100',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`module_type`) REFERENCES `partners_modules_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`module_subtype`) REFERENCES `partners_modules_subtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (`module_type`, `module_subtype`),
  INDEX (`module_type`, `status`),
  INDEX (`module_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модули с товарами';

-- Table `partners_modules_descriptions`

CREATE TABLE IF NOT EXISTS `partners_modules_descriptions` (
  `module_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `short_text` varchar(255),
  `text` text,
  PRIMARY KEY (`module_id`,`name`),
  FOREIGN KEY (`module_id`) REFERENCES `partners_modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Описание модулей';

-- Table `partners_modules_images`

CREATE TABLE IF NOT EXISTS `partners_modules_images` (
  `module_id` int(10) unsigned NOT NULL,
  `img_name` varchar(255) DEFAULT NULL,
  `img_mem_type_id` int(10) unsigned NOT NULL,
  `img_dir_id` int(10) unsigned NOT NULL DEFAULT '1', 
  `alt` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `status` tinyint(3) unsigned DEFAULT '1',
  UNIQUE KEY `module_id` (`module_id`),
  PRIMARY KEY (`module_id`, `status`),
  FOREIGN KEY (`module_id`) REFERENCES `partners_modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`img_mem_type_id`) REFERENCES `images_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`img_dir_id`) REFERENCES `images_dirs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`status`) REFERENCES `statuses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (`module_id`, `img_name`),
  INDEX (`module_id`, `status`),
  INDEX (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Изображения модулей';

-- Table `partners_modules_order`

CREATE TABLE IF NOT EXISTS `partners_modules_orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `partners_id` int(10) unsigned NOT NULL,
  `modules` varchar(255) NOT NULL COMMENT 'JSON data',
  `total_sum` float DEFAULT NULL,
  `personal_discount` float NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`partners_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (`partners_id`, `date`),
  INDEX (`partners_id`, `total_sum`),
  INDEX (`partners_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Заказы';

-- Table `partners_modules_types_descriptions`

CREATE TABLE IF NOT EXISTS `partners_modules_types_descriptions` (
  `module_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `short_text` text,
  `text` text,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`module_type_id`,`name`),
  FOREIGN KEY (`module_type_id`) REFERENCES `partners_modules_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Описание типов модулей';

-- Write test records in `statuses`

INSERT INTO `statuses` (`id`,  `alias`) VALUES
(1, 'enable'),
(2, 'disable'), 
(3, 'hidden');

-- Write test records `images_types`

INSERT INTO `images_types` (`id`, `mem_type`, `width`, `height`, `position`, `status`) VALUES
(1, 1, '270px', '270px', 1, 1),
(2, 2, '270px', '270px', 1, 1),
(3, 1, '270px', '270px', 1, 1),
(4, 1, '270px', '270px', 1, 1);

-- Write test records in `images_dirs`

INSERT INTO `images_dirs` (`id`, `dir`, `mem_type_id`, `status`) VALUES
(1, 'images/modules/bk', 1, 1),
(2, 'images/modules/dr', 1, 1), 
(3, 'images/modules/ml', 1, 1),
(4, 'images/modules/dral', 1, 1);

-- Write test records `partners_modules_subtypes`

INSERT INTO `partners_modules_subtypes` (`id`, `alias`, `position`) VALUES
(1, 'subtype-1', 1),
(2, 'subtype-2', 2),
(3, 'subtype-3', 3),
(4, 'subtype-4', 4);

-- Write test records `partners_modules_subtypes_descriptions`

INSERT INTO `partners_modules_subtypes_descriptions` (`module_subtype_id`, `name`) VALUES
(1, 'Имя подтипа 1'),
(2, 'Имя подтипа 2'),
(3, 'Имя подтипа 3'),
(4, 'Имя подтипа 4');

-- Write test records `partners_modules_types`

INSERT INTO `partners_modules_types` (`id`, `alias`, `position`) VALUES
(1, 'start', 1),
(2, 'main', 2),
(3, 'additional', 3);

-- Write test records `partners_modules`

INSERT INTO `partners_modules` (`id`, `module_type`, `module_subtype`, `alias`, `budget`, `amount_products`, `amount_stands`, `date_added`, `remainder`, `position`, `status`) VALUES
(1, 1, NULL, 'grocery', 5400, 14, 3, '2021-05-12 06:38:45', 10, 1, 1),
(2, 2, 1, 'juices', 6300, 54, 1, '2021-05-12 06:39:25', 10, 1, 1),
(3, 2, 1, 'soda', 5600, 45, 3, '2021-05-12 06:40:13', 20, 1, 1),
(4, 2, 3, 'not-carbonated', 12, 82, 2, '2021-05-12 06:40:13', 30, 1, 1),
(5, 3, NULL, 'fermented-milk', 32, 90, 2, '2021-05-12 13:02:34', 10, 1, 1),
(6, 3, NULL, 'cheeses', 14000, 57, 2, '2021-05-12 13:57:31', 20, 1, 1),
(7, 3, NULL, 'cognac', 1800, 19, 1, '2021-05-12 13:59:28', 40, 1, 1),
(8, 3, NULL, 'whiskey', 8000, 42, 1, '2021-05-12 13:59:28', 50, 1, 1);

-- Write test records `partners_modules_descriptions`

INSERT INTO `partners_modules_descriptions` (`module_id`, `name`, `short_text`, `text`) VALUES
(1, 'Модуль «Бакалея»', 'short text', 'long text'),
(2, 'Модуль «Напитки безалкогольные»', 'short text', 'long text'),
(3, 'Модуль «Молочные продукты»', 'short text', 'long text'),
(4, 'Модуль «Алкогольные напитки»', 'short text', 'long text'),
(5, 'Модуль «какой-то 5»', 'short text', 'long text'),
(6, 'Модуль «какой-то 6»', 'short text', 'long text'),
(7, 'Модуль «какой-то 7»', 'short text', 'long text'),
(8, 'Модуль «какой-то 8»', 'short text', 'long text');

-- Write test records `partners_modules_images`

INSERT INTO `partners_modules_images` (`module_id`, `img_name`, `img_mem_type_id`, `img_dir_id`, `alt`, `position`, `status`) VALUES
(1, 'bk', 1, 1, 'text', 1, 1),
(2, 'drna', 1, 2, 'text', 1, 1),
(3, 'ml', 1, 3, 'text', 1, 1),
(4, 'dral', 1, 4, 'text' , 1, 1),
(5, 'dral', 1, 4, 'text' , 1, 1),
(6, 'dral', 1, 2, 'text' , 1, 1),
(7, 'dral', 1, 1, 'text' , 1, 1),
(8, 'dral', 1, 4, 'text' , 1, 1);

-- Write test records `partners_modules_types_descriptions`

INSERT INTO `partners_modules_types_descriptions` (`module_type_id`, `name`, `short_text`, `text`, `status`) VALUES
(1, 'Обязательные модули', 'short text', 'long text', 1),
(2, 'Основные модули', 'short text', 'long text', 1),
(3, 'Дополнительные модули', 'short text', 'long text', 1);

