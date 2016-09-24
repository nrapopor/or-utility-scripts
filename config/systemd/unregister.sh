#!/bin/bash
for i in $(ls ./config/systemd/*.service); do 
	sudo systemctl disable $(basename $i)  
done
