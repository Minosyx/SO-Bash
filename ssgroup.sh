#!/bin/bash

file="/etc/group"

while getopts "nf:" opt; do
	case ${opt} in
		n) optN="yes";;
		f) file="${OPTARG}";;
		\?) exit 1;;
	esac
done

shift $((OPTIND-1))

while read line; do
	if [[ $line == "" ]]; then
		echo
		continue
	fi
	check=$(echo "$line" | awk -v FS=":" '{ print $2 }')
	tmp="$line"
	if [[ "$check" != "x" ]]; then
		tmp=$(echo "$line" | sed 's/::/:x:/')
	fi
	data=$(echo "$tmp" | awk -v FS=":" '{ print $4 }')
	if [[ "$optN" == "yes" ]]; then
		tmp2=$(echo "$data" | awk -v FS="," '{ i=1; while (i<=NF) {printf "%s\n", $i; i++} }' | sort -nk1)
	else
		tmp2=$(echo "$data" | awk -v FS="," '{ i=1; while (i<=NF) {printf "%s\n", $i; i++} }' | sort -k1)
	fi
	tmp2=$(echo "$tmp2" | awk -v FS="\n" '{ i=1; while (i<=NF) {printf "%s,", $i; i++} }')
	if [[ $tmp2 != "" ]]; then
		tmp2=${tmp2::-1}
	fi
	temp=$(echo "$tmp" | awk -v FS=":" '{ i=1; while (i<4) {printf "%s:", $i; i++} }')
	temp="$temp""$tmp2"
	echo "$temp"	
done < "$file"
