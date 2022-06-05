#!/bin/bash

if [ -z "$1" ]; then
	echo "Uzycie ./$(basename $0) user"
else
	if [[ "$1" == "$USER" ]]; then
		echo "$1 jest wlascicielem powloki"
	else
		echo "$1 NIE jest wlascicielem powloki"
	fi
fi
