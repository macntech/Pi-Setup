#!/bin/sh
# dynamische MOTD
# Aufruf in /etc/profile (letzte Zeile)
# Datum & Uhrzeit
DATUM=`date +"%A, %e %B %Y"`

# Hostname
HOSTNAME=`hostname -f`

# Uptime
UP0=`cut -d. -f1 /proc/uptime`
UP1=$(($UP0/86400))        # Tage
UP2=$(($UP0/3600%24))        # Stunden
UP3=$(($UP0/60%60))        # Minuten
UP4=$(($UP0%60))        # Sekunden

# Durchschnittliche Auslasung
LOAD1=`cat /proc/loadavg | awk '{print $1}'`    # Letzte Minute
LOAD2=`cat /proc/loadavg | awk '{print $2}'`    # Letzte 5 Minuten
LOAD3=`cat /proc/loadavg | awk '{print $3}'`    # Letzte 15 Minuten

# Temperatur
TEMP=`vcgencmd measure_temp | cut -c "6-9"`

# Speicherbelegung
DISK1=`df -h | grep 'dev/root' | awk '{print $2}'`    # Gesamtspeicher
DISK2=`df -h | grep 'dev/root' | awk '{print $3}'`    # Belegt
DISK3=`df -h | grep 'dev/root' | awk '{print $4}'`    # Frei

# Arbeitsspeicher
RAM1=`free --mega | grep 'Mem' | awk '{print $2}'`    # Total
RAM2=`free --mega | grep 'Mem' | awk '{print $3}'`    # Used
RAM3=`free --mega | grep 'Mem' | awk '{print $4}'`    # Free
RAM4=`free --mega | grep 'Swap' | awk '{print $3}'`    # Swap used

# IP-Adressen ermitteln
IP_LAN=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1) ;
IP_WLAN=$(/sbin/ip -o -4 addr list wlan0 | awk '{print $4}' | cut -d/ -f1) ;

printf "\033[1;36m$DATUM

\033[0;37mHostname......: \033[1;33m$HOSTNAME
\033[0;37mUptime........: $UP1 Tage, $UP2:$UP3 Stunden:Minuten
\033[0;37mØ Auslastung..: $LOAD1 (1 Min.) | $LOAD2 (5 Min.) | $LOAD3 (15 Min.)
\033[0;37mTemperatur....: $TEMP °C
\033[0;37mSpeicher......: Gesamt: $DISK1 | Belegt: $DISK2 | Frei: $DISK3
\033[0;37mRAM (MB)......: Gesamt: $RAM1 MB | Belegt: $RAM2 MB | Frei: $RAM3 MB | Swap: $RAM4 MB
\033[0;37mIP-Adressen...: LAN: \033[1;35m$IP_LAN\033[0;37m | WiFi: \033[1;35m$IP_WLAN
\033[m

"