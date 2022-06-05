#!/bin/bash

top=($(ac -p | gawk -v FS=' ' -v OFS=' ' '{ print $2 }' | sort -rg))

for i in "${top[@]}"; do
	check=($(ac -p | grep "$i"))
	if [[ ${check[0]} != "total" && ${check[0]} != "root" ]]; then
		echo "${check[0]} ${check[1]}"
		break 
	fi
done
