#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Uzycie: $(basename $0) user"
else
	numbers=($(id -G "$1"))
	names=($(id -Gn "$1"))
	range=${#numbers[@]}
	((range--))
	for i in $(seq 0 $range); do
		printf "%-10d"  "${numbers[$i]}"
		printf "%s" "${names[$i]}"
		printf "\n"
	done
fi
