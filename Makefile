default: deploy

init:
#	- chmod +x ./config/init.d/*.sh
#	- sudo cp ./config/init.d/*.sh /etc/init.d

jq: 
	- ([ ! -f /usr/bin/jq ] && sudo apt-get install jq -y ) || echo jq is already installed

systemd: init jq
#	- sudo cp ./config/systemd/*.service /etc/systemd/system
#	- ./config/systemd/register.sh

deploy: systemd 
	- cp bin/*.sh ~/bin
	- chmod +x ~/bin/*.sh
