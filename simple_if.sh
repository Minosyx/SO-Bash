#!/bin/bash
if [[ -z "$1" ]];
then
	echo "Number is missing"
elif [[ "$1" -ge "10" ]];
then
	echo "It is a two digit number"
elif [[ "$1" -lt "10" ]];
then
	echo "It is a one digit number"
fi
