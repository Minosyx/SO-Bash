#!/bin/bash

echo "lucky number=$1"

if [ $1 -eq 101 ];
then
	echo "You got 1st prize"
elif [ $1 -eq 510 ];
then
	echo "You got 2nd prize"
elif [ $1 -eq 999 ];
then
	echo "You got 3rd prize"
else
	echo "Sorry, try for the next time"
fi
