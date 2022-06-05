#!/bin/bash

export LC_NUMERIC='C'

while getopts ":mg" opt; do
	case ${opt} in
		m ) optM="yes" ;;
		g ) optG="yes" ;;
		\? ) exit 1 ;;
	esac
done
shift $((OPTIND-1))

plik="/proc/iomem"

startmem=($(gawk -v FS="[:-]" '{print $2}' "$plik"))
endmem=($(gawk -v FS="[:-]" '{print $1}' "$plik"))
name=$(gawk -F ' : ' '{print $2}' $plik)

readarray name <<< "$name"

len=$((${#startmem[@]} - 1))

for i in $(seq 0 $len); do
	a=${endmem[$i]}
	b=${startmem[$i]}
	n=$(echo "${name[$i]}" | sed 's/\\n//')
	res=$(echo "ibase=16; ${b^^}-${a^^}" | bc)
	if [[ "$optM" == "yes" ]]; then 
		s="MB"
		sres=$(echo "scale=4;(($res+52.4288)/(1024*1024))" | bc)
	elif [[ "$optG" == "yes" ]]; then
		s="GB"
		sres=$(echo "scale=4;(($res+53687.0912)/(1024*1024*1024))" | bc)
	else
		s="KB"
		sres=$(echo "scale=4;($res/1024)" | bc)
	fi
	sres=$(echo $sres | sed -e 's/^\./0./' )
	printf "%20s:%20d B%20s $s\n" "$n" $res $sres
done
