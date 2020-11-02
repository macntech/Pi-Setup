## Raspberry Pi Setup Script

[![Maintenance(https://img.shields.io/badge/Maintained%3F-yes-green.svg)]

This simple bash script is to make some tasks to setup a Raspberry Pi more comfortable. It was created because I am using a lot of Raspberry Pis as a small server stack (like a Raspberry datacenter :computer:) and initialize Raspberry Pis regullary where different setup steps are necessary. This script just makes life easier :nerd_face: 

## Usage :dizzy:
To use this script just download the script and run as initial user pi

```
wget https://github.com/jgeisslinger/Pi-Setup/archive/master.zip
unzip master.zip
cd ./Pi-Setup-master
sudo Installer.sh

```

## Features :bulb:
In this script the following can be done:

* Clean all non needed start scripts from standard installer
* Set a hostname
* Set a static network address (optional)
* Enable root ssh access (optional)
* Setup new login screen as shown below
* Prepare I2C Display with standard information (see Example)

## Examples :mag:
New boot screen once you login to your Raspberry:


## Credits :thumbsup:
The script is based on various parts I found during my work on Raspberry Datacenter. Credits go to:

* **Boot Screen** is a modified version of 
* I2C Display Phyton script is based on 
