#!/bin/bash

ndir=$1
echo "directory name=$ndir"
if [ -d "$ndir" ]
then
	echo "Directory exist"
else
	`mkdir $ndir`
	echo "Directory created"
fi
