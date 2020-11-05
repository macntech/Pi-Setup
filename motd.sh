#!/bin/sh

# Date Time
DATUM=`date +"%A, %e %B %Y"`

# Hostname
HOSTNAME=`hostname -f`

# Uptime
UP0=`cut -d. -f1 /proc/uptime`
UP1=$(($UP0/86400))        # Days
UP2=$(($UP0/3600%24))        # Hours
UP3=$(($UP0/60%60))        # Minutes
UP4=$(($UP0%60))        # Seconds

# Load
LOAD1=`cat /proc/loadavg | awk '{print $1}'`    # Last Minute
LOAD2=`cat /proc/loadavg | awk '{print $2}'`    # Last 5 Minutes
LOAD3=`cat /proc/loadavg | awk '{print $3}'`    # Last 15 Minutes

# Temperature
TEMP=`vcgencmd measure_temp | cut -c "6-9"`

# Disk
DISK1=`df -h | grep 'dev/root' | awk '{print $2}'`    # Total
DISK2=`df -h | grep 'dev/root' | awk '{print $3}'`    # Used
DISK3=`df -h | grep 'dev/root' | awk '{print $4}'`    # Free

# Memory
RAM1=`free --mega | grep 'Mem' | awk '{print $2}'`    # Total
RAM2=`free --mega | grep 'Mem' | awk '{print $3}'`    # Used
RAM3=`free --mega | grep 'Mem' | awk '{print $4}'`    # Free
RAM4=`free --mega | grep 'Swap' | awk '{print $3}'`    # Swap used

# check IP addresses of Pi
IP_LAN=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1) ;
IP_WLAN=$(/sbin/ip -o -4 addr list wlan0 | awk '{print $4}' | cut -d/ -f1) ;

printf "\033[1;36m$DATUM

\033[0;37mHostname......: \033[1;33m$HOSTNAME
\033[0;37mUptime........: $UP1 Days, $UP2:$UP3 Hours:Minutes
\033[0;37mAvg Load......: $LOAD1 (1 Min.) | $LOAD2 (5 Min.) | $LOAD3 (15 Min.)
\033[0;37mTemperature...: $TEMP °C
\033[0;37mDisk..........: Total: $DISK1 | Used: $DISK2 | Free: $DISK3
\033[0;37mMemory (MB)...: Total: $RAM1 MB | Used: $RAM2 MB | Free: $RAM3 MB | Swap: $RAM4 MB
\033[0;37mIP Network....: LAN: \033[1;35m$IP_LAN\033[0;37m | WiFi: \033[1;35m$IP_WLAN
\033[m

"