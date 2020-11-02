#!/bin/sh
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
# It is developed on personal purpose.
#
# cd /Volumes/Privat/12_Netzwerk/04_Raspberry/Installer/

#Check install of whiptail
clear
if ! which whiptail &>/dev/null; then
	echo "This Installer depends on whiptail. Please install whiptail first."
	exit 1
fi

#### VARIABLES ####
INSTALL_DIR="/home/boot/"
PROFIL_PATH="/etc/profile"
MOTD_PATH="/etc/motd"
HOSTNAME_FILE="/etc/hostname"
INTERFACE_FILE="/etc/dhcpcd.conf"
SSH_FILE=""
SOFTWARE="PI Setup"
#### END VARIABLES #####

# Function to setup the Hostname of the Raspberry
function SetupHostname {
    {
    sleep 0.5
    echo -e "XXX\n50\nUpdating Hostname... \nXXX"
    #echo "$HOSTNAME" > $hostname_file
    sleep 1
    echo -e "XXX\n100\nUpdating Hostname...Done \nXXX"
    sleep 1
	} | whiptail --gauge "Please wait..." 6 60 0
}

#Function to setup the static IP in dhcpcd
function SetStaticIP {
    
    while [[ -z $net_result ]] || [[ $net_result == "1" ]] ; do
    IP=$(whiptail --inputbox --nocancel "IP Adress for your system" 8 78 Name --title "Network Settings" 3>&1 1>&2 2>&3)
    GATEWAY=$(whiptail --inputbox --nocancel "Please enter the Gateway of your network" 8 78 Name --title "Network Setting" 3>&1 1>&2 2>&3)
    whiptail --title "Are the settings correct?" --yesno "\n IP Adress: $IP \n Gateway: $GATEWAY \n" 18 78 3>&1 1>&2 2>&3
    net_result=$?
    done
    
    WriteIP
}

function WriteIP {
    {
    sleep 0.5
    echo -e "XXX\n0\nUpdating Network Config... \nXXX"
    #Write Network Settings in File
    #echo "interface eth0" >> $INTERFACE_FILE
    echo -e "XXX\n30\nUpdating Network Config... \nXXX"
    #echo "  static ip_Address=$IP" >> $INTERFACE_FILE
    echo -e "XXX\n60\nUpdating Network Config... \nXXX"
    #echo "  static routers=$GATEWAY" >> $INTERFACE_FILE 
    echo -e "XXX\n100\nUpdating Network Config...Done \nXXX"
    sleep 0.5
    } | whiptail --gauge "Please wait..." 6 60 0
}

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
            #cat "PermitRootLogin yes" >> $ISCONFIGURED_FILE
            sleep 0.5
        echo -e "XXX\n60\nUpdating Root Password... \nXXX"
            #echo -e "$rootpasswd1\n$rootpasswd2" | passwd root
            sleep 0.5
        echo -e "XXX\n100\nEnable Root Complete... \nXXX"
            sleep 0.5

        } | whiptail --gauge "Please wait..." 6 60 0
}

#Start Setup Tool
whiptail --title "PI Setup" --msgbox "This is a simple support tool to help setup Raspberry Pi." 8 78

while [ 1 ]
do
#Main Menu
CHOICE=$(
whiptail --title "Pi Setup - Simplify Setup your Raspberry" --menu "Make your choice" 16 100 9 \
	"1)" "Start Initialization"  \
	"2)" "Enable Screen Output"  \
	"3)" "End script"  3>&2 2>&1 1>&3	
)
#Selection
case $CHOICE in
	"1)") 
        #Setup Hostname first
        HOSTNAME=$(whiptail --inputbox --nocancel "Please enter the Hostname for your system" 8 78 Name --title "Hostname" 3>&1 1>&2 2>&3)  
        SetupHostname

        #Give Option to Set Fixed IP
        if (whiptail --title "Network Settings" --yesno "Do you need a fixed IP Adress on the Raspberry" 8 78); then
            echo "::: Setup Fix IP confirmed"
            SetStaticIP
        else
            echo "::: Setup Fix IP cancelled"
        fi

        #Set Root user
        if (whiptail --title "Root User Setup" --yesno "Do you want to enable Root user?" 8 78); then
            echo "::: Setup Root User confirmed"
            SetRootPW
        else
            echo "::: Setup Root User cancelled"
        fi

        #Do main manipulation
        #Inform user about start of script
        whiptail --title "Initialization" --msgbox "The system will now setup new boot screen. Please confirm." 8 78
        
	;;
	"2)")   
	    OP=$(uptime | awk '{print $3;}')
		result="This system has been up $OP minutes"
	;;

	"3)") 
        clear
        exit
        ;;
esac
done
exit