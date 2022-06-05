#!/bin/bash

for var in "$@"
do
	if [[ "$1" == "-c" ]]; then
		if [[ "$var" == "-c" ]]; then
			continue
		fi
		echo "${var,,}=$(printenv $var)"
	else
		echo "$var=$(printenv $var)"
	fi
done
