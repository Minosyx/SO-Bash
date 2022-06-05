#!/bin/bash

export LC_ALL=en_US.UTF-8

optF="no"

while getopts "suf:" opt; do
    case ${opt} in
        s ) optS="yes" ;;
        u ) optU="yes" ;;
        f ) optF="yes"
            filename=${OPTARG} ;;
        /? ) exit 1 ;;
    esac
done

shift $(($OPTIND-1))

declare -A cproc
declare -A ccpu
declare -A cmem

readarray -t user < <(ps -eo user,uid,pmem,pcpu,comm | gawk -v FS=" " ' FNR > 1 { print $1 }' | sort -u)

if [[ $optS == "yes" && $optF == "no" ]]; then
    for u in "${user[@]}"; do
        uid=$(ps -eo user,uid | grep "$u" | gawk -v FS=" " 'END {print $2}')
        np=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | wc -l)
        mem=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$3} END {print s}')
        cpu=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$4} END {print s}')
        if [ $uid -lt 1000 ]; then    
            cproc["$u"]="$np"
            ccpu["$u"]="$cpu"
            cmem["$u"]="$mem"
        fi
    done
elif [[ $optU == "yes" && $optF == "no" ]]; then
    for u in "${user[@]}"; do
        uid=$(ps -eo user,uid | grep "$u" | gawk -v FS=" " 'END { print $2 }')
        np=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | wc -l)
        mem=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$3} END {print s}')
        cpu=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$4} END {print s}')
        if [ $uid -ge 1000 ]; then    
            cproc["$u"]="$np"
            ccpu["$u"]="$cpu"
            cmem["$u"]="$mem"
        fi
    done
elif [[ $optF == "yes" && $optS == "yes" ]]; then
    {
    read
    while read u uid pmem pcpu comm; do
        if [ $uid -lt 1000 ]; then
            if [[ ${cproc[$u]} == "" ]]; then
                cproc["$u"]=1
                ccpu["$u"]="$pcpu"
                cmem["$u"]="$pmem"
            else
                cproc["$u"]=$((${cproc["$u"]}+1))
                ccpu["$u"]=$(echo "scale=1; ${ccpu[$u]}+$pcpu" | bc -l)
                cmem["$u"]=$(echo "scale=1; ${cmem[$u]}+$pmem" | bc -l)
            fi
        fi
    done
    } < "$filename"
elif [[ $optF == "yes" && $optU == "yes" ]]; then
    {
    read
    while read u uid pmem pcpu comm; do
        if [ $uid -ge 1000 ]; then
            if [[ ${cproc[$u]} == "" ]]; then
                cproc["$u"]=1
                ccpu["$u"]="$pcpu"
                cmem["$u"]="$pmem"
            else
                cproc["$u"]=$((${cproc["$u"]}+1))
                ccpu["$u"]=$(echo "scale=1; ${ccpu[$u]}+$pcpu" | bc -l)
                cmem["$u"]=$(echo "scale=1; ${cmem[$u]}+$pmem" | bc -l)
            fi
        fi
    done
    } < "$filename"
elif [[ $optF == "yes" ]]; then
    {
    read
    while read u uid pmem pcpu comm; do
        if [[ ${cproc[$u]} == "" ]]; then
            cproc["$u"]=1
            ccpu["$u"]="$pcpu"
            cmem["$u"]="$pmem"
        else
            cproc["$u"]=$((${cproc["$u"]}+1))
            ccpu["$u"]=$(echo "scale=1; ${ccpu[$u]}+$pcpu" | bc -l)
            cmem["$u"]=$(echo "scale=1; ${cmem[$u]}+$pmem" | bc -l)
        fi
    done
    } < "$filename"
else
    for u in "${user[@]}"; do
        np=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | wc -l)
        mem=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$3} END {print s}')
        cpu=$(ps -eo user,uid,pmem,pcpu,comm | grep "$u" | gawk -v FS=" " '{s+=$4} END {print s}')
        cproc["$u"]="$np"
        ccpu["$u"]="$cpu"
        cmem["$u"]="$mem"
    done
fi

for k in "${!cproc[@]}"; do
    printf '%10s %10s %10.1f %10.1f\n' "$k" "${cproc["$k"]}" "${ccpu["$k"]}" "${cmem["$k"]}"
done | sort -nr -k3
