#!/bin/bash

username=${1-admin}
password=${2-secret}
echo "username : $username"
echo "password : $password"

if [[ ( $username == "admin" && $password == "secret" ) ]]; then
	echo "valid user and password"
else
	echo "invalid user or password"
fi
