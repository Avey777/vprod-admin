module db_api

pub const sys_user = r"
REPLACE INTO `sys_user` (`id`, `username`, `password`, `nickname`, `description`, `home_path`, `mobile`, `email`, `avatar`, `is_root`, `status`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
  ('00000000-0000-0000-0000-000000000001', 'admin', '$2a$10${E0E6oRFnroxrPrDkRwA5s.AEiHNThGMdcA4HwPC1CBmP38tCn3De2}', 'administrator', '所有者', '/dashboard', NULL, NULL, '/avatar', 1 , 0, NULL, '2025-07-25 11:11:34', NULL, '2025-07-25 11:11:34', 0, NULL);
"

pub const sys_token = r"
REPLACE INTO `sys_token` (`id`, `user_id`, `username`, `token`, `source`, `expired_at`, `status`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'admin', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IiJ9.eyJpc3MiOiJ2cHJvZC13b3Jrc3Bhc2UiLCJzdWIiOiIwMTk2YjczNi1mODA3LTczZjAtODczMS03YTA4YzBlZDc1ZWEiLCJhdWQiOlsiYXBpLXNlcnZpY2UiLCJ3ZWJhcHAiXSwibmJmIjoxNzQ4OTQ1Mjc4LCJleHAiOjIwMDgxNDUyNzgsImlhdCI6MTc0ODk0NTI3OCwianRpIjoiNTkwN2FmM2EtM2Y1YS00MDg2LWFhZWItNjhlY2EyODNkOGQyIiwicm9sZXMiOlsiYWRtaW4iLCJlZGl0b3IiXSwidGVhbV9pZCI6IiIsImFwcF9pZCI6IiIsInBvcnRhbF9pZCI6IiIsImNsaWVudF9pcCI6IjE5Mi4xNjguMS4xMDAiLCJkZXZpY2VfaWQiOiJkZXZpY2UteHl6In0.6vJKEZi-oKmX0LPx63Y80Fph6MJZnywK2Q98Ioq4clA', 'core_user', '2035-12-31 00:54:47', 1, NULL, '2025-12-31 00:54:47', NULL, '2025-12-31 00:54:47', 0, NULL);
"

pub const sys_department = r"
REPLACE INTO `sys_department` (`id`, `parent_id`, `name`, `leader`, `phone`, `email`, `remark`, `org_type`, `country`, `province_state`, `city`, `district`, `detail_address`, `longitude`, `latitude`, `service_boundary`, `sort`, `status`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'root', NULL, NULL, NULL, 'Root Department ', 0, 'China', 'guangdong', 'shenzhen', NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-08-25 20:58:59', NULL, '2025-08-21 09:53:34', 0, NULL);
"

pub const sys_position = r"
REPLACE INTO `sys_position` (`id`, `name`, `code`, `remark`, `sort`, `status`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
  ('00000000-0000-0000-0000-000000000001', 'root', '0001', 'ROOT', 0, 0, NULL, '2025-09-25 09:56:32', NULL, '2025-09-25 09:56:38', 0, NULL);
"

pub const sys_role = r"
REPLACE INTO `sys_role` (`id`, `name`, `code`, `default_router`, `remark`, `sort`, `data_scope`, `custom_dept_ids`, `status`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
	('00000000-0000-0000-0000-000000000001', 'admin', '001', '/dashboard', NULL, 0, 1, NULL, 0, NULL, '2025-07-25 11:16:05', NULL, '2025-07-25 11:16:00', 0, NULL);
"

pub const sys_role_api = r"
REPLACE INTO `sys_role_api` (`role_id`, `api_id`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001');
"

pub const sys_role_menu = r"
REPLACE INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001');
"

pub const sys_user_role = r"
REPLACE INTO `sys_user_role` (`user_id`, `role_id`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001');
"

pub const sys_user_department = r"
REPLACE INTO `vcore`.`sys_user_department` (`user_id`, `department_id`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001');
"

pub const sys_user_position = r"
REPLACE INTO `sys_user_position` (`user_id`, `position_id`) VALUES
  ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001');
"

// REPLACE INTO `sys_api` VALUES
pub const sys_api = r"
REPLACE INTO `sys_api` (`id`, `path`, `description`, `api_group`, `service_name`, `method`, `is_required`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
  ('00000000-0000-0000-0000-000000000001', '/user/login', 'apiDesc.userLogin', 'user', 'Sys', 'POST', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000002', '/user/register', 'apiDesc.userRegister', 'user', 'Sys', 'POST', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000003', '/user/create', 'apiDesc.createUser', 'user', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000004', '/user/update', 'apiDesc.updateUser', 'user', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000005', '/user/change_password', 'apiDesc.userChangePassword', 'user', 'Sys', 'POST', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000006', '/user/info', 'apiDesc.userInfo', 'user', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000007', '/user/list', 'apiDesc.userList', 'user', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000008', '/user/delete', 'apiDesc.deleteUser', 'user', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000009', '/user/perm', 'apiDesc.userPermissions', 'user', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000010', '/user/profile', 'apiDesc.userProfile', 'user', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000011', '/user/profile', 'apiDesc.updateProfile', 'user', 'Sys', 'POST', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000012', '/user/logout', 'apiDesc.logout', 'user', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000013', '/user', 'apiDesc.getUserById', 'user', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000014', '/user/refresh_token', 'apiDesc.refreshToken', 'user', 'Sys', 'GET', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000015', '/user/access_token', 'apiDesc.accessToken', 'user', 'Sys', 'GET', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000016', '/role/create', 'apiDesc.createRole', 'role', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000017', '/role/update', 'apiDesc.updateRole', 'role', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000018', '/role/delete', 'apiDesc.deleteRole', 'role', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000019', '/role/list', 'apiDesc.roleList', 'role', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000020', '/role', 'apiDesc.getRoleById', 'role', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000021', '/menu/create', 'apiDesc.createMenu', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000022', '/menu/update', 'apiDesc.updateMenu', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000023', '/menu/delete', 'apiDesc.deleteMenu', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000024', '/menu/list', 'apiDesc.menuList', 'menu', 'Sys', 'GET', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000025', '/menu/role/list', 'apiDesc.menuRoleList', 'authority', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000026', '/menu_param/create', 'apiDesc.createMenuParam', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000027', '/menu_param/update', 'apiDesc.updateMenuParam', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000028', '/menu_param/list', 'apiDesc.menuParamListByMenuId', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000029', '/menu_param/delete', 'apiDesc.deleteMenuParam', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000030', '/menu_param', 'apiDesc.getMenuParamById', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000031', '/menu', 'apiDesc.getMenuById', 'menu', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000032', '/captcha', 'apiDesc.captcha', 'captcha', 'Sys', 'GET', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000033', '/authority/api/create_or_update', 'apiDesc.createOrUpdateApiAuthority', 'authority', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000034', '/authority/api/role', 'apiDesc.APIAuthorityOfRole', 'authority', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000035', '/authority/menu/create_or_update', 'apiDesc.createOrUpdateMenuAuthority', 'authority', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000036', '/authority/menu/role', 'apiDesc.menuAuthorityOfRole', 'authority', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000037', '/api/create', 'apiDesc.createApi', 'api', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000038', '/api/update', 'apiDesc.updateApi', 'api', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000039', '/api/delete', 'apiDesc.deleteAPI', 'api', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000040', '/api/list', 'apiDesc.APIList', 'api', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000041', '/api', 'apiDesc.getApiById', 'api', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000042', '/dictionary', 'apiDesc.getDictionaryById', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000043', '/dictionary/create', 'apiDesc.createDictionary', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000044', '/dictionary/update', 'apiDesc.updateDictionary', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000045', '/dictionary/delete', 'apiDesc.deleteDictionary', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000046', '/dictionary_detail/delete', 'apiDesc.deleteDictionaryDetail', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000047', '/dictionary_detail', 'apiDesc.getDictionaryDetailById', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000048', '/dictionary_detail/create', 'apiDesc.createDictionaryDetail', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000049', '/dictionary_detail/update', 'apiDesc.updateDictionaryDetail', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000050', '/dictionary_detail/list', 'apiDesc.getDictionaryListDetail', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000051', '/dictionary/list', 'apiDesc.getDictionaryList', 'dictionary', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000052', '/dict/:name', 'apiDesc.getDictionaryDetailByDictionaryName', 'dictionary', 'Sys', 'GET', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000053', '/oauth_provider/create', 'apiDesc.createProvider', 'oauth', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000054', '/oauth_provider/update', 'apiDesc.updateProvider', 'oauth', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000055', '/oauth_provider/delete', 'apiDesc.deleteProvider', 'oauth', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000056', '/oauth_provider/list', 'apiDesc.getProviderList', 'oauth', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000057', '/oauth/login', 'apiDesc.oauthLogin', 'oauth', 'Sys', 'POST', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000058', '/oauth_provider', 'apiDesc.getProviderById', 'oauth', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000059', '/token/create', 'apiDesc.createToken', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000060', '/token/update', 'apiDesc.updateToken', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000061', '/token/delete', 'apiDesc.deleteToken', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000062', '/token/list', 'apiDesc.getTokenList', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000063', '/token/logout', 'apiDesc.forceLoggingOut', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000064', '/token', 'apiDesc.getTokenById', 'token', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000065', '/department/create', 'apiDesc.createDepartment', 'department', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000066', '/department/update', 'apiDesc.updateDepartment', 'department', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000067', '/department/delete', 'apiDesc.deleteDepartment', 'department', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000068', '/department/list', 'apiDesc.getDepartmentList', 'department', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000069', '/department', 'apiDesc.getDepartmentById', 'department', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000070', '/position/create', 'apiDesc.createPosition', 'position', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000071', '/position/update', 'apiDesc.updatePosition', 'position', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000072', '/position/delete', 'apiDesc.deletePosition', 'position', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000073', '/position/list', 'apiDesc.getPositionList', 'position', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000074', '/position', 'apiDesc.getPositionById', 'position', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000075', '/task/create', 'apiDesc.createTask', 'task', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000076', '/task/update', 'apiDesc.updateTask', 'task', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000077', '/task/delete', 'apiDesc.deleteTask', 'task', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000078', '/task/list', 'apiDesc.getTaskList', 'task', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000079', '/task', 'apiDesc.getTaskById', 'task', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000080', '/task_log/create', 'apiDesc.createTaskLog', 'task_log', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000081', '/task_log/update', 'apiDesc.updateTaskLog', 'task_log', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000082', '/task_log/delete', 'apiDesc.deleteTaskLog', 'task_log', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000083', '/task_log/list', 'apiDesc.getTaskLogList', 'task_log', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000084', '/task_log', 'apiDesc.getTaskLogById', 'task_log', 'Job', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000085', '/configuration/create', 'apiDesc.createConfiguration', 'configuration', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000086', '/configuration/update', 'apiDesc.updateConfiguration', 'configuration', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000087', '/configuration/delete', 'apiDesc.deleteConfiguration', 'configuration', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000088', '/configuration/list', 'apiDesc.getConfigurationList', 'configuration', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000089', '/configuration', 'apiDesc.getConfigurationById', 'configuration', 'Sys', 'POST', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
  ('00000000-0000-0000-0000-000000000090', '/upload', 'apiDesc.uploadFile', 'file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000091', '/file/list', 'apiDesc.fileList', 'file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000092', '/file/update', 'apiDesc.updateFileInfo', 'file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000093', '/file/status', 'apiDesc.setPublicStatus', 'file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000094', '/file/delete', 'apiDesc.deleteFile', 'file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000095', '/file/download/:id', 'apiDesc.downloadFile', 'file', 'Fms', 'GET', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000096', '/file_tag/create', 'apiDesc.createFileTag', 'file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000097', '/file_tag/update', 'apiDesc.updateFileTag', 'file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000098', '/file_tag/delete', 'apiDesc.deleteFileTag', 'file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000099', '/file_tag/list', 'apiDesc.getFileTagList', 'file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000100', '/file_tag', 'apiDesc.getFileTagById', 'file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000101', '/storage_provider/create', 'apiDesc.createStorageProvider', 'storage_provider', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000102', '/storage_provider/update', 'apiDesc.updateStorageProvider', 'storage_provider', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000103', '/storage_provider/delete', 'apiDesc.deleteStorageProvider', 'storage_provider', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000104', '/storage_provider/list', 'apiDesc.getStorageProviderList', 'storage_provider', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000105', '/storage_provider', 'apiDesc.getStorageProviderById', 'storage_provider', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000106', '/cloud_file/create', 'apiDesc.createCloudFile', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000107', '/cloud_file/update', 'apiDesc.updateCloudFile', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000108', '/cloud_file/delete', 'apiDesc.deleteCloudFile', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000109', '/cloud_file/list', 'apiDesc.getCloudFileList', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000110', '/cloud_file', 'apiDesc.getCloudFileById', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000111', '/cloud_file/upload', 'apiDesc.uploadFileToCloud', 'cloud_file', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000112', '/cloud_file_tag/create', 'apiDesc.createCloudFileTag', 'cloud_file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000113', '/cloud_file_tag/update', 'apiDesc.updateCloudFileTag', 'cloud_file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000114', '/cloud_file_tag/delete', 'apiDesc.deleteCloudFileTag', 'cloud_file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000115', '/cloud_file_tag/list', 'apiDesc.getCloudFileTagList', 'cloud_file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000116', '/cloud_file_tag', 'apiDesc.getCloudFileTagById', 'cloud_file_tag', 'Fms', 'POST', 0, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
  ('00000000-0000-0000-0000-000000000117', '/email_log/create', 'apiDesc.createEmailLog', 'email_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:14', NULL, '2024-11-18 00:54:14', 0, NULL),
  ('00000000-0000-0000-0000-000000000118', '/email_log/update', 'apiDesc.updateEmailLog', 'email_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:14', NULL, '2024-11-18 00:54:14', 0, NULL),
  ('00000000-0000-0000-0000-000000000119', '/email_log/delete', 'apiDesc.deleteEmailLog', 'email_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:14', NULL, '2024-11-18 00:54:14', 0, NULL),
  ('00000000-0000-0000-0000-000000000120', '/email_log/list', 'apiDesc.getEmailLogList', 'email_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:14', NULL, '2024-11-18 00:54:14', 0, NULL),
  ('00000000-0000-0000-0000-000000000121', '/email_log', 'apiDesc.getEmailLogById', 'email_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:14', NULL, '2024-11-18 00:54:14', 0, NULL),
  ('00000000-0000-0000-0000-000000000122', '/email_provider/create', 'apiDesc.createEmailProvider', 'email_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000123', '/email_provider/update', 'apiDesc.updateEmailProvider', 'email_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000124', '/email_provider/delete', 'apiDesc.deleteEmailProvider', 'email_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000125', '/email_provider/list', 'apiDesc.getEmailProviderList', 'email_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000126', '/email_provider', 'apiDesc.getEmailProviderById', 'email_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000127', '/sms_log/create', 'apiDesc.createSmsLog', 'sms_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000128', '/sms_log/update', 'apiDesc.updateSmsLog', 'sms_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000129', '/sms_log/delete', 'apiDesc.deleteSmsLog', 'sms_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000130', '/sms_log/list', 'apiDesc.getSmsLogList', 'sms_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000131', '/sms_log', 'apiDesc.getSmsLogById', 'sms_log', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000132', '/sms_provider/create', 'apiDesc.createSmsProvider', 'sms_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000133', '/sms_provider/update', 'apiDesc.updateSmsProvider', 'sms_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000134', '/sms_provider/delete', 'apiDesc.deleteSmsProvider', 'sms_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000135', '/sms_provider/list', 'apiDesc.getSmsProviderList', 'sms_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000136', '/sms_provider', 'apiDesc.getSmsProviderById', 'sms_provider', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000137', '/sms/send', 'apiDesc.sendSms', 'message_sender', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
  ('00000000-0000-0000-0000-000000000138', '/email/send', 'apiDesc.sendEmail', 'message_sender', 'Mcms', 'POST', 0, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL);
"

pub const sys_menu = r"
REPLACE INTO `sys_menu` (`id`, `parent_id`, `menu_level`, `menu_type`, `path`, `name`, `redirect`, `component`, `disabled`, `service_name`, `permission`, `title`, `icon`, `hide_menu`, `hide_breadcrumb`, `ignore_keep_alive`, `hide_tab`, `frame_src`, `carry_param`, `hide_children_in_menu`, `affix`, `dynamic_level`, `real_path`, `sort`, `updater_id`, `updated_at`, `creator_id`, `created_at`, `del_flag`, `deleted_at`) VALUES
 ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 1, 1, '/dashboard', 'Dashboard', '', '/dashboard/workbench/index', 0, 'Core', NULL, 'route.dashboard', 'ant-design:home-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 0, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 1, 0, '/system', 'SystemManagement', '', 'LAYOUT', 0, 'Core', NULL, 'route.systemManagementTitle', 'ant-design:tool-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 999, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', 2, 1, '/menu', 'MenuManagement', '', '/sys/menu/index', 0, 'Core', NULL, 'route.menuManagementTitle', 'ant-design:bars-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000002', 2, 1, '/role', 'RoleManagement', '', '/sys/role/index', 0, 'Core', NULL, 'route.roleManagementTitle', 'ant-design:user-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 2, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000002', 2, 1, '/user', 'UserManagement', '', '/sys/user/index', 0, 'Core', NULL, 'route.userManagementTitle', 'ant-design:user-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 3, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', 2, 1, '/department', 'DepartmentManagement', '', '/sys/department/index', 0, 'Core', NULL, 'route.departmentManagement', 'ic:outline-people-alt', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 4, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000002', 2, 1, '/api', 'APIManagement', '', '/sys/api/index', 0, 'Core', NULL, 'route.apiManagementTitle', 'ant-design:api-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 5, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000002', 2, 1, '/dictionary', 'DictionaryManagement', '', '/sys/dictionary/index', 0, 'Core', NULL, 'route.dictionaryManagementTitle', 'ant-design:book-outlined', 0, 0, 0, 0, '', 0, 1, 0, 20, '', 6, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000001', 1, 0, '/other', 'OtherPages', '', 'LAYOUT', 0, 'Core', NULL, 'route.otherPages', 'ant-design:question-circle-outlined', 1, 0, 0, 0, '', 0, 0, 0, 20, '', 1000, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000008', 2, 1, '/dictionary/detail/:dictionaryId', 'DictionaryDetail', '', '/sys/dictionaryDetail/index', 0, 'Core', NULL, 'route.dictionaryDetailManagementTitle', 'ant-design:align-left-outlined', 1, 0, 0, 0, '', 0, 0, 0, 20, '', 1, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000009', 1, 1, '/profile', 'Profile', '', '/sys/profile/index', 0, 'Core', NULL, 'route.userProfileTitle', 'ant-design:profile-outlined', 1, 0, 0, 0, '', 0, 0, 0, 20, '', 3, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000002', 2, 1, '/oauth', 'OauthManagement', '', '/sys/oauth/index', 0, 'Core', NULL, 'route.oauthManagement', 'ant-design:unlock-filled', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 6, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000002', 2, 1, '/token', 'TokenManagement', '', '/sys/token/index', 0, 'Core', NULL, 'route.tokenManagement', 'ant-design:lock-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 7, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000002', 2, 1, '/position', 'PositionManagement', '', '/sys/position/index', 0, 'Core', NULL, 'route.positionManagement', 'ic:twotone-work-outline', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 8, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000001', 2, 1, '/task', 'TaskManagement', '', '/sys/task/index', 0, 'Job', NULL, 'route.taskManagement', 'ic:baseline-access-alarm', 1, 0, 0, 0, '', 0, 0, 0, 20, '', 8, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000002', 2, 1, '/configuration', 'ConfigurationManagement', '', '/sys/configuration/index', 0, 'Core', NULL, 'route.configurationManagement', 'carbon:data-2', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 9, NULL, '2024-11-18 00:54:02', NULL, '2024-11-18 00:54:02', 0, NULL),
 ('00000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000001', 1, 1, '/fms_dir', 'FileManagementDirectory', '', 'LAYOUT', 0, 'Fms', NULL, 'route.fileManagement', 'ant-design:folder-open-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 3, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000017', 2, 1, '/fms/file', 'FileManagement', '', '/fms/file/index', 0, 'Fms', NULL, 'route.fileManagement', 'ant-design:folder-open-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 1, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000017', 2, 1, '/fms/file_tag', 'FileTagManagement', '', '/fms/fileTag/index', 0, 'Fms', NULL, 'route.fileTagManagement', 'ant-design:book-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 2, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000017', 2, 1, '/fms/storage_provider', 'StorageProviderManagement', '', '/fms/storageProvider/index', 0, 'Fms', NULL, 'route.storageProviderManagement', 'mdi:cloud-outline', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 3, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000017', 2, 1, '/fms/cloud_file', 'CloudFileManagement', '', '/fms/cloudFile/index', 0, 'Fms', NULL, 'route.cloudFileManagement', 'ant-design:folder-open-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 4, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000017', 2, 1, '/fms/cloud_file_tag', 'CloudFileTagManagement', '', '/fms/cloudFileTag/index', 0, 'Fms', NULL, 'route.cloudFileTagManagement', 'ant-design:book-outlined', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 5, NULL, '2024-11-18 00:54:06', NULL, '2024-11-18 00:54:06', 0, NULL),
 ('00000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000001', 1, 1, '/mcms_dir', 'MessageCenterManagement', '', 'LAYOUT', 0, 'Mcms', NULL, 'route.messageCenterManagement', 'clarity:email-line', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 4, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
 ('00000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000023', 2, 2, '/mcms_email_provider', 'EmailProviderManagement', '', '/mcms/emailProvider/index', 0, 'Mcms', NULL, 'route.emailProviderManagement', 'clarity:email-line', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 1, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL),
 ('00000000-0000-0000-0000-000000000025', '00000000-0000-0000-0000-000000000023', 2, 2, '/mcms_sms_provider', 'SmsProviderManagement', '', '/mcms/smsProvider/index', 0, 'Mcms', NULL, 'route.smsProviderManagement', 'clarity:mobile-line', 0, 0, 0, 0, '', 0, 0, 0, 20, '', 2, NULL, '2024-11-18 00:54:15', NULL, '2024-11-18 00:54:15', 0, NULL);
"
