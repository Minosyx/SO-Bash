#!/bin/bash
if [[ -z "`printenv $1`" ]]
then
	echo "nieznana zmienna"
elif [[ -z "$1" ]]
then
	echo "brak argumentu"
else
	echo "$1=`printenv $1`"
fi

