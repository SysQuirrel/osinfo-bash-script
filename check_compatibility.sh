#!/bin/bash

# Quick validation script for osinfo-bash-script compatibility
# Run this on your target system to check if the script will work properly

echo "=== osinfo-bash-script Compatibility Check ==="
echo

# Check essential commands
echo "Checking essential commands:"
echo "----------------------------"
for cmd in bash whoami hostname date; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd - available"
    else
        echo "❌ $cmd - MISSING (critical)"
    fi
done
echo

# Check primary commands
echo "Checking primary system info commands:"
echo "---------------------------------------"
if command -v hostnamectl >/dev/null 2>&1; then
    echo "✅ hostnamectl - available (systemd system)"
    hostnamectl_working="yes"
else
    echo "⚠️  hostnamectl - not available (will use fallbacks)"
    hostnamectl_working="no"
fi

if command -v lscpu >/dev/null 2>&1; then
    echo "✅ lscpu - available"
else
    echo "⚠️  lscpu - not available (will use /proc/cpuinfo)"
fi

if command -v nproc >/dev/null 2>&1; then
    echo "✅ nproc - available"
else
    echo "⚠️  nproc - not available (will use /proc/cpuinfo)"
fi

if uptime -p >/dev/null 2>&1; then
    echo "✅ uptime -p - available (GNU coreutils)"
else
    echo "⚠️  uptime -p - not available (will parse standard uptime)"
fi

if command -v who >/dev/null 2>&1; then
    echo "✅ who - available"
else
    echo "⚠️  who - not available (will show current user only)"
fi
echo

# Check fallback resources
echo "Checking fallback resources:"
echo "-----------------------------"
if [ -f /etc/os-release ]; then
    echo "✅ /etc/os-release - available"
    os_fallback="yes"
elif [ -f /etc/lsb-release ]; then
    echo "✅ /etc/lsb-release - available"
    os_fallback="yes"
elif [ -f /etc/system-release ]; then
    echo "✅ /etc/system-release - available"
    os_fallback="yes"
else
    echo "⚠️  OS info files - limited (may show 'Unknown')"
    os_fallback="no"
fi

if [ -f /proc/cpuinfo ]; then
    echo "✅ /proc/cpuinfo - available"
    cpu_fallback="yes"
else
    echo "⚠️  /proc/cpuinfo - not available (limited CPU info)"
    cpu_fallback="no"
fi
echo

# Compatibility assessment
echo "Compatibility Assessment:"
echo "-------------------------"
if [ "$hostnamectl_working" = "yes" ] || [ "$os_fallback" = "yes" ]; then
    os_compat="✅ OS detection will work"
else
    os_compat="⚠️  OS detection may be limited"
fi

if [ "$cpu_fallback" = "yes" ]; then
    cpu_compat="✅ CPU detection will work"
else
    cpu_compat="⚠️  CPU detection may be limited"
fi

echo "$os_compat"
echo "$cpu_compat"
echo "✅ Date, time, hostname, and user info will work"
echo "✅ Uptime detection will work (with appropriate parsing)"
echo

# Overall recommendation
echo "Overall Recommendation:"
echo "-----------------------"
missing_critical=$(echo "bash whoami hostname date" | tr ' ' '\n' | while read cmd; do
    command -v "$cmd" >/dev/null 2>&1 || echo "missing"
done | grep -c "missing")

if [ "$missing_critical" -eq 0 ]; then
    echo "✅ COMPATIBLE: The script will work on this system"
    echo "   All essential commands are available and fallbacks are in place"
    if [ "$hostnamectl_working" = "no" ] || [ "$cpu_fallback" = "no" ]; then
        echo "   Some information may be limited due to missing commands"
    fi
else
    echo "❌ NOT COMPATIBLE: Missing critical commands"
    echo "   This system lacks essential commands needed for the script"
fi
echo

echo "Run './resource.sh' to see the actual output on this system."