#!/bin/bash
cat << EOF
$(basename $0 .sh)
$#
EOF
min_args=3
args=("$@")
if [[ $# -lt $min_args ]]; then
	echo "This script needs at least $min_args command-line arguments!"
	exit
fi
cat << EOF
Argument may be printed using iterative instruction
for ...
EOF
for i in "$@";
do
	echo "$i"
done
echo 'while [[ $# -gt 0 ]] ...'
while [[ $# -gt 0 ]]; do
	echo "$1"
	shift
done
set "${args[@]}"
echo 'while (( $# > 0 )) ...'
while (( $# > 0 )); do
	echo "$1"
	shift
done
set "${args[@]}"
echo "until ..."
until [[ $# -le 0 ]]; do
	echo "$1"
	shift
done
