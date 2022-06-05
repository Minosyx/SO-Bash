#!/bin/bash

filename="/etc/passwd"

while getopts "s" opt; do
	case ${opt} in
		s) optS="yes" ;;
		\?) exit 1 ;;
	esac
done

shift $((OPTIND-1))

count=$(gawk -v FS=":" 'BEGIN { count = 0 } { if ($3 > 999) count+=1 } END { print count }' "$filename")
echo "liczba uzytkownikow systemu: $count"

if [[ $optS == "yes"  ]]; then
	gawk -v FS=":" '{ if ($3 > 999) print $1 }' "$filename" | sort
else
	gawk -v FS=":" '{ if ($3 > 999) print $1 }' "$filename"
fi
