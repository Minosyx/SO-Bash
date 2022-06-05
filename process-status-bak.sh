#!/bin/bash

while getopts "f:u:" opt; do
	case ${opt} in
		f ) optF="yes" 
			filename="${OPTARG}" ;;
		u ) optU="yes"
			userS="${OPTARG}" ;;
		/? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

i=0
run=0
stp=0
term=0
zom=0

if [[ $optF == "yes" && $optU == "yes" ]]; then
	while read user s pid tgid lwp nlwp rss args; do
		if [[ $user == $userS ]]; then
			case ${s} in
				I ) i=$((i+nlwp)) ;;
				R ) run=$((run+nlwp)) ;;
				S ) stp=$((stp+nlwp)) ;;
				T ) term=$((term+nlwp)) ;;
				Z ) zom=$((zom+nlwp)) ;;
			esac
		fi
	done < "$filename"
elif [[ $optF == "yes" ]]; then
	while read user s pid tgid lwp nlwp rss args; do
		case ${s} in
			I ) i=$((i+nlwp)) ;;
			R ) run=$((run+nlwp)) ;;
			S ) stp=$((stp+nlwp)) ;;
			T ) term=$((term+nlwp)) ;;
			Z ) zom=$((zom+nlwp)) ;;
		esac
	done < "$filename"
elif [[ $optU == "yes" ]]; then
	i=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' -v u="$userS" 'BEGIN {count=0} NR > 1 { if ($2 == "I" && $1 == u) count+=$6 } END { print count }')
	run=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' -v u="$userS" 'BEGIN {count=0} NR > 1 { if ($2 == "R" && $1 == u) count+=$6 } END { print count }')
	stp=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' -v u="$userS" 'BEGIN {count=0} NR > 1 { if ($2 == "S" && $1 == u) count+=$6 } END { print count }')
	term=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' -v u="$userS" 'BEGIN {count=0} NR > 1 { if ($2 == "T" && $1 == u) count+=$6 } END { print count }')	
	zom=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' -v u="$userS" 'BEGIN {count=0} NR > 1 { if ($2 == "Z" && $1 == u) count+=$6 } END { print count }')	
else
	i=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' 'BEGIN {count=0} NR > 1 { if ($2 == "I") count+=$6 } END { print count }')
	run=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' 'BEGIN {count=0} NR > 1 { if ($2 == "R") count+=$6 } END { print count }')
	stp=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' 'BEGIN {count=0} NR > 1 { if ($2 == "S") count+=$6 } END { print count }')
	term=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' 'BEGIN {count=0} NR > 1 { if ($2 == "T") count+=$6 } END { print count }')	
	zom=$(ps -eo user,s,pid,tgid,lwp,nlwp,rss,args | gawk -v FS=' ' 'BEGIN {count=0} NR > 1 { if ($2 == "Z") count+=$6 } END { print count }')	
fi

echo "I=$i"
echo "R=$run"
echo "S=$stp"
echo "T=$term"
echo "Z=$zom"
