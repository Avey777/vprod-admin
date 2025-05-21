module fms

// 云文件与标签关联表
@[table: 'fms_cloudfile_join_cloudtag']
pub struct FmsCloudFileCloudFileTag {
pub:
	cloud_file_tag_id string @[primary; sql: 'cloud_file_tag_id'; sql_type: 'CHAR(36)'; zcomments: '云文件标签ID']
	cloud_file_id     string @[primary; sql: 'cloud_file_id'; sql_type: 'CHAR(36)'; zcomments: '云文件UUID']
}
