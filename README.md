# pshtop
# PowerShell System Monitoring Script

This repository contains a PowerShell script that provides a real-time system monitoring tool. The script displays CPU and memory usage using dynamic progress bars with a color scale, and lists the top processes by CPU usage, including file locations and memory usage.

## Features

- **Real-Time Monitoring**: Displays real-time CPU and memory usage.
- **Color-Coded Progress Bars**: 
  - 0-25%: Green
  - 26-75%: Yellow
  - 76-100%: Red
- **Top Processes**: Lists the top processes by CPU usage, along with their file locations and memory usage.
- **Dynamic Layout**: Adjusts to the console window width for a consistent display.

## Requirements

- PowerShell 5.0 or higher
- Windows Operating System

## Installation

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/yourusername/ps-system-monitoring.git
   cd ps-system-monitoring
