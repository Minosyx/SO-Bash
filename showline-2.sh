#!/bin/bash

while getopts ":r" opt; do
	case ${opt} in
		r )	optR="yes" ;;
		\? ) exit 1 ;;
	esac
done
shift "$((OPTIND-1))" 

file="$1"
shift
nlines=$(wc -l "$file" | cut -f1 -d' ')
if [[ $optR == "yes" ]]; then
	licznik=1
	for arg in "$@"; do
		((licznik++))
		if [[ $arg -le 0 || $arg -gt $nlines ]]; then
			echo "niepoprawny argument: \$$licznik=$arg"
		else
			line=$((nlines - arg + 1))
			gawk -v num="$line" '{ if(NR == num) print $0 }' "$file"
		fi
	done
else
	licznik=1
	for arg in "$@"; do
		((licznik++))
		if [[ $arg -le 0 || $arg -gt $nlines ]]; then
			echo "niepoprawny argument: \$$licznik=$arg"
		else
			gawk -v num="$arg" '{ if(NR == num) print $0 }' "$file"
		fi
	done
fi
