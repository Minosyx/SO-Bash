#!/bin/bash

for doc in "$@"; do
	echo 
	echo "plik $(basename "$doc")"
	printf '%.0s-' {1..32}
	printf '\n'
	head "$doc"
done
