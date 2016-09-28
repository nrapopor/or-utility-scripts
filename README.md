# Orbital Rendersphere utility scripts

## Script list


| Name             | Description |
|:--- |:--- |
| compileDTB.sh             | The script used to compile the dtb that will be used at boot to enable the PRUs
| compileDTBLEDScape.sh     | The script used to compile the dtbo (overlay) that will be used at boot to enable LEDScape
| decompileDTB.sh           | The script used to de-compile the dtb that will be used at boot to enable the PRUs
| decompileDTBLEDScape.sh   | The script used to de-compile the dtbo (overlay) that will be used at boot to enable LEDScape (not used just here for completness)
| deployCAPE.sh             | The script used to add the compiled overlay to the capemgr initialization routine to enable this overlay at boot
| startRGBtest.sh           | The script used to run the x-display rgb-test command
| setupWiFi.sh              | The script used to configure the __connman__ service with a secure WiFi using wpa2 passphrase
| oracle-jdk-8.sh           | Install the latest version of JAVA JDK from Oracle
|listLEDScape.mapped.pins.sh   | list the LEDScape mappings currentlyused by x2-display

## Deployment instructions 

````sh 
cd ~/Code
git clone https://github.com/nrapopor/or-utility-scripts.git
cd or-utility-scripts
make
````     

## Complete x2-display deployment instructions 

### Bare Metal

