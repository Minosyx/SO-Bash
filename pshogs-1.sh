#!/bin/bash

export LC_ALL=en_US.UTF-8

file=""
n=3

while getopts "n:f:" opt; do
	case ${opt} in
		f ) file=${OPTARG} ;;
		n ) n=${OPTARG} ;;
		\? ) exit 1 ;;
	esac
done

shift $((OPTIND-1)) 

if [[ $file == "" ]]; then
	file="hogs1.tmp"
	$(ps -eo user,vsz,rsz,pcpu,comm | tail -n +2 > "$file")
fi

echo "CPU hogs:"
sort -rnk4 "$file" | head -n "$n"
echo
echo "RES hogs:"
sort -rnk3 "$file" | head -n "$n"
echo
echo "VIRT hogs:"	
sort -rnk2 "$file" | head -n "$n"

