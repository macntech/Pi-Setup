#!/bin/sh

#cd /Volumes/Privat/12_Netzwerk/04_Raspberry/Installer/

#Check install of whiptail
if ! which whiptail &>/dev/null; then
	echo "This Installer depends on whiptail. Please install whiptail first."
	exit 1
fi

whiptail --title "PI Setup" --msgbox "This is a simple support tool to help setup Raspberry Pi." 8 78


function contextSwitch {
	{
	ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
        echo 50
	sleep 1
        ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
        ctxt=$(($ctxt2 - $ctxt1))
        result="Number os context switches in the last secound: $ctxt"
	echo $result > result
	} | whiptail --gauge "Getting data ..." 6 60 0
}



while [ 1 ]
do
   # Aufbau des Menüs
CHOICE=$(
whiptail --title "Simple Raspberry Pi Setup Tool" --menu "Make your choice" 16 100 9 \
	"1)" "Start Initialization"  \
	"2)" "Enable Screen Output"  \
	"3)" "End script"  3>&2 2>&1 1>&3	
)

result=$(whoami)
case $CHOICE in
	"1)")   
		result="I am $result, the name of the script is start"
	;;
	"2)")   
	        OP=$(uptime | awk '{print $3;}')
		result="This system has been up $OP minutes"
	;;

	"3)") exit
        ;;
esac
whiptail --msgbox "$result" 20 78
done
exit
   

#
#echo "Starting initialization..."
#wait 2
# execute common part
#INSTALL_DIR=/home/boot/

#sudo mkdir -p $INSTALL_DIR

##echo -ne "Copy files        [           ] 0%\r"
# copy stats.py and secnetmod
#sudo cp stats.py $INSTALL_DIR
#chmod 777 $INSTALL_DIR/stats.py
#echo -ne "Copy files        [-----      ] 50%\r"
#sudo cp secnetmotd.sh $INSTALL_DIR
#chmod 777 $INSTALL_DIR/secnetmotd.sh
#echo -ne "Copy files        [-----------] Done\r"
#echo -ne '\n'
#echo -ne "Write old files   [           ] 0%\r"
#> /etc/motd

#sed -ie '0,/#PermitRootLogin prohibit-password/s/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#service sshd restart
#echo -ne "Write old files   [---        ] 30%\r"

#sudo rm /etc/profile.d/wifi-check.sh
#sudo rm /etc/update-motd.d/10-uname
#echo -ne "Write old files   [-------    ] 60%\r"

#echo -ne"Write old files   [-----------] Done\r"
#echo -ne '\n'
#read  -n 1 -p "Enter Hostname:" hostname
#hostnamectl set-hostname $hostname

