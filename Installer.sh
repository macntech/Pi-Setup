#!/bin/bash

#  _____ _____    _____      _               
# |  __ \_   _|  / ____|    | |              
# | |__) || |   | (___   ___| |_ _   _ _ __  
# |  ___/ | |    \___ \ / _ \ __| | | | '_ \ 
# | |    _| |_   ____) |  __/ |_| |_| | |_) |
# |_|   |_____| |_____/ \___|\__|\__,_| .__/ 
#                                    | |    
#                                    |_|    
#
# This Script is Free to Use and will support you on setting up a Raspberry. 
# It is developed on personal purpose. More information can be found in the Github repo.
# https://github.com/jgeisslinger/Pi-Setup
# 
# Author: Johannes Geisslinger
# Web: https://coding.observer
#

# Check install of whiptail before entering the tool
clear
if ! which whiptail &>/dev/null; then
	echo "This Installer depends on whiptail. Please install whiptail first."
	exit 1
fi

#### VARIABLES ####
INSTALL_DIR="/home/boot"
PROFIL_PATH="/etc/profile"
MOTD_PATH="/etc/motd"
HOSTNAME_FILE=/etc/hostname
INTERFACE_FILE="/etc/dhcpcd.conf"
SSH_FILE="/etc/ssh/sshd_config"
SOFTWARE="PI Setup"
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
PI_CONFIG=/boot/config.txt
BLACKLIST=/etc/modprobe.d/raspi-blacklist.conf
#### END VARIABLES #####

# Function to setup the Hostname of the Raspberry
# Function Status: Done
function SetupHostname {
    {
    sleep 0.25
    echo -e "XXX\n50\nUpdating Hostname... \nXXX"
    echo "$HOSTNAME" > "$HOSTNAME_FILE"
    sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$HOSTNAME/g" /etc/hosts
    sleep 0.25
    echo -e "XXX\n100\nUpdating Hostname...Done \nXXX"
    sleep 0.5
	} | whiptail --gauge "Please wait..." 6 60 0
}

# Function to request the static IP from the user entry
# Function Status: Done
function SetStaticNetwork {
    act_IP=$(hostname -I)
    while [[ -z $net_result ]] || [[ $net_result == "1" ]] ; do
    IP=$(whiptail --inputbox --nocancel "IP Adress for your system" 8 78 $act_IP --title "Network Settings" 3>&1 1>&2 2>&3)
    GATEWAY=$(whiptail --inputbox --nocancel "Please enter the Gateway of your network" 8 78 Name --title "Network Setting" 3>&1 1>&2 2>&3)
    
    if (whiptail --title "Network Settings" --yesno "Do you want to set a domain for your Raspberry?" 8 78); then
        DOMAIN=$(whiptail --inputbox --nocancel "Please enter the Domain (FQDN) of your Raspberry (e.g. rasperry.local)" 10 78 Name --title "Network Setting" 3>&1 1>&2 2>&3)
    else
        echo "::: LOG ::: Setup Domain cancelled"
    fi

    whiptail --title "Are the settings correct?" --yesno "\n IP Adress: $IP \n Gateway: $GATEWAY \n Domain: $DOMAIN \n" 12 78 3>&1 1>&2 2>&3
    net_result=$?
    done
    # Call the Function to write the network information
    WriteNetwork
}

# Function to Write the IP into dhcpcd
# Function Status: Done
function WriteNetwork {
    {
    sleep 0.5
    echo -e "XXX\n0\nUpdating Network Config... \nXXX"
    #Write Network Settings in File
    echo "interface eth0" >> $INTERFACE_FILE
    echo -e "XXX\n25\nUpdating IP Config... \nXXX"
    echo "static ip_Address=$IP" >> $INTERFACE_FILE
    echo -e "XXX\n50\nUpdating Gateway Config... \nXXX"
    echo "static routers=$GATEWAY" >> $INTERFACE_FILE 
    echo -e "XXX\n75\nUpdating Domain Config... \nXXX"
    echo "static domain_name=$DOMAIN" >> $INTERFACE_FILE 
    echo "static domain_search=$DOMAIN" >> $INTERFACE_FILE 
    echo -e "XXX\n100\nUpdating Network Config...Done \nXXX"
    sleep 0.5
    } | whiptail --gauge "Please wait..." 6 60 0
}

# Function to enable the root user SSH and set password
# Function Status: Done
function SetRootPW 
    {
    {
    while [[ -z $password_result ]] || [[ $password_result == "1" ]] ; do
        rootpasswd1=$(whiptail --passwordbox "Enter new password for root:" 10 60 3>&1 1>&2 2>&3)
        rootpasswd2=$(whiptail --passwordbox "Repeat new password for root:" 10 60 3>&1 1>&2 2>&3)
        if [ $rootpasswd1 != $rootpasswd2 ]; then
            whiptail --msgbox "Passwords do not match" 10 60
            ! true  
        fi
        password_result=$?
        done
        echo -e "XXX\n30\nEnable Root User... \nXXX"      
        sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' $SSH_FILE
        sleep 0.5
        echo -e "XXX\n60\nUpdating Root Password... \nXXX"
            echo -e "$rootpasswd1\n$rootpasswd2" | passwd root
            sleep 0.5
        echo -e "XXX\n80\nRestarting SSH Service... \nXXX"
            sudo service ssh restart
            sleep 0.5
        echo -e "XXX\n100\nEnable Root Complete... \nXXX"
            sleep 0.5

    } | whiptail --gauge "Please wait..." 6 60 0
}

