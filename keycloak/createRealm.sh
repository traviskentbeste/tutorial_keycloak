#!/bin/bash
#
# Written by Travis Kent Beste

hostname=localhost:8080
admin_username=admin
admin_password=admin
realm=test-app

#--------------------#
# get an access token
#--------------------#
echo "get an access token for curl commands..."
access_token=`curl -s -X POST -d "grant_type=password&client_id=admin-cli&username=$admin_username&password=$admin_password" http://$hostname/realms/master/protocol/openid-connect/token | jq -r .access_token`
echo " "

#--------------------#
# remove the realm
#--------------------#
echo "remove the realm '$realm'..."
curl -s \
	-X "DELETE" \
	-H "Authorization: Bearer $access_token" \
	-H 'Content-Type: application/json' \
	http://$hostname/admin/realms/$realm | jq -r .
echo " "

#--------------------#
# create a realm
#--------------------#
echo "create the realm '$realm'..."
curl -s \
	-X POST \
	-H "Authorization: Bearer $access_token" \
	-H 'Content-Type: application/json' \
	-d "@realm.json" \
	http://$hostname/admin/realms | jq -r .
echo " "

#--------------------#
# create a realm
#--------------------#
echo "get the realm '$realm'..."
curl -s \
	-X GET \
	-H "Authorization: Bearer $access_token" \
	-H 'Content-Type: application/json' \
	http://$hostname/admin/realms/$realm | jq -r .
echo " "
