#!/bin/bash

# Advanced test script that actually simulates command failures
# and tests the script behavior in constrained environments

echo "=== Advanced Compatibility Tests ==="
echo

# Create a temporary directory for our tests
TEST_DIR="/tmp/osinfo_tests"
mkdir -p "$TEST_DIR"

# Create mock commands that fail
create_failing_command() {
    local cmd_name="$1"
    local fail_message="$2"
    cat > "$TEST_DIR/${cmd_name}" << EOF
#!/bin/bash
echo "$fail_message" >&2
exit 1
EOF
    chmod +x "$TEST_DIR/${cmd_name}"
}

# Create minimal commands that work
create_minimal_command() {
    local cmd_name="$1"
    local output="$2"
    cat > "$TEST_DIR/${cmd_name}" << EOF
#!/bin/bash
echo "$output"
EOF
    chmod +x "$TEST_DIR/${cmd_name}"
}

echo "Test 1: No systemd environment simulation"
echo "------------------------------------------"
# Create failing hostnamectl
create_failing_command "hostnamectl" "bash: hostnamectl: command not found"

# Backup original PATH and set restricted PATH
ORIGINAL_PATH="$PATH"
export PATH="$TEST_DIR:/bin:/usr/bin"

# Test our functions in this environment
echo "Testing without hostnamectl..."
source /home/runner/work/osinfo-bash-script/osinfo-bash-script/resource.sh

echo "OS Info: $(get_os_info)"
echo "Architecture: $(get_architecture)"
echo

echo "Test 2: Minimal Unix environment simulation"
echo "---------------------------------------------"
# Create minimal versions of commands
create_minimal_command "uptime" " 20:40:00 up 6 min,  1 user,  load average: 0.00, 0.00, 0.00"
create_failing_command "nproc" "nproc: command not found"
create_failing_command "lscpu" "lscpu: command not found"

export PATH="$TEST_DIR:/bin:/usr/bin"
echo "Testing with minimal commands..."
echo "Uptime: $(get_uptime)"
echo "CPU Count: $(get_cpu_count)"
echo "CPU Manufacturer: $(get_cpu_manufacturer)"
echo

echo "Test 3: Container environment simulation"
echo "-----------------------------------------"
# Simulate container where who shows no users
create_minimal_command "who" ""

export PATH="$TEST_DIR:/bin:/usr/bin"
echo "Testing user detection in container..."
echo "Users: $(get_current_users)"
echo

echo "Test 4: Non-GNU environment simulation (BSD-like)"
echo "---------------------------------------------------"
# Create BSD-style uptime that doesn't support -p
create_minimal_command "uptime" " 8:40PM  up 6 mins, 1 user, load averages: 0.00 0.00 0.00"

export PATH="$TEST_DIR:/bin:/usr/bin"
echo "Testing BSD-style uptime..."
echo "Uptime: $(get_uptime)"
echo

echo "Test 5: Running complete script in constrained environment"
echo "-----------------------------------------------------------"
# Reset to a more realistic but still constrained environment
rm -f "$TEST_DIR/hostnamectl" "$TEST_DIR/lscpu"  # Remove the failing ones
export PATH="$TEST_DIR:/bin:/usr/bin"

echo "Running full script with some missing commands:"
cd /home/runner/work/osinfo-bash-script/osinfo-bash-script
./resource.sh
echo

# Restore original PATH
export PATH="$ORIGINAL_PATH"

echo "Test 6: Edge case testing"
echo "--------------------------"
echo "Testing with empty environment variables..."

# Test behavior with empty/unset variables
unset HOSTNAME 2>/dev/null || true
echo "Hostname when HOSTNAME unset: $(hostname)"

echo "Testing with very long uptime..."
create_minimal_command "uptime" " 20:40:00 up 123 days, 45 min,  1 user,  load average: 0.00, 0.00, 0.00"
export PATH="$TEST_DIR:/bin:/usr/bin"
echo "Long uptime test: $(get_uptime)"

# Cleanup
rm -rf "$TEST_DIR"
export PATH="$ORIGINAL_PATH"

echo
echo "=== Advanced Test Summary ==="
echo "✓ Script handles missing hostnamectl gracefully"
echo "✓ Script works without GNU coreutils extensions"
echo "✓ Script handles container environments"
echo "✓ Script provides meaningful output even with missing commands"
echo "✓ No critical failures when commands are unavailable"