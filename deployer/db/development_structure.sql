CREATE TABLE `accesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accessor_id` int(10) NOT NULL,
  `accessor_type` varchar(100) NOT NULL DEFAULT '',
  `accessable_id` int(10) NOT NULL,
  `accessable_type` varchar(100) NOT NULL DEFAULT '',
  `permission_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_accesses_on_accessable_id_and_accessable_type` (`accessable_id`,`accessable_type`),
  KEY `index_accesses_on_accessor_id_and_accessor_type` (`accessor_id`,`accessor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `account_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(10) NOT NULL,
  `group_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_groups_index` (`account_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `name` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_accounts_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `short_name` varchar(10) NOT NULL DEFAULT '',
  `desc` varchar(200) NOT NULL DEFAULT '',
  `project_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_applications_on_short_name` (`short_name`),
  KEY `index_applications_on_project_id` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `short_name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_clients_on_name` (`name`),
  UNIQUE KEY `index_clients_on_short_name` (`short_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `deploy_processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deploy_id` int(10) NOT NULL,
  `environment_id` int(10) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `deploy_environment` (`deploy_id`),
  UNIQUE KEY `unique_environment` (`environment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

CREATE TABLE `deploys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deployed_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_running` tinyint(1) NOT NULL,
  `is_success` tinyint(1) NOT NULL,
  `environment_id` int(10) NOT NULL,
  `log_file` varchar(200) NOT NULL DEFAULT '',
  `completed_at` datetime DEFAULT NULL,
  `version` varchar(200) DEFAULT '',
  `note` text,
  `path` varchar(255) DEFAULT NULL,
  `deployed_by_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_deploys_on_log_file` (`log_file`),
  KEY `index_deploys_on_environment_id` (`environment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;

CREATE TABLE `environment_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `environment_id` int(10) NOT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_environment_parameters_on_environment_id` (`environment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

CREATE TABLE `environments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `deployment_mode` varchar(100) NOT NULL DEFAULT '',
  `desc` varchar(200) NOT NULL DEFAULT '',
  `is_production` tinyint(1) NOT NULL DEFAULT '0',
  `app_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_environments_on_name_and_id` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `desc` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `short_name` varchar(10) NOT NULL DEFAULT '',
  `desc` varchar(200) NOT NULL DEFAULT '',
  `client_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_projects_on_name` (`name`),
  KEY `index_projects_on_client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20080805143601');

INSERT INTO schema_migrations (version) VALUES ('20080805143624');

INSERT INTO schema_migrations (version) VALUES ('20080851143649');

INSERT INTO schema_migrations (version) VALUES ('20100102030639');

INSERT INTO schema_migrations (version) VALUES ('20100626011105');

INSERT INTO schema_migrations (version) VALUES ('20100705153856');