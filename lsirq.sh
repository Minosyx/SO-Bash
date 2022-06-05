#!/bin/bash

filename="/proc/interrupts"

while getopts "sf:" opt; do
	case ${opt} in
		s ) optS="yes" ;;
		f ) filename=${OPTARG} ;;
		\? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

int=()
idq=()
name=()

cpu=$(grep "CPU" "$filename" | gawk -v FS=" " '{ print $NF }' | sed 's/[^0-9]//g')
if [[ $optS == "yes" ]]; then
	readarray -t tab < <(gawk -v FS=' ' -v OFS=" " -v n="$((cpu+2))" 'FNR > 1 { sum=0; i=2; while(i <= n){ sum+=$i; i+=1} print sum, $1, $NF }' "$filename" | sort -nr)
	for a in "${tab[@]}"; do
		l=($a)
		new_int="${l[0]}"
		new_id="${l[1]}"
		new_name="${l[2]}"
		int+=("$new_int")
		idq+=("$new_id")
		name+=("$new_name")
	done
else
	int=($(gawk -v FS=' ' -v OFS=" " -v n="$((cpu+2))" 'FNR > 1 { sum=0; i=2; while(i <= n){ sum+=$i; i+=1 } print sum }' "$filename"))
	idq=($(gawk -v FS=' ' -v OFS=" " -v n="$((cpu+2))" 'FNR > 1 { sum=0; i=2; while(i <= n){ sum+=$i; i+=1 } print $1 }' "$filename"))
	name=($(gawk -v FS=' ' -v OFS=" " -v n="$((cpu+2))" 'FNR > 1 { sum=0; i=2; while(i <= n){ sum+=$i; i+=1 } print $NF }' "$filename"))
fi

count=${#idq[@]}
loc=""
for i in $(seq 0 $((count-1))); do
	irq=${idq[$i]}
	irq=${irq::-1}
	if [[ $irq =~ ^[0-9]+$ ]]; then
		printf "%15s %-5s %-15s\n" "${int[$i]}" "$irq" "${name[$i]}"
	elif [[ $irq == "LOC" ]]; then
		loc="${int[$i]}"
	fi
done
printf "%15s %-30s\n" "$loc" "Local timer interrupts"
