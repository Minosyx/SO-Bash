#!/bin/bash

os=$(grep -w 'NAME' /etc/os-release | cut -d '"' -f 2)
ver=$(grep -w "VERSION" /etc/os-release | cut -d '"' -f 2)
cpe=$(grep -w "CPE_NAME" /etc/os-release | cut -d '"' -f 2)
virt=""
icon=""
chassis=""

if [[ -f "/etc/machine-info" ]]; then
	icon=$(grep -w "ICON_NAME" /etc/machine-info | cut -d '=' -f 2)
	chassis=$(grep -w "CHASSIS" /etc/machine-info | cut -d '=' -f 2)
fi

if [[ $(id -u) -eq 0 ]]; then
	virt=$(virt-what)
fi

printf '%20s%s\n' "Static hostname: " $(hostname -f)
printf '%20s%s\n' "Icon name: " "$icon"
printf '%20s%s\n' "Chassis: " "$chassis"
printf '%20s%s\n' "Machine ID: " $(cat /etc/machine-id)
printf '%20s%s\n' "Boot ID: " $(cat /proc/sys/kernel/random/boot_id)
printf '%20s%s\n' "Virtualization: " "$virt"
printf '%20s%s %s\n' "Operating System: " "$os" "$ver"
printf '%20s%s\n' "CPE OS Name: " "$cpe"
printf '%20s%s\n' "Kernel: " "$(uname -sr)"
printf '%20s%s\n' "Architecture: " "$(uname -m)"
