#!/bin/zsh
swayidle\
	timeout 300 'grim /home/traxys/blur.png;
				convert -resize 40% /home/traxys/blur.png /home/traxys/blur.png; 
				 swaylock -i /home/traxys/blur.png' \
	timeout 600 'swaymsg "output * dpms off"' \
	resume 'rm /home/traxys/blur.png; swaymsg "output * dpms on"' \
	before-sleep 'swaylock -c 000000' \

