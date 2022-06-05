#!/bin/bash

filename="/etc/passwd"

while getopts "s" opt; do
	case ${opt} in
		s) optS="yes" ;;
		\?) exit 1 ;;
	esac
done

shift $((OPTIND-1))


if [[ $optS == "yes"  ]]; then
	gawk -v FS=":" 'BEGIN { line = ""; count = 0 } { if ($3 > 999) { line = line"\n"$1; count += 1 }  } END { print "liczba użytkowników: " count, line }' "$filename" | sort
else
	gawk -v FS=":" 'BEGIN { line = ""; count = 0 } { if ($3 > 999) { line = line"\n"$1; count += 1 }  } END { print "liczba użytkowników: " count, line }' "$filename"
fi
