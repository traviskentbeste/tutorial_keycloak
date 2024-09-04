#!/bin/sh
#
# Written by Travis Kent Beste

client=$1

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
# delete the client
#--------------------#
echo "delete the client '$client'..."
curl -s \
    -X "DELETE" \
    -H "Authorization: Bearer $access_token" \
    -H 'Content-Type: application/json' \
    http://$hostname/admin/realms/$realm/clients/$client | jq -r .
echo " "

#--------------------#
# create a client
#--------------------#
echo "create the client '$client'..."
curl -s \
    -X "POST" \
    -H "Authorization: Bearer $access_token" \
    -H 'Content-Type: application/json' \
    -d "@client-${client}.json" \
    http://$hostname/admin/realms/$realm/clients | jq -r .
echo " "

#--------------------#
# get client
#--------------------#
echo "get the client '$client'..."
curl -s \
    -X "GET" \
    -H "Authorization: Bearer $access_token" \
    -H 'Content-Type: application/json' \
    http://$hostname/admin/realms/$realm/clients/$client | jq -r .
echo " "
