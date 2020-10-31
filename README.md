## Raspberry Pi Setup Script

This simple script just makes some tasks to setup a Raspberry Pi automatically. It was created because I am using a lot of Raspberry Pis as a small server stack (like a Raspberry datacenter :computer:) and initialize Raspberry Pis regullary. This just makes life easier :nerd_face:

## Usage :dizzy:
To use this script just run as pi

```
wget https://github.com/jgeisslinger/Pi-Setup/archive/master.zip
unzip master.zip
cd ./Pi-Setup-master
sudo Installer.sh

```

## Content :bulb:
In this script the following happen:

* Clean all non needed start scripts
* Set a hostname
* Set a static address
* Setup new login screen as shown below
* Enable root ssh access

