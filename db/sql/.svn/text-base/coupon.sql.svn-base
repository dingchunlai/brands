/*
MySQL Data Transfer
Source Host: 192.168.0.2
Source Database: product
Target Host: 192.168.0.2
Target Database: product
Date: 2010-11-18 15:24:34
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for brands_production_categories
-- ----------------------------
CREATE TABLE `brands_production_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_id` int(11) DEFAULT NULL,
  `production_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_brands_production_categories_on_production_category_id` (`production_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_zones
-- ----------------------------
CREATE TABLE `business_zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `pinyin` varchar(100) NOT NULL,
  `code_name` varchar(30) NOT NULL,
  `city_id` int(11) DEFAULT '0',
  `district_id` int(11) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_business_zones_on_district_id_and_city_id` (`district_id`,`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cities
-- ----------------------------
CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(8) NOT NULL,
  `pinyin` varchar(50) NOT NULL,
  `code_name` varchar(30) NOT NULL,
  `districts_count` int(11) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cities_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for complaints
-- ----------------------------
CREATE TABLE `complaints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `coupon_code` varchar(50) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `telphone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(150) DEFAULT NULL,
  `body` text,
  `description` varchar(200) DEFAULT NULL,
  `is_valid` tinyint(1) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_complaints_on_coupon_id` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupon_downloads
-- ----------------------------
CREATE TABLE `coupon_downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) NOT NULL DEFAULT '0',
  `mobile` varchar(11) NOT NULL,
  `is_confirm` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupon_faqs
-- ----------------------------
CREATE TABLE `coupon_faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `answer` varchar(500) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `faq_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_coupon_faqs_on_faq_group_id` (`faq_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupon_recommendations
-- ----------------------------
CREATE TABLE `coupon_recommendations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupon_subscribes
-- ----------------------------
CREATE TABLE `coupon_subscribes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `city_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `email` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupons
-- ----------------------------
CREATE TABLE `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `discount_amount` int(11) DEFAULT NULL,
  `return_amount` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `contract_id` int(11) DEFAULT NULL,
  `pv` int(11) DEFAULT '0',
  `prints_count` int(11) DEFAULT '0',
  `downloads_count` int(11) DEFAULT '0',
  `sms_msg` varchar(150) DEFAULT NULL,
  `activity_began_at` datetime DEFAULT NULL,
  `activity_end_at` datetime DEFAULT NULL,
  `usage` varchar(400) DEFAULT NULL,
  `offline_event` tinyint(1) DEFAULT '0',
  `offline_address` varchar(100) DEFAULT NULL,
  `offline_out_count` int(11) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `remarks_count` int(11) DEFAULT '0',
  `seo_keywords` varchar(150) DEFAULT NULL,
  `seo_description` varchar(255) DEFAULT NULL,
  `seo_title` varchar(150) DEFAULT NULL,
  `sort` int(11) DEFAULT '0',
  `complaints_count` int(11) DEFAULT '0',
  `is_hidden` tinyint(1) DEFAULT '0',
  `penalty_deadline` datetime DEFAULT NULL,
  `print_image_url` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `image_url` varchar(200) DEFAULT NULL,
  `tag_id` int(11) DEFAULT '0',
  `brand_id` int(11) DEFAULT '0',
  `production_category_id` int(11) DEFAULT '0',
  `print_generated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_coupons_on_shop_id` (`shop_id`),
  KEY `index_coupons_on_distributor_id` (`distributor_id`),
  KEY `index_coupons_on_activity_end_at_and_activity_began_at` (`activity_end_at`,`activity_began_at`),
  KEY `index_coupons_on_tag_id_and_brand_id_and_production_category_id` (`tag_id`,`brand_id`,`production_category_id`),
  KEY `index_coupons_on_production_category_id` (`production_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for distributor_account_profiles
-- ----------------------------
CREATE TABLE `distributor_account_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_id` int(11) DEFAULT NULL,
  `distributor_account_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for distributor_contracts
-- ----------------------------
CREATE TABLE `distributor_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `radmin_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_distributor_contracts_on_code` (`code`),
  KEY `index_distributor_contracts_on_distributor_id` (`distributor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for distributor_shops
-- ----------------------------
CREATE TABLE `distributor_shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `business_zone_id` int(11) DEFAULT NULL,
  `market_shop_id` int(11) DEFAULT NULL,
  `linkman` varchar(30) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `telphone` varchar(50) DEFAULT NULL,
  `latitude` int(11) DEFAULT NULL,
  `longitude` int(11) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_distributor_shops_on_city_id` (`city_id`),
  KEY `index_distributor_shops_on_market_shop_id` (`market_shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for distributors
-- ----------------------------
CREATE TABLE `distributors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `short_title` varchar(20) NOT NULL,
  `code` varchar(15) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `complaints_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `coupons_count` int(11) DEFAULT '0',
  `shops_count` int(11) DEFAULT '0',
  `contracts_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_distributors_on_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for districts
-- ----------------------------
CREATE TABLE `districts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(8) NOT NULL,
  `pinyin` varchar(50) NOT NULL,
  `code_name` varchar(30) NOT NULL,
  `city_id` int(11) DEFAULT '0',
  `business_zones_count` int(11) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_districts_on_city_id` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for faq_groups
-- ----------------------------
CREATE TABLE `faq_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for offer_coupons
-- ----------------------------
CREATE TABLE `offer_coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merchant` varchar(50) NOT NULL,
  `body` text NOT NULL,
  `city_id` int(11) DEFAULT '0',
  `district_id` int(11) DEFAULT '0',
  `linkman` varchar(30) NOT NULL,
  `telphone` varchar(30) NOT NULL,
  `sex` tinyint(1) DEFAULT '1',
  `status` int(11) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_offer_coupons_on_city_id_and_district_id` (`city_id`,`district_id`),
  KEY `index_offer_coupons_on_merchant` (`merchant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for offline_addresses
-- ----------------------------
CREATE TABLE `offline_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `city_id` int(11) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for print_records
-- ----------------------------
CREATE TABLE `print_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `month` datetime DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for privilege_actions
-- ----------------------------
CREATE TABLE `privilege_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) DEFAULT NULL,
  `action_chinese` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `model_chinese` varchar(255) DEFAULT NULL,
  `controller` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for role_abilities
-- ----------------------------
CREATE TABLE `role_abilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `operation` int(11) DEFAULT NULL,
  `object` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tag_amounts
-- ----------------------------
CREATE TABLE `tag_amounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `print_record_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tag_amounts_on_print_record_id` (`print_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table brand_details add print_image_url varchar(255);
alter table production_categories add tag_id integer;



-- ----------------------------
-- 后期添加的新表
-- ----------------------------

-- ----------------------------
-- Table structure for sales_profiles 
-- ----------------------------
CREATE TABLE `sales_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `qq` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `mobile` varchar(11) DEFAULT NULL,
  `telephone` varchar(18) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sales_profiles_on_user_id` (`user_id`)
  KEY `index_sales_profiles_on_manager_id` (`manager_id`)
  KEY `index_sales_profiles_on_city_id` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for coupons_productioon_categories 
-- ----------------------------
CREATE TABLE `coupons_production_categories` (
    `coupon_id` int(11) DEFAULT NULL,
    `production_category_id` int(11) DEFAULT NULL
) ENGINE=InnerDB DEFAULT CHARSET=utf8;

CREATE TABLE `provinces` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(8) NOT NULL,
      `pinyin` varchar(50) NOT NULL,
      `code_name` varchar(30) NOT NULL,
      `cities_count` int(11) DEFAULT '0',
      `deleted` tinyint(1) DEFAULT '0',
      `created_at` datetime DEFAULT NULL,
      `updated_at` datetime DEFAULT NULL,
      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

ALTER TABLE HEJIA_TAG ADD code varchar(3);
ALTER TABLE City ADD province_id integer;
ALTER TABLE coupons DROP production_category_id;
ALTER TABLE distributor_shops ADD googlemap_image_url varchar(100);
ALTER TABLE production_categories ADD short_name varchar(50);


-- ----------------------------
-- 2010-11-29 日添加 
-- Table structure for coupons_print_records  
-- ----------------------------
CREATE TABLE `coupons_print_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `print_record_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_coupons_print_records_on_coupon_id` (`coupon_id`),
  KEY `index_coupons_print_records_on_print_record_id` (`print_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE coupons  MODIFY COLUMN activity_began_at date;
ALTER TABLE coupons  MODIFY COLUMN activity_end_at date;
ALTER TABLE distributor_contracts  MODIFY COLUMN start_date date;
ALTER TABLE distributor_contracts  MODIFY COLUMN end_date date;
ALTER TABLE print_records  MODIFY COLUMN month date;
ALTER TABLE print_records ADD archive_path varchar(100);

#/* ================================== *\
#   Author      chenxiang
#   Date        2011-1-11
#   Desc        经销商添加标签, 抵用券添加当月佣金, 创建按月抵用券佣金-抵用券关系
#\* ================================== */

