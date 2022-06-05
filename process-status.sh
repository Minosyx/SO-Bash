#!/bin/bash

filename=""
userS=""

while getopts "f:u:" opt; do
	case ${opt} in
		f )	filename="${OPTARG}" ;;
		u )	userS="${OPTARG}" ;;
		/? ) exit 1 ;;
	esac
done

shift $((OPTIND-1))

i=0
run=0
stp=0
term=0
zom=0

if [[ $filename == "" ]]; then
	ps -eo user,s,pid,tgid,lwp,nlwp,rss,args > psstat.tmp
	filename="psstat.tmp"
fi

while read user s pid tgid lwp nlwp rss args; do
	if [[ $user == "USER" ]]; then
		continue
	elif [[ $userS == "" ]]; then
		case ${s} in
			I ) ((i++)) ;;
			R ) ((run++)) ;;
			S ) ((stp++)) ;;
			T ) ((term++)) ;;
			Z ) ((zom++)) ;;
		esac
	elif [[ $user == $userS ]]; then
		case ${s} in
			I ) ((i++)) ;;
			R ) ((run++)) ;;
			S ) ((stp++)) ;;
			T ) ((term++)) ;;
			Z ) ((zom++)) ;;
		esac
	fi
done < "$filename"

echo "I=$i"
echo "R=$run"
echo "S=$stp"
echo "T=$term"
echo "Z=$zom"
