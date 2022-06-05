#!/bin/bash

file=""

while getopts "f:" opt; do
	case ${opt} in
		f ) file=${OPTARG} ;;
		/? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

if [[ $file == "" ]]; then
	exit 1
fi

users=$(awk -v FS=" " '{ if (NR > 1) print $1 }' "$file" | sort -u | wc -l)
proc=$(awk -v FS=" " '{ if (NR > 1) print $2 }' "$file" | sort -u | wc -l)
multithp=$(awk -v FS=" " '{ if (NR > 1 && $5 > 1) print $5 }' "$file" | wc -l)
multith=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && $5 > 1) sum+=$5 } END { print sum }' "$file")
th=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1) sum+=$5 } END { print sum }' "$file")
kernel=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && ($3==2 || $2==2)) sum+=$5 } END { print sum }' "$file")

printf "%-52s%-5d\n\n" "liczba użytkowników:" "$users"
printf "%-53s%-5d\n" "liczba wątków jądra" "$kernel"
printf "%-51s%-5d\n" "liczba procesów:" "$proc"
printf "%-52s%-5d\n" "liczba procesów wielowątkowych:" "$multithp"
printf "%-53s%-5d\n" "liczba wątków w procesach wielowątkowych:" "$multith"
printf "%-52s%-5d\n" "liczba wszystkich wątków:" "$th"
