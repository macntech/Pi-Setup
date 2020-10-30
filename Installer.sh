#!/bin/sh

echo "Starting initialization..."
wait 2
# execute common part
INSTALL_DIR=/home/boot/

sudo mkdir -p $INSTALL_DIR

echo "Copy files        [           ] 0%"
# copy stats.py and secnetmod
sudo cp stats.py $INSTALL_DIR
chmod 777 $INSTALL_DIR/stats.py
echo "Copy files        [-----      ] 50%"
sudo cp secnetmotd.sh $INSTALL_DIR
chmod 777 $INSTALL_DIR/secnetmotd.sh
echo "Copy files        [-----------] Done"
echo "Write old files   [           ] 0%"
> /etc/motd

sed -ie '0,/#PermitRootLogin prohibit-password/s/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
service sshd restart
echo "Write old files   [---        ] 30%"

sudo rm /etc/profile.d/wifi-check.sh
sudo rm /etc/update-motd.d/10-uname
echo "Write old files   [-------    ] 60%"

echo "Write old files   [-----------] Done"
read  -n 1 -p "Enter Hostname:" hostname
hostnamectl set-hostname $hostname