The link I used for instructions to create the installation is [http://www.elinux.org/BeagleBoardUbuntu].     

The idea here is to run the OS from the card so that we can disable HDMI (both Video/Audio) and built in MMC   
This will leave us with the maximum number of free pins for the GPIO.


* Note: Apparently the BBB/Ubuntu team is using the "psychotic squirrel" storage mechanism for the ever important     
 "slots" file. For Ubuntu 16.04 it's in the /sys/devices/platform/bone_capemgr/slots. This apparently     
 keeps changing and is no guarantee to still be there after any patch. find it with:     
  
  ````sh
  sudo find /sys/devices -name "slots"
  ````
 this will needed for instructions like 

  ````sh      
  sudo sh -c "echo '<name>' > /sys/devices/platform/bone_capemgr/slots"``
  ````

#### BeagleBoneBlack installation/configuration
1.  Use the instruction for the prebuilt image to install and boot the OS on the BBB.
2.  Do all the normal initial setup stuff
 1. Create the "Code" folder in the ubuntu user home directory
 2. Setup no-password sudo
 2. Run (these will be needed later)
  ````sh
  sudo apt-get update
  sudo apt-get install usbmount git build-essential python vim -y
  ````
 3. Set the static IP      
  * All the following instructions assume 192.168.1.36
 4. Setup ssh for no-login access. Hint : ssh-copy-id is your friend and is available for `cygwin` as well as on all the *nix systems
 5. Rename the box ( render3b ) for some reason this was kinda ugly
 
  * in addition to the changing the ``/etc/hosts`` line for 127.0.1.1 to     
   ````sh
   127.0.1.1	render3b.makerbar.com	render3b.localdomain	render3b
   ````
	 
  * I had to modify the `/etc/sysctl` file and `/etc/hostname`
	
   ````sh
   sudo echo render3b | sudo tee -i /etc/hostname
   sudo echo "kernel.domainname = makerbar.com" | sudo tee -a /etc/sysctl.conf 
   sudo echo "kernel.hostname = render3b" | sudo tee -a /etc/sysctl.conf
   ````

##### Deploy Software

Checkout (or unzip) the following into the `~/Code` and `~/bin` folders     


###### Deploy the helper scripts into ~/bin folder

 ````sh 
 cd ~/Code
 git clone https://github.com/nrapopor/or-utility-scripts.git
 cd or-utility-scripts
 make
 ````

Create the soft links (helper scripts expect them to be there) dont worry that the    
source for the links does exist yet ... 
	
 ````sh 
 ln -s ~/Code/LEDScape ~/LEDScape
 ln -s ~/Code/Orbital-Rendersphere/x2-display ~/x2-display
 ````

###### Deploy bb.org-overlays     

 ````sh 
 cd ~/Code
 git clone https://github.com/beagleboard/bb.org-overlays
 cd ./bb.org-overlays
 ````
1.	Follow the instructions in the __README.md__ to:
    1. Update the dtc compiler
    2. Update the kernel
    3. Reboot && and connect using ssh (if you done everything correctly to this point this will work)
   ````sh
   ssh ubuntu@192.168.1.36 
   ````
 4. Follow the instruction for the _compatibility issues_ section to enable the dtb for     
      __BeagleBone Black: HDMI (Audio/Video)/eMMC disabled:__
 5. __NOTE:__     I expect the correct dtb name to be `/boot/dtbs/$(uname -r)/am335x-boneblack-overlay.dtb`     
      if it is not modify the `~/bin/decompileDTB.sh` and `~/bin/compileDTB.sh` change the line:     
      to the new base name ...
 ````sh
 DTB_NAME=am335x-boneblack-overlay
 ````
2. Run the `decompileDTB.sh` script (one of the helper scripts) it will decompile the `dtb`    
     to `dts` and will echo the `dts` name. edit the `dts` to enable the PRUs:     
     Search for `pruss@4a300000` and then under it change:
    ````sh 
    status = "disabled";
        to
    status = "okay";
    ````
    
3. Run the `compileDTB.sh` script (one of the helper scripts) it will re-compile the `dtb`     
     and put it where it belongs (there will be a new `~/dtb_backups` directory that will
     have all the backups needed for recovery ...

###### LEDScape
1. get and compile the base code ... 
 ````sh 
 cd ~/Code
 sudo git clone http://github.com/osresearch/LEDscape.git
 cd LEDscape
 sudo make
 ````
 
 2. Then buidland deploy the extra overlay for the LEDScape (we may need to tweak it for pins we will need to use)
 ````sh
 cd ~/LEDscape/dts
 compileDTBLEDScape.sh cape-bone-octo.dts  CAPE-BONE-OCTO-00A0.dtbo
 sudo cp CAPE-BONE-OCTO-00A0.20160916-234215-082.dtbo /lib/firmware/CAPE-BONE-OCTO-00A0.dtbo
 echo CAPE-BONE-OCTO | sudo tee -a /sys/devices/platform/bone_capemgr/slots
 cat /sys/devices/platform/bone_capemgr/slots 
 ````
 * Test your work
 ````sh
 cd ~/LEDScape
 sudo bin/identify 
 ````
 
 3. Last make it get enabled at boot
 ````sh
 deployCape.sh -c CAPE-BONE-OCTO
 ````

###### Orbital-Rendersphere
 ````sh
 cd ~/Code
 TODO: add the git command for the Rendersphere code
 cd Orbital-Rendersphere/x2-display
 make
 sudo test-rgb
 ````

###### Configure WiFi (TP-Link -- TI-WN823N)
1. Checkout the Dirver

 ````sh
 cd ~/Code
 git clone https://github.com/pvaret/rtl8192cu-fixes.git
 ````
 
2. Read the README.md for the project
 a. Alter the instructions as follows 
   Run this __apt-get__ installation command instead (we already installed build-essential and git):
 ````sh
 sudo apt-get install linux-headers-$(uname -r) dkms
 ````
 b. Follow the rest of the instructions
 c. Disable power management for wifi
  ````sh
  echo ACTION==\"add\", SUBSYSTEM==\"net\", KERNEL==\"wlan\*\" RUN+=\"/usr/sbin/iw dev %k set power_save off\"| tee -i /etc/udev/rules.d/wifi_powersave_off.conf
  ````
 d. Configure connman for your wireless network (assuming secure network)
  ````sh
  sudo connmanctl
  connmanctl> Enable wifi
  connmanctl> scan wifi
  connmanctl> services
  <list of services>
  connmanctl> agent on
  connmanctl> connect wifi_<adapter_MAC>_managed_psk  (or connect wifi_<adapter_MAC>_hidden_managed_psk)
  Agent RequestInput wifi_<adapter_MAC>_hidden_managed_psk
    Name = [ Type=string, Requirement=mandatory, Alternates=[ SSID ] ]
    SSID = [ Type=ssid, Requirement=alternate ]
    Passphrase = [ Type=psk, Requirement=mandatory ]
  Hidden SSID name? enter the ssid of the hidden network
  Passphrase? enter the passphrase of the hiddent network
  Connected wifi_<adapter_MAC>_hidden_managed_psk
  connmanctl> services
  *AO Wired                ethernet_<adapter_MAC>_cable
  *AR <your ssid>          wifi_<adapter_MAC>_<hotspot1_MAC>_managed_psk
  ...
  connmanctl> exit

  cd /var/lib/connman
  #set your own values for the ipv4/nameservers settings:
  setupWiFi.sh -s wifi_<adapter_MAC>_<hotspot1_MAC>_managed_psk -p <your passphraze> -n <your ssid> \
  --ipv4 192.168.1.136/255.255.255.0/192.168.1.1 --nameservers 8.8.8.8,8.8.4.4
  ````

  ````sh
  connmanctl enable wifi
  connmanctl scan wifi
  connmanctl connect $(onnmanctl services | grep -E "\*A[^O].*wifi_" | tr -s ' ' | cut -d ' ' -f 3)
  ````


## Author and Legal information

### Author

Nick Rapoport

### Copyright

Copyright&copy;  2016 Nick Rapoport -- All rights reserved (free 
for non-comercial duplication under the GPLv2)

### License 
GPLv2

#### Date
2016-09-17
