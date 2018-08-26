<?php
define('DB_NAME', '{{wordpress_db_name}}');
define('DB_USER', '{{wordpress_db_user}}');
define('DB_PASSWORD', '{{wordpress_db_user_password}}');
define('DB_HOST', '{{wordpress_db_host}}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         '{{wordpress_db_auth_key}}');
define('SECURE_AUTH_KEY',  '{{wordpress_db_secure_auth_key}}');
define('LOGGED_IN_KEY',    '{{wordpress_db_logged_in_key}}');
define('NONCE_KEY',        '{{wordpress_db_nonce_key}}');
define('AUTH_SALT',        '{{wordpress_db_auth_salt}}');
define('SECURE_AUTH_SALT', '{{wordpress_db_secure_auth_salt}}');
define('LOGGED_IN_SALT',   '{{wordpress_db_logged_in_salt}}');
define('NONCE_SALT',       '{{wordpress_db_nonce_salt}}');
$table_prefix  = '{{wordpress_db_prefix}}';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
