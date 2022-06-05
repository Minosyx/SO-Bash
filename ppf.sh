#!/bin/bash

num=3

while getopts "c:" opt; do
	case ${opt} in
		c) num=${OPTARG}
		;;
		\?) exit 1
		;;
	esac
done

shift $((OPTIND-1))

# jk: 
#
# Jaki podstawowy błąd Pan popełnił, który spowodował, że niepotrzebnie
# komplikował Pan rozw. zadania? Dlaczego poniższy kod działa?

# Dlaczego nie działa instrukcja
#   i=$((i++))


i=0
for file in "$@";do
    printf "%s " "$file"
    let i++
    if [[ $i == $num ]]; then
	printf "\n"
	i=0
    fi
done
printf "\n"
exit


if [[ "$1" == "*" ]]; then
	pl=""
	dir="yes"
elif [[ "$2" == "" ]]; then
	dir="yes"
	pl="$(sed 's/\/\*//')"
fi
if [[ $dir != "yes" ]]; then
	dir="no"
	args=("$@")
fi

if [[ $num == "" ]]; then
	num=3
fi

if [[ $dir == "yes" ]]; then
	i=0
	args=($(ls -l "$pl" | awk -v FS=" " OFS=" " '{ print NF }' ))
	for file in "${args[@]}";do
	    printf "%s " "$file"
	    i=$((i++))
	    if [[ $i == $num ]]; then
		printf "\n"
		i=0
	    fi
	done
fi


if [[ $dir == "no" ]]; then
	while [[ $i < "$#" ]]; do	
		it=0
		while [[ $it < "$num" ]]; do
			printf "%5s " "${args[$i]}"
			((it++))	
			((i++))
		done
		printf "\n" 
	done
fi
