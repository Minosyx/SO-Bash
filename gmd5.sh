#!bin/bash

file="$1"

while read LINE; do
	field=($LINE)
	echo -n "${field[0]} "
	echo -n "${field[1]} "
	echo $(echo -n ${field[1]} | md5sum)
done < $file