use product;
# PM issue 517
ALTER TABLE `coupons` ADD `commission` INT(11) DEFAULT '0';

CREATE INDEX `index_coupons_on_commission` ON `coupons` (`commission`);

CREATE TABLE `coupon_commissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `commission` int(11) DEFAULT '0',
  `activity_in` date DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_coupon_commissions_on_coupon_id_and_activity_in` (`coupon_id`, `activity_in`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# PM issue 515
ALTER TABLE `distributors` ADD `tag` VARCHAR(10);
ALTER TABLE `distributors` ADD `class_name` VARCHAR(50);


/* ================================== *\
#   Author      U 
#   Date        2011-1-24
#   Desc        关于商户添加字段 
#\* ================================== */
ALTER TABLE `distributors` ADD `pv` INT(11) DEFAULT 0;
ALTER TABLE `distributors` ADD `description` VARCHAR(5000);
ALTER TABLE `distributors` ADD `logo` VARCHAR(100);



#/* ================================== *\
#   Author      chenxiang
#   Date        2011-1-25
#   Desc        抵用券线下发放点维护
#\* ================================== */

# PM issue 602
CREATE TABLE `coupon_leaflet_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `shop_name` varchar(255) DEFAULT NULL,
  `linkman` varchar(255) DEFAULT NULL,
  `city_id` int(11) NOT NULL,
  `district_id` int(11) NOT NULL,
  `activity_begin_at` date DEFAULT NULL,
  `activity_end_at` date DEFAULT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*====================================*\
# DATE 2011-02-16
# DESC 添加
# 1 总发行量
# 2 现有数量
# 3 品牌和行业合成名称 
#\*===================================*/
ALTER TABLE `coupons` ADD `total_issue_number` INT(11) DEFAULT '0';
ALTER TABLE `coupons` ADD `existing_number` INT(11) DEFAULT '0';
ALTER TABLE `coupons` ADD `brand_industry_name` VARCHAR(50);

ALTER TABLE `coupons` ADD `virtual_existing_number` INT(11) DEFAULT '0';
ALTER TABLE `coupons` ADD `difference_value` INT(11) DEFAULT '0';


#/* ================================== *\
#   Author      chenxiang
#   Date        2011-3-24
#   Desc        经销商后台登录
#\* ================================== */

CREATE TABLE `app_resource_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_type` varchar(255) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `channel` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_app_resource_settings_on_resource_id` (`resource_id`),
  KEY `index_app_resource_settings_on_key_and_value` (`key`,`value`) ) ENGINE=innodb DEFAULT CHARSET=utf8;

