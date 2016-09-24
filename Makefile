default: deploy

init:
#	- chmod +x ./config/init.d/*.sh
#	- sudo cp ./config/init.d/*.sh /etc/init.d

systemd: init
#	- sudo cp ./config/systemd/*.service /etc/systemd/system
#	- ./config/systemd/register.sh

deploy: systemd 
	- cp bin/*.sh ~/bin
	- chmod +x ~/bin/*.sh
