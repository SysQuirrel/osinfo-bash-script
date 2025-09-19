#!/bin/bash

# Function to get OS information with fallbacks
get_os_info() {
    if command -v hostnamectl >/dev/null 2>&1; then
        os=$(hostnamectl 2>/dev/null | grep '^[[:space:]]*Operating System' | sed 's/^[[:space:]]*Operating System:[[:space:]]*//')
        if [ -z "$os" ]; then
            # Fallback if hostnamectl doesn't provide OS info
            os=$(cat /etc/os-release 2>/dev/null | grep '^PRETTY_NAME=' | cut -d'"' -f2)
        fi
    else
        # Fallback when hostnamectl is not available
        if [ -f /etc/os-release ]; then
            os=$(cat /etc/os-release | grep '^PRETTY_NAME=' | cut -d'"' -f2)
        elif [ -f /etc/lsb-release ]; then
            os=$(cat /etc/lsb-release | grep '^DISTRIB_DESCRIPTION=' | cut -d'"' -f2)
        elif [ -f /etc/system-release ]; then
            os=$(cat /etc/system-release)
        else
            os="Unknown Linux Distribution"
        fi
    fi
    echo "${os:-Unknown Operating System}"
}

# Function to get architecture with fallbacks
get_architecture() {
    if command -v hostnamectl >/dev/null 2>&1; then
        archi=$(hostnamectl 2>/dev/null | grep '^[[:space:]]*Architecture' | sed 's/^[[:space:]]*Architecture:[[:space:]]*//')
    fi
    
    if [ -z "$archi" ]; then
        # Fallback to uname
        archi=$(uname -m 2>/dev/null)
        case "$archi" in
            x86_64) archi="x86-64" ;;
            i386|i686) archi="x86" ;;
            aarch64) archi="arm64" ;;
            armv7l) archi="arm" ;;
        esac
    fi
    echo "${archi:-Unknown Architecture}"
}

# Function to get uptime with cross-platform support
get_uptime() {
    if uptime -p >/dev/null 2>&1; then
        # GNU uptime with -p flag
        uptime_info=$(uptime -p | grep -o 'up [^,]*' | cut -d' ' -f 2-)
    else
        # Fallback for systems without -p flag (BSD, macOS, etc.)
        uptime_raw=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/^[[:space:]]*//')
        uptime_info="$uptime_raw"
    fi
    echo "${uptime_info:-unknown}"
}

# Function to get CPU count with fallbacks
get_cpu_count() {
    if command -v nproc >/dev/null 2>&1; then
        cpu_count=$(nproc --all 2>/dev/null || nproc 2>/dev/null)
        if [ -n "$cpu_count" ] && [ "$cpu_count" -gt 0 ] 2>/dev/null; then
            echo "$cpu_count"
        elif [ -f /proc/cpuinfo ]; then
            grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo "unknown"
        else
            echo "unknown"
        fi
    elif [ -f /proc/cpuinfo ]; then
        grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo "unknown"
    else
        echo "unknown"
    fi
}

# Function to get CPU manufacturer with fallbacks
get_cpu_manufacturer() {
    if command -v lscpu >/dev/null 2>&1; then
        vendor=$(lscpu 2>/dev/null | grep '^Vendor ID' | awk '{print $3}')
        if [ -n "$vendor" ]; then
            case "$vendor" in
                GenuineIntel) echo "Intel" ;;
                AuthenticAMD) echo "AMD" ;;
                *) echo "$vendor" ;;
            esac
            return
        fi
    fi
    
    # Fallback to /proc/cpuinfo
    if [ -f /proc/cpuinfo ]; then
        vendor=$(grep -m1 '^vendor_id' /proc/cpuinfo | awk -F': ' '{print $2}')
        case "$vendor" in
            GenuineIntel) echo "Intel" ;;
            AuthenticAMD) echo "AMD" ;;
            *) echo "${vendor:-Unknown}" ;;
        esac
    else
        echo "Unknown"
    fi
}

# Function to get current users with better handling
get_current_users() {
    if command -v who >/dev/null 2>&1; then
        users=$(who 2>/dev/null | cut -d' ' -f1 | sort | uniq | tr '\n' ' ' | sed 's/[[:space:]]*$//')
        if [ -n "$users" ]; then
            echo "$users"
        else
            echo "$(whoami) (current session only)"
        fi
    else
        echo "$(whoami) (who command not available)"
    fi
}

# Main script execution
echo "##############"
echo "Operating System: $(get_os_info)"
echo "Architecture: $(get_architecture)"
echo "All users on the system is/are: $(get_current_users)"
echo "Current user is : $(whoami)"
echo "System name is : $(hostname)"
echo "The current date and time is : $(date)"
echo "The system is running for $(get_uptime)"
echo "##############"

echo "Number of CPUs: $(get_cpu_count)"
echo "CPU manufacturer: $(get_cpu_manufacturer)"

