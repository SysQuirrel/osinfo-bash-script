#!/bin/bash
os=$(hostnamectl |grep '^Operating System')
archi=$(hostnamectl | grep '[[:blank:]]*Architecture' | sed 's/    //')
##archi_type=$(uname -m)
echo "##############"
echo "$os"
echo "$archi"
echo "All users on the system is/are: $(who | cut -d' ' -f1 | uniq)" 
echo "Current user is : $(whoami)"
echo "System name is : $(hostname)"
echo "The current date and time is : $(date)"
echo "The system is running for $(uptime -p | grep -o 'up [^,]*' | cut -d' ' -f 2-)"
echo "##############"


echo "Number of CPUs: $(nproc --all)"
echo "CPU manufacturer: $(lscpu | grep '^Vendor ID' | awk '{print $3}')"

