#!/bin/bash

file=""
optP=""

while getopts "f:pr" opt; do
	case ${opt} in
		f ) file=${OPTARG} ;;
		p ) optP="yes" ;;
		r ) optR="yes" ;;
		/? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

if [[ $file == "" ]]; then
	exit 1
fi

users=$(awk -v FS=" " '{ if (NR > 1) print $1 }' "$file" | sort -u | wc -l)
proc=$(awk -v FS=" " '{ if (NR > 1)  print $2 }' "$file" | sort -u | wc -l)
multithp=$(awk -v FS=" " '{ if (NR > 1 && $5 > 1) print $5 }' "$file" | wc -l)
multith=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && $5 > 1) sum+=$5 } END { print sum }' "$file")
th=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1) sum+=$5 } END { print sum }' "$file")
kernel=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && ($3==2 || $2==2)) sum+=$5 } END { print sum }' "$file")
if [[ $optP == "yes" ]]; then
	pge120=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && $7=="-" && 139-$6>=120) sum+=1 } END { print sum }' "$file")
	pge100=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && $7=="-" && 139-$6>=100 && 139-$6<120) sum+=1 } END { print sum }' "$file")
	plt100=$(awk -v FS=" " 'BEGIN { sum = 0 } { if (NR > 1 && $7!="-") sum+=1 } END { print sum }' "$file")
fi

printf "%-52s%-5d\n\n" "liczba użytkowników:" "$users"

printf "%-53s%-5d\n" "liczba wątków jądra" "$kernel"	
printf "%-51s%-5d\n" "liczba procesów:" "$proc"
printf "%-52s%-5d\n" "liczba procesów wielowątkowych:" "$multithp"
printf "%-53s%-5d\n" "liczba wątków w procesach wielowątkowych:" "$multith"
printf "%-52s%-5d\n" "liczba wszystkich wątków:" "$th"

if [[ $optP == "yes" ]]; then
	printf "\n%-51s%-5d\n" "liczba procesów z priorytetem >= 120:" "$pge120"
	printf "%-51s%-5d\n" "liczba procesów z priorytetem z zakresu 100-119:" "$pge100"
	printf "%-51s%-5d\n" "liczba procseów z priorytetem < 100 (RT):" "$plt100"
fi

if [[ $optP == "yes" && $optR == "yes" ]]; then
    declare -A arr
	echo
    echo "lista procesów czasu rzeczywistego:"
    name=($(awk -v FS=" " '{ if (NR > 1 && $7 != "-") print $10 }' "$file"))
    val=($(awk -v FS=" " '{ if (NR > 1 && $7 != "-") print $6 }' "$file"))
    num=${#name[@]}
    for i in $(seq 0 $((num-1))); do
        arr["${name[$i]}"]="${val[$i]}"
    done
    for KEY in "${!arr[@]}"; do
        printf " %-20s%5d\n" "$KEY" "${arr[$KEY]}"
    done | sort -k1
fi
