#!/bin/bash

# jk nieco uproszczony kod
# [[ "$1" == "-n" ]] && printenv | wc -l && exit

# optC=
# [[ $1 == "-c" ]] && optC=yes && shift
# for var in "$@"
# do
#     if [[ $optC == yes ]]; then
# 	env=$(printenv $var)
# 	[[ -n "$env" ]] && echo "${var,,}=$env"
#      else 
# 	env=$(printenv $var)
# 	[[ -n "$env" ]] && echo "$var=$env"
#     fi
# done

if [[ "$1" == "-n" ]]; then
	printenv | wc -l
else
	for var in "$@"
	do
		if [[ "$1" == "-c" && "$var" != "-c" ]]; then
			env=$(printenv $var)
			if [[ ! -z "$env" ]]; then
				echo "${var,,}=$env"
			fi
		elif [[ "$1" != "-c" ]]; then
			env=$(printenv $var)
			if [[ ! -z "$env" ]]; then
				echo "$var=$env"
			fi
		fi
	done
fi
