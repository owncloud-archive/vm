# mysql script for setting database users and permissions
CREATE USER 'oc_admin'@'localhost' IDENTIFIED BY 'owncloud_mysql_admin';
GRANT ALL ON owncloud.* TO 'oc_admin'@'localhost';
FLUSH PRIVILEGES;
