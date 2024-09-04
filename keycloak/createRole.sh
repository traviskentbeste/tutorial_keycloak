#!/bin/sh
#
# Written by Travis Kent Beste

role=$1

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
# remove a role
#--------------------#
echo "remove the role '$role'..."
curl -s \
    -X DELETE \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    http://$hostname/admin/realms/$realm/roles/$role | jq .
echo " "

#--------------------#
# create a role
#--------------------#
echo "create the role '$role'..."
curl -s \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    -d "@role-$role.json" \
    http://$hostname/admin/realms/$realm/roles | jq .
echo " "

#--------------------#
# get the role
#--------------------#
echo "get the role '$role'..."
curl -s \
    -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    http://$hostname/admin/realms/$realm/roles/$role | jq .
echo " "
