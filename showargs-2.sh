#!/bin/bash

PRINTARGS() {
	for arg in "$@"; do
		echo "$arg"
	done
}

while getopts ":r" opt; do
	case ${opt} in
	r ) optR="yes" ;;
	\? ) exit 1 ;;
	esac
done
shift $((OPTIND-1))

echo "$#"
if [[ $optR == "yes" ]]; then
	PRINTARGS "$@" | tac
else
	PRINTARGS "$@"
fi
