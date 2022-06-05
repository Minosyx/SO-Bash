#!/bin/bash

while getopts ":b" opt; do
	case ${opt} in
	b ) optS="yes" ;;
	\? ) exit 1 ;;
	esac
done
shift $((OPTIND-1))

if [[ $optS == "yes" ]]; then
	p1=${1-p1}
	p2=${2-p2}
	p3=${3-p3}
else
	p1=${1:-p1}
	p2=${2:-p2}
	p3=${3:-p3}
fi

cat << EOF
==$p1==
==$p2==
==$p3==
EOF
