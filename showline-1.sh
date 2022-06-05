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
if [[ $optR == "yes" ]]; then
	for arg in "$@"; do
		tail -n $arg "$file" | head -1
	done
else
	for arg in "$@"; do
		head -n $arg "$file" | tail -1
	done
fi
