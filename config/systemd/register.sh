#!/bin/bash
for i in $(ls ./config/systemd/*.service); do 
	sudo systemctl enable $(basename $i)  
done
