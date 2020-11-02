## Raspberry Pi Setup Script

![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg) ![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg) ![Made for Raspberry](https://img.shields.io/badge/-Raspberry%20Pi-C51A4A) 

This simple bash script is to make the setup of a Raspberry Pi more comfortable. It's no alternative to the official **raspi-config** tool but could simplify and shorten specific setup. It was customized and created because I am using a lot of Raspberry Pis as a small server stack (like a Raspberry datacenter :computer: ) and initialize Pis regullary where different setup steps are necessary. This script just makes life easier :nerd_face: 

## Usage :dizzy:
To use this script just download the script from **Github** and run as initial user **pi**

```
wget https://github.com/jgeisslinger/Pi-Setup/archive/master.zip
unzip master.zip
cd ./Pi-Setup-master
sudo bash Installer.sh

```

## Features :bulb:
With this script the following steps are done via whiptail:

* Clean all non needed start scripts from standard Pi installer
* Set a new **hostname**
* Set a **static network address** (optional)
* Enable **root ssh** access (optional)
* Setup new **ssh login screen** as shown below
* Prepare **I2C Display** with standard information (see Example)

## Examples :mag:
New boot screen once you login to your Raspberry:


## Credits :thumbsup:
The script is just a wrapper on various parts I found during my work on Raspberry Datacenter. Credits go to especially:

* **Boot Screen** and **I2C Pyhton** are modified versions of scripts made by Sebastian from 
* Some snippets from **raspi-config** tool are re-used
