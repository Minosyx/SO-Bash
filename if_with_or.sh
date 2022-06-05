#!/bin/bash

echo "number=$1"

if [[ ( $1 -eq 15 || $1 -eq 45 ) ]]
then
	echo "You won the game"
else
	echo "You lost the game"
fi
