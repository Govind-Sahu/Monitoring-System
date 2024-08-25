# Proxy Server Monitoring Script

## Description

This Bash script monitors various system resources on a proxy server and displays them in a dashboard format. The script refreshes every few seconds and allows users to view specific parts of the dashboard using command-line switches.

## Features

- **Top 10 Applications**: Displays the top 10 applications consuming the most CPU and memory.
- **Network Monitoring**: Monitors concurrent connections, packet drops, and network traffic (MB in/out).
- **Disk Usage**: Shows disk space usage by mounted partitions and highlights partitions using more than 80% of the space.
- **System Load**: Displays the current load average and a breakdown of CPU usage.
- **Memory Usage**: Displays total, used, and free memory, along with swap memory usage.
- **Process Monitoring**: Displays the number of active processes and the top 5 processes by CPU and memory usage.
- **Service Monitoring**: Monitors the status of essential services like `sshd`, `nginx`, `apache2`, `iptables`, etc.

## Usage

Run the script with the appropriate command-line switch to view specific parts of the dashboard.

```bash
./proxy_monitor.sh [switch]
