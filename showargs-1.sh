#!/bin/bash
args_num=$#
args_tab=("$@")

if [[ "$1" != "-r" ]]; then
	echo $args_num
	for arg in "${args_tab[@]}"; do
		echo "$arg"
	done	
else
	args_num2=$(($args_num-1))
	echo "$args_num2"
	args_tab=( "${args_tab[@]:1}" )
	for (( counter=$args_num2-1; counter >= 0; counter-- )); do
		echo ${args_tab[$counter]}
	done
fi