CREATE TABLE `distributor_account_industry_brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `industry_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `distributor_account_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`), KEY `index_daibs_on_tid_and_bid_and_daid`  (`industry_id`,`brand_id`,`distributor_account_id`), KEY `index_daibs_on_distributor_account_id` (`distributor_account_id`)
) ENGINE=innodb DEFAULT CHARSET=utf8;


#/* ================================== *\
#   Author      chenxiang
#   Date        2011-3-24
#   Desc        经销商会员--建材公司图片管理
#\* ================================== */

CREATE TABLE `distributor_picture_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_id` int(11) DEFAULT NULL,
  `class_name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_distributor_picture_types_on_did_cname` (`distributor_id`,`class_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `distributor_upload_pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_type` varchar(50) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `approval_status` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


#/* ================================== *\
#   Author      chenxiang
#   Date        2011-5-24
#\* ================================== */
# 经销商添加QQ
ALTER TABLE `distributors` ADD `qq` varchar(30) DEFAULT NULL;
# 图片添加描述说明
ALTER TABLE `distributor_upload_pictures` ADD `summary` varchar(255) DEFAULT NULL;

CREATE TABLE `vip_distributor_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `default_image_id` int(11) DEFAULT NULL,
  `begin_at` date DEFAULT NULL,
  `end_at` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
KEY `index_vdactvities_on_distributorid_and_defautimgid`  (`distributor_id`,`default_image_id`)

) ENGINE=INNODB DEFAULT CHARSET=utf8;


CREATE TABLE `vip_distributor_cases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_id` int(11) DEFAULT NULL,
  `default_image_id` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
,
KEY `index_vdcases_on_distributorid_and_defautimgid`  (`distributor_id`,`default_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
