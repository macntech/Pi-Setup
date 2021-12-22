# Pi Setup

![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg) ![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg) ![Made for Raspberry](https://img.shields.io/badge/-Raspberry%20Pi-C51A4A) 

Pi Setup is a simple bash script is to make the setup of a Raspberry Pi more comfortable. It's no alternative to the official **raspi-config** tool but could simplify and shorten specific initial setup. It was designed and created because I am using a lot of Raspberry Pis as a small server stack (like a Raspberry datacenter :computer: ) and initialize Pis regullary where different setup steps are necessary. This script just makes my (and maybe yours) life easier :nerd_face: 

## Usage :dizzy:
You have two options to use this script. First you need SSH access to your Raspberry: Once you flashed your SD card with Raspberry OS, you should create an empty file named "SSH" on your SD card. 

To use this script just download the script from **Github** directly in your SSH session after you boot the raspberry OR download the script before and copy it to your SD card. Run as initial user **pi**

```
wget https://github.com/macntech/Pi-Setup/archive/master.zip
unzip master.zip
cd ./Pi-Setup-master
sudo bash Installer.sh

```
Alternative you can also just git clone this repo (but you must install git first on a fresh Pi with apt-get install git)
```
git clone https://github.com/jgeisslinger/Pi-Setup.git
cd ./Pi-Setup
sudo bash Installer.sh

```

## Features :bulb:
With this script the following steps are done via whiptail:

* Clean all non needed start scripts from standard Pi installer
* Set a new **hostname**
* Set a **static network address**, **gateway** and **domain** (optional)
* Enable **root ssh** access and create new password (optional)
* Setup new **SSH login screen** panel as shown below
* Prepare **128x64 OLED Display** with standard information (see Example)

## Examples :mag:
New boot screen once you login to your Raspberry:

![New Boot Screen](https://s3.eu-central-1.wasabisys.com/gwce.public/newssh.png)

Menu when entering the setup tool:

![New Start Screen](https://s3.eu-central-1.wasabisys.com/gwce.public/startscreen.png)

## Tasklist for future Features :spiral_notepad:
I have some more tasks in mind that could be automated by the script in the future:
- [ ] Setup new Pi password to supress SSH warning
- [ ] Enable I2C and SPI interface directly
- [ ] Clear install files after setup completed
- [ ] Better Error handling 
  

## Credits :thumbsup:
The script is just a wrapper on various parts I found during my work on Raspberry Datacenter. Credits go to especially:

* **SSH boot screen** is a modified version of a script made by Sebastian from @[indiBit](https://github.com/indiBit)
* **I2C Pyhton** is a modified version of a script made by @[SliderBOR](https://github.com/SliderBOR)
* Some snippets from **raspi-config** tool are re-used in this script
