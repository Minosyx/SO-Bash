#!/bin/bash

while getopts "au:" opt; do
	case ${opt} in
		a ) optA="yes" ;;
		u ) optU="yes"
			format=${OPTARG} ;;
		/? ) exit 1 ;;
	esac
done
shift $((OPTIND-1))

dateA="$(uptime -s)"
dateB="${1:-$(date -u "+%Y-%m-%d %H:%M:%S")}"

sA=$(date -d "$dateA" +%s)
sB=$(date -d "$dateB" +%s)

scale=2

if [[ $optA != "yes" && $optU != "yes" ]]; then
	res=$(echo "$sB - $sA"*1.00 | bc)
	echo "uptime=$res s"
elif [[ $optU == "yes" ]]; then
	case $format in
		s ) res=$(echo "$sB - $sA"*1.00 | bc) ;;
		m ) res=$(echo "scale=$scale; ($sB - $sA)/60" | bc) ;;
		h ) res=$(echo "scale=$scale; ($sB - $sA)/(60*60)" | bc) ;;
		d ) res=$(echo "scale=$scale; ($sB - $sA)/(60*60*24)" | bc) ;;
	esac
	echo "uptime=$res $format"
elif [[ $optA == "yes" ]]; then
	res=$(echo "$sB - $sA"*1.00 | bc)
	printf "%s" "uptime="
	printf "%15s %s\n" "$res" "s"
	res=$(echo "scale=$scale; ($sB - $sA)/60" | bc)
	printf "%22s %s\n" "$res" "m"
	res=$(echo "scale=$scale; ($sB - $sA)/(60*60)" | bc)
	printf "%22s %s\n" "$res" "h"
	res=$(echo "scale=$scale; ($sB - $sA)/(24*60*60)" | bc)
	printf "%22s %s\n" "$res" "d"
fi