# Function to setup the new SSH Login Screen
# Function Status: Done
function SetupLoginScreen {
    {
    echo -e "XXX\n10\nChecking install dir... \nXXX"
    mkdir -p "$INSTALL_DIR"
    sleep 0.5
    echo -e "XXX\n20\nCopy Files... \nXXX"
    cp -b motd.sh "$INSTALL_DIR"
    chmod 777 "$INSTALL_DIR/motd.sh"
    sleep 0.5
    echo -e "XXX\n40\nWriting new Entries... \nXXX"
    echo "$INSTALL_DIR/motd.sh" >> "$PROFIL_PATH"
    sleep 0.5
    echo -e "XXX\n60\nRemove old Files... \nXXX"
    rm -f /etc/profile.d/wifi-check.sh
    rm -f /etc/update-motd.d/10-uname
    > /etc/motd 
    sleep 0.25
    echo -e "XXX\n100\nLogin Screen completed... \nXXX"
    sleep 0.25
    } | whiptail --gauge "Please wait..." 6 60 0
}

# Function to setup the I2C OLED Config of the Raspberry
# Function Status: Done
function SetupI2C {
    {
    sleep 0.5
    echo -e "XXX\n5\nRefresh Update Library... \nXXX"
    apt-get update
    mkdir -p "$INSTALL_DIR"
    echo -e "XXX\n10\nSetup PIP I2C... \nXXX"
    apt-get install python3-pip -y
    echo -e "XXX\n20\nSetup I2C Tools... \nXXX"
    apt-get install i2c-tools -y
    echo -e "XXX\n30\nSetup RPI.GPIO... \nXXX"
    pip3 install RPI.GPIO
    echo -e "XXX\n40\nSetup ADAFruit Blinka... \nXXX"
    pip3 install adafruit-blinka
    echo -e "XXX\n50\nSetup ADAFruit SSD1306... \nXXX"
    pip3 install adafruit-circuitpython-ssd1306
    echo -e "XXX\n60\nSetup Python Pil... \nXXX"
    apt-get install python3-pil -y
    echo -e "XXX\n70\nCopy Files... \nXXX"
    cp -u stats.py "$INSTALL_DIR"
    echo -e "XXX\n100\nDone \nXXX"
    echo "::: LOG ::: I2C OLED Setup completed."
    sleep 1
	} | whiptail --gauge "Please wait..." 6 60 0
}

#Enable I2C Module from raspi-config
function EnableI2C{
    
    if ! [ -e $BLACKLIST ]; then
        touch $BLACKLIST
    fi
    sed $BLACKLIST -i -e "s/^\(blacklist[[:space:]]*i2c[-_]bcm2708\)/#\1/"
    sed /etc/modules -i -e "s/^#[[:space:]]*\(i2c[-_]dev\)/\1/"
    dtparam i2c_arm=on
    modprobe i2c-dev
    sudo sed -i 's/#dtparam=i2c_arm/dtparam=i2c_arm=on/' $PI_CONFIG
}


##############  Start the main Setup Tool ################

whiptail --title "PI Setup" --msgbox "This is a simple support tool to help setup Raspberry Pi.\n\nDetails can be found in the GitHub Repo.\n\nVisit me at https://coding.observer" 15 78 

while [ 1 ]
do
#Main Menu
CHOICE=$(
whiptail --title "Pi Setup - Simplify Setup your Raspberry" --menu "Make your choice" 16 100 9 \
	"1)" "Start Initialization"  \
	"2)" "Enable I2C Screen Output"  \
	"3)" "End script"  3>&2 2>&1 1>&3	
)
#Selection
case $CHOICE in
	"1)") 
        #Setup Hostname first
        HOSTNAME=$(whiptail --inputbox --nocancel "Please enter the Hostname for your system" 8 78 Hostname --title "Hostname" 3>&1 1>&2 2>&3)  
        SetupHostname

        #Give Option to Set Fixed IP
        if (whiptail --title "Network Settings" --yesno "Do you need a fixed IP Adress on the Raspberry" 8 78); then
            SetStaticNetwork
            echo "::: LOG ::: Setup Fix Network completed"
        else
            echo "::: LOG ::: Setup Fix IP cancelled"
        fi

        #Set Root user
        if (whiptail --title "Root User Setup" --yesno "Do you want to setup and enable SSH root user?" 8 78); then
            echo "::: LOG ::: Setup SSH Root User confirmed."
            SetRootPW
        else
            echo "::: LOG ::: Setup SSH Root User denied."
        fi

        #Do main manipulation
        #Inform user about start of script
        whiptail --title "Initialization" --msgbox "The system will now start initialization of new SSH screen. Please confirm." 8 78
        SetupLoginScreen
	;;
	"2)")   
	    whiptail --title "Setup Screen Output" --msgbox "The system will now setup I2C OLED Screen Output. If you already have the depending software installed, nothing will be installed and only the Screen script is copied. Please confirm." 8 78
        SetupI2C
        EnableI2C
        whiptail --title "Setup Screen Output" --msgbox "All files are setup and dependencies are installed. You can now attach the OLED Display and reboot your system." 8 78
	;;

	"3)") 
        if (whiptail --title "Reboot" --yesno "After you finish the setup you should reboot your PI to enable all settings made (Please remember your fix IP if set during setup). You can find the Logfile under ${PWD} \n\nDo you want to reboot now?" 12 78); then
            echo "::: LOG ::: Setup completed. Reboot confirmed. Shutdown in 1 Minute. To cancel type shutdown -c"
            shutdown -r 1
        else
            echo "::: LOG ::: Setup completed. Reboot cancelled. Please reboot manually."
            exit
        fi
    ;;
esac
done
exit