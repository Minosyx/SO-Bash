#!/bin/bash

for doc in "$@"; do
	check=$(file $doc | grep -o "ASCII text")
	if [[ -f "$doc" && $check == "ASCII text" ]]; then
		echo
		echo "plik $(basename $doc): HEAD"
		printf '%.0s-' {1..32}
		printf '\n'
		head "$doc"
		echo
		echo "plik $(basename $doc): TAIL"
		printf '%.0s-' {1..32}
		printf '\n'
		tail "$doc"
		printf '%.s=' {1..71}
		printf '\n\n'
	else 
		echo "$(basename $doc) is not a text file ... skipping ..."
		printf '%.s=' {1..71}
		printf '\n\n'
	fi
done
