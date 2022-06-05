#!/bin/bash
if [ -z "$1" ]; then
	echo "Uzycie: $(basename $0) user"
else
	echo "$(id -G $1)"
	echo "$(id -nG $1)"
fi
