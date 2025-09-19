## About
I had the plan to learn bash scripting by working on projects, so I built this script to gather as much info related to my computer using different Linux commands. I don't have GPU installed on my computer which is a problem as I can't experiment on how to get the GPU info. But I will find a workaround.

## Compatibility Improvements
This script has been enhanced to work reliably across different Unix-like systems:

### ✅ Supported Systems
- **Linux distributions**: Ubuntu, Debian, CentOS, RHEL, Alpine, Arch, etc.
- **System types**: systemd and non-systemd systems
- **Environments**: Containers (Docker, LXC), minimal installations, chroot
- **Architectures**: x86-64, ARM, ARM64, and others

### ✅ Key Features
- **Fallback mechanisms**: Works even when system commands are missing
- **Cross-platform**: Compatible with GNU and non-GNU environments  
- **Error handling**: Graceful degradation when commands fail
- **No external dependencies**: Uses only standard Unix commands

## Usage

### Basic Usage
```bash
chmod +x resource.sh
./resource.sh
```

### Compatibility Check
Before running on a new system, check compatibility:
```bash
chmod +x check_compatibility.sh
./check_compatibility.sh
```

### Testing
Run the comprehensive test suite:
```bash
chmod +x test_compatibility.sh test_advanced.sh
./test_compatibility.sh
./test_advanced.sh
```

## What the Script Shows
- Operating System name and version
- System architecture  
- Current logged-in users
- Current user and hostname
- Current date and time
- System uptime
- Number of CPU cores
- CPU manufacturer

## Technical Details
See [COMPATIBILITY.md](COMPATIBILITY.md) for detailed information about:
- Compatibility improvements made
- Test cases implemented
- Supported system matrix
- Fallback mechanisms 
