#!/bin/bash

re='^[0-9]+$'
while getopts "t:b:" opt; do
	case ${opt} in
		t ) 
			optT="yes"
			if [[ ${OPTARG} =~ $re ]]; then
				hlines=${OPTARG}
			fi
			;;
		b )
			optB="yes"
			if [[ ${OPTARG} =~ $re ]]; then
				tlines=${OPTARG}
			fi
			;;
		\? ) 
			exit 1 ;;
		: )
			echo "$OPTARG wymaga argumentu" 
			exit 1 ;;
	esac
done
shift $((OPTIND-1))

for doc in "$@"; do
	check=$(file $doc | grep -o "ASCII text")
	if [[ -f "$doc" && $check == "ASCII text" ]]; then 
		echo
		echo "plik $(basename $doc): HEAD"
		printf '%.0s-' {1..32}
		printf '\n'
		if [[ $optT == "yes" && $hlines =~ $re ]]; then
			head -$hlines "$doc"
		else
			head "$doc"
		fi
		echo
		echo "plik $(basename $doc): TAIL"
		printf '%.0s-' {1..32}
		printf '\n'
		if [[ $optB == "yes" && $tlines =~ $re ]]; then
			tail -$tlines "$doc"
		else
			tail "$doc"
		fi
		printf '%.0s=' {1..71}
		printf '\n'
	elif [[ -f "$doc" ]]; then
		echo "$(basename $doc) is not a text file ... skipping ..."
		printf '%.0s=' {1..71}
		printf '\n'
	fi
done
