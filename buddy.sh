#!/bin/bash

file="/proc/buddyinfo"
node="Node 0"
zone="Normal"

export LC_ALL="C"

while getopts "asf:n:z:" opt; do
	case ${opt} in
		f ) file="${OPTARG}" ;;
		a ) optA="yes" ;;
		n ) node="${OPTARG}" ;;
		z ) zone="${OPTARG}" ;;
		s ) optS="yes" ;;
		\? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

if [[ "$node" == "" ]]; then
	node="Node 0"
fi
if [[ "$zone" == "" ]]; then
	zone="Normal"
fi

chunk="$1"
 
# jk: a dlaczego w potoku dwa razy $file???
#res=$(grep "$node" "$file" | egrep "$zone" "$file")
res=$(grep "$node" "$file" | egrep "$zone" )

if [[ $optA == "yes" ]]; then
    chunks=($(echo "$res" | awk -v FS=" " '{ i=5; while (i<=NF) { print $i; i++ } }'))
    for i in $(seq 0 10); do
	c="${chunks[$i]}"
	size=$(echo "scale=2;((2^$i)*4*$c)/1024" | bc)
	printf "%s %s %.2f\n" "$i" "${chunks[$i]}" "$size"
    done
else 
    #res=$(grep "$node" "$file" | grep "$zone" "$file")
    nnum=$(echo "$node" | cut -d" " -f2)
    chunks=$(echo "$res" | awk -v FS=" " -v c="$chunk" '{ i=5; s=c+i; print $s }')
    size=$(echo "scale=2;(2^$chunk)*4*$chunks/1024" | bc)
    printf "%s %s %.2f\n" "$chunk" "$chunks" "$size"
fi

msize=0

if [[ $optS == "yes" && $optA == "yes" ]]; then
    for i in $(seq 0 10); do
	chunks=($(echo "$res" | awk -v FS=" " '{ i=5; while (i<=NF) { print $i; i++ } }'))
	size=$(echo "scale=2;((2^$i)*4*${chunks[$i]})/1024" | bc)
	msize=$(echo "scale=2;$msize+$size" | bc)
    done
    echo "$msize"
fi
	
		
