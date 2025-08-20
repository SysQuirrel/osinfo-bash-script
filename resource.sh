#!/bin/bash
os=$(hostnamectl |grep '^Operating System')
archi=$(hostnamectl | grep '[[:blank:]]*Architecture' | sed 's/    //')
##archi_type=$(uname -m)
echo "##############"
echo "$os"
echo "$archi"
echo "Current user is : $(whoami)"
echo "System name is : $(hostname)"
echo "The current date and time is : $(date)"
echo "The system is running $(uptime -p | grep -o 'up [^,]*' | cut -d' ' -f 2-)"
echo "##############"


echo "$(lscpu | grep '^CPU(s)')"
echo "CPU $(lscpu | grep '^Vendor ID')"

