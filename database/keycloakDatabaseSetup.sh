#!/bin/bash
#
# Written by Travis Kent Beste

action=$1

# mysql
mysql_command="mysql"
mysql_username="root"
mysql_password="mysql"

# keycloak
keycloak_username="keycloak"
keycloak_password="keycloak"
keycloak_database="keycloak"
keycloak_hostname="%"

if [[ $action == "remove" ]]; then

        echo "removing..."
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "drop database if exists ${keycloak_database}"
        ${mysql_command} -u ${mysql_username} -p${mysql_password} mysql -e "delete from user where User='${keycloak_username}'"

        echo "flushing credentials..."
        ${mysql_command} -u ${username} -p${password} -e "FLUSH PRIVILEGES"

elif [[ $action == "install" ]]; then

        echo "installing..."
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "create database ${keycloak_database}"
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "ALTER DATABASE ${keycloak_database} CHARACTER SET utf8 COLLATE utf8_general_ci"
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "CREATE USER '${keycloak_username}'@'${keycloak_hostname}' IDENTIFIED by '${keycloak_password}'"
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "GRANT ALL ON *.* TO '${keycloak_username}'@'${keycloak_hostname}'"

        echo "flushing credentials..."
        ${mysql_command} -u ${mysql_username} -p${mysql_password} -e "FLUSH PRIVILEGES"

fi

