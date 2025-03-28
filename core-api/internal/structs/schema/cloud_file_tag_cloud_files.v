CREATE TABLE `cloud_file_tag_cloud_files` (
  `cloud_file_tag_id` bigint unsigned NOT NULL,
  `cloud_file_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`cloud_file_tag_id`,`cloud_file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
