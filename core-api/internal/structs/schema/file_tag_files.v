module schema

// 文件与标签关联表
@[table: 'file_tag_files']
pub struct FileTagFile {
pub:
	file_tag_id string @[primary; sql: 'file_tag_id'; sql_type: 'CHAR(36)'; zcomments: '标签ID']
	file_id     string @[primary; sql: 'file_id'; sql_type: 'CHAR(36)'; zcomments: '文件UUID']
}
