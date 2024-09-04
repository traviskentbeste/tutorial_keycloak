#!/bin/sh
#
# Written by Travis Kent Beste

user=$1

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
# get the user
#--------------------#
echo "get the user '$user'..."
email=`cat ../json/user-$user.json | jq -r .email`
userId=`curl -s -X GET -H "Content-Type: application/json" -H "Authorization: bearer $access_token" http://$hostname/admin/realms/$realm/users?email=$email | jq -r .[0].id`
if [ $userId == "null" ]; then
    userId=""
fi
echo " "

#--------------------#
# delete the user
#--------------------#
if [ ! -z $userId ]; then
    echo "delete the user '$user'..."
    curl -s \
        -X DELETE \
        -H "Content-Type: application/json" \
        -H "Authorization: bearer $access_token" \
        http://$hostname/admin/realms/$realm/users/$userId | jq .
    echo " "
fi

#--------------------#
# create the user
#--------------------#
echo "create the user '$user'..."
curl -s \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    -d "@../json/user-$user.json" \
    http://$hostname/admin/realms/$realm/users | jq .
echo " "

#--------------------#
# get the user
#--------------------#
email=`cat ../json/user-$user.json | jq -r .email`
userId=`curl -s -X GET -H "Content-Type: application/json" -H "Authorization: bearer $access_token" http://$hostname/admin/realms/$realm/users?email=$email | jq -r .[0].id`
echo " "

#--------------------#
# add roles to user
#--------------------#
role=user
roleId=`curl -s -X GET -H "Content-Type: application/json" -H "Authorization: bearer $access_token" http://$hostname/admin/realms/$realm/roles/$role | jq -r .id`
curl -s \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $access_token" \
    -d "[{\"id\":\"$roleId\",\"name\":\"$role\",\"description\":\"my description\"}]" \
    http://$hostname/admin/realms/$realm/users/$userId/role-mappings/realm | jq .

if [ $user == "user2" ]; then
    role=admin
    roleId=`curl -s -X GET -H "Content-Type: application/json" -H "Authorization: bearer $access_token" http://$hostname/admin/realms/$realm/roles/$role | jq -r .id`
    curl -s \
        -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: bearer $access_token" \
        -d "[{\"id\":\"$roleId\",\"name\":\"$role\",\"description\":\"my description\"}]" \
        http://$hostname/admin/realms/$realm/users/$userId/role-mappings/realm | jq .
fi

#--------------------#
# get the user
#--------------------#
email=`cat ../json/user-$user.json | jq -r .email`
curl -s -X GET -H "Content-Type: application/json" -H "Authorization: bearer $access_token" http://$hostname/admin/realms/$realm/users?email=$email | jq -r .[0]
echo " "