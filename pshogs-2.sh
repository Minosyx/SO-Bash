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
	file="hogs2.tmp"
	$(ps -eo user,vsz,rsz,pcpu,comm | tail -n +2 > "$file")
fi

echo "CPU hogs:"
awk -v FS=" " -v OFS=" " '{ printf "  %-15s %10.2f %15s\n", $1, $4, $5 }' "$file" | sort -rnk2 | head -n "$n"
echo
echo "RES hogs:"
awk -v FS=" " -v OFS=" " '{ printf "  %-15s %10s %15s\n", $1, $3, $5 }' "$file" | sort -rnk2 | head -n "$n"
echo
echo "VIRT hogs:"
awk -v FS=" " -v OFS=" " '{ printf "  %-15s %10s %15s\n", $1, $2, $5 }' "$file" | sort -rnk2 | head -n "$n"
