#!/bin/bash
echo "read file=/etc/os-release"
file="/etc/os-release"
while read line; do
echo $line
done < $file
