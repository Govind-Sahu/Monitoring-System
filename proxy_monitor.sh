#!/bin/bash

# Function to display top 10 applications consuming the most CPU and memory
top_apps() {
    echo "Top 10 Applications by CPU and Memory Usage"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11
    echo
}

# Function to monitor network stats
network_stats() {
    echo "Network Monitoring"
    echo "Concurrent Connections:"
    ss -s | grep -i 'tcp:' | awk '{print $2 " connections"}'
    echo "Packet Drops:"
    netstat -i | awk '/RX-DRP/{getline; print "RX drops: "$4" | TX drops: "$8}'
    echo "Network Traffic (MB in/out):"
    netstat -e | awk '/RX packets/{getline; print "MB in: " $2/1024/1024 " | MB out: " $10/1024/1024}'
    echo
}

# Function to display disk usage
disk_usage() {
    echo "Disk Usage"
    df -h | awk '$5 >= 80 {print $1 " is using " $5 " of the disk space."}'
    df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $1 " " $5}'
    echo
}

# Function to show system load
system_load() {
    echo "System Load"
    echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print "User: " $2 + $4 "%, System: " $6 "%, Idle: " $8 "%"}'
    echo
}

# Function to display memory usage
memory_usage() {
    echo "Memory Usage"
    free -h | awk '/Mem:/ {print "Total: " $2 ", Used: " $3 ", Free: " $4}'
    free -h | awk '/Swap:/ {print "Swap - Total: " $2 ", Used: " $3 ", Free: " $4}'
    echo
}

# Function to monitor processes
process_monitoring() {
    echo "Process Monitoring"
    echo "Number of active processes: $(ps aux --no-headers | wc -l)"
    echo "Top 5 Processes by CPU and Memory:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
    echo
}

# Function to monitor essential services
service_monitoring() {
    echo "Service Monitoring"
    services=(sshd nginx apache2 iptables)
    for service in "${services[@]}"; do
        if systemctl is-active --quiet $service; then
            echo "$service is running."
        else
            echo "$service is not running."
        fi
    done
    echo
}

# Function to display the custom dashboard based on command-line arguments
custom_dashboard() {
    case "$1" in
        -cpu)
            system_load
            ;;
        -memory)
            memory_usage
            ;;
        -network)
            network_stats
            ;;
        -disk)
            disk_usage
            ;;
        -process)
            process_monitoring
            ;;
        -services)
            service_monitoring
            ;;
        -all)
            top_apps
            network_stats
            disk_usage
            system_load
            memory_usage
            process_monitoring
            service_monitoring
            ;;
        *)
            echo "Usage: $0 { -cpu | -memory | -network | -disk | -process | -services | -all }"
            exit 1
    esac
}

# Refresh every few seconds if no specific part is requested
if [ $# -eq 0 ]; then
    while true; do
        clear
        custom_dashboard -all
        sleep 5
    done
else
    custom_dashboard "$1"
fi
