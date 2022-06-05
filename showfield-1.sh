#!/bin/bash

while getopts "f:d::" opt; do
	case ${opt} in
		f ) optF="yes"
			filename=${OPTARG} ;;
		d ) optD="yes"
		 	delimiter=${OPTARG} ;;
		\? ) exit 1 ;;
	esac
done
shift $((OPTIND-1))

if [[ $optF == "yes" ]]; then
	if [[ -z $optD ]]; then
		delimiter=" "
	fi
	args=("$@")
	gawk -v FS="$delimiter" -v OFS=' ' -v args="${args[*]}" 'BEGIN { split(args,a," "); delprint=0 } { for (i in a) { if (delprint==1) printf "%s %s ", FS, $a[i]; else { printf "%s ", $a[i]; delprint=1 } } print ""; delprint=0 }' "$filename"
fi
