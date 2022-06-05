#!/bin/bash
PARGS () {
	for arg in "$@"; do
                if [[ ! $arg =~ ^[-]+$ ]]; then
                        echo $arg
                fi
        done
}

CARGS () {
	i=0
	for arg in "$@"; do
		if [[ ! $arg =~ ^[-]+$ ]]; then
			((i++))
		fi
	done
	echo $i	
}

if [[ "$1" != "-r" ]]; then
	CARGS "$@"
	PARGS "$@"
else
	shift
	CARGS "$@"
	PARGS "$@" | tac
fi
