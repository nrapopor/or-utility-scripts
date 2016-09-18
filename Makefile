default: deploy

deploy:
	- cp bin/*.sh ~/bin
	- chmod +x ~/bin/*.sh