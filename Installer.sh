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
    act_IP=$(hostname -I)
    while [[ -z $net_result ]] || [[ $net_result == "1" ]] ; do
    IP=$(whiptail --inputbox --nocancel "IP Adress for your system" 8 78 $act_IP --title "Network Settings" 3>&1 1>&2 2>&3)
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

function SetupLoginScreen {
    {
    #mkdir -m $INSTALL_DIR
    echo -e "XXX\n10\nCheck install dir... \nXXX"

    } | whiptail --gauge "Please wait..." 6 60 0
}

# Function to setup the Hostname of the Raspberry
function SetupI2C {
    {
    sleep 0.5
    #mkdir -m $INSTALL_DIR
    echo -e "XXX\n10\nSetup PIP I2C... \nXXX"
    #apt-get install python3-pip -y
    echo -e "XXX\n20\nSetup I2C Tools... \nXXX"
    #apt-get install i2c-tools -y
    echo -e "XXX\n30\nSetup RPI.GPIO... \nXXX"
    #pip3 install RPI.GPIO
    echo -e "XXX\n40\nSetup ADAFruit Blinka... \nXXX"
    #pip3 install adafruit-blinka
    echo -e "XXX\n50\nSetup ADAFruit SSD1306... \nXXX"
    #pip3 install adafruit-circuitpython-ssd1306
    echo -e "XXX\n60\nSetup Python Pil... \nXXX"
    #apt-get install python3-pil -y
    echo -e "XXX\n70\nCopy Files... \nXXX"
    #cp -u stats.py $INSTALL_DIR
    echo -e "XXX\n100\nDone \nXXX"
    sleep 1
	} | whiptail --gauge "Please wait..." 6 60 0
}


#Start Setup Tool
whiptail --title "PI Setup" --msgbox "This is a simple support tool to help setup Raspberry Pi.\n Details can be found in the GitHub Repo" 10 78 

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
        whiptail --title "Initialization" --msgbox "The system will now setup the following parts: Please confirm." 8 78
        SetupLoginScreen
	;;
	"2)")   
	    whiptail --title "Setup Screen Output" --msgbox "The system will now setup I2C Screen Output. Please confirm." 8 78
        SetupI2C
        whiptail --title "Setup Screen Output" --msgbox "All files are setup. You can now attach the OLED Display and reboot your system." 8 78
	;;

	"3)") 
        if (whiptail --title "Reboot" --yesno "After you finish the setup you should reboot your PI to enable all settings made (Please remember your fix IP if set during setup). \n\nDo you want to reboot now?" 12 78); then
            clear
            echo "::: Reboot confirmed."
            #reboot
        else
            clear
            echo "::: Setup completed. Reboot cancelled. Please reboot manually."
            exit
        fi
    ;;
esac
done
exit