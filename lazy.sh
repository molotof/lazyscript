#!/bin/bash

str=''
cmds=(nmap wpscan)

main()
{
        echo #Newline
        echo -e "\e[34m║║╔║║╔╗ ║"
		echo "╠╣╠║║║║ ║"
		echo "║║╚╚╚╚╝ O"
		echo -e "\e[0m"
        echo #Newline
        echo -e "Welcome to \e[31mLAZYSCRIPT!"
        echo -e "\e[0mby @porthunter"
        echo #Newline
        echo -e "[i] Enter command or type --help"
        echo -e "[i] Available commands: ${cmds[@]}"
}

next() 
{
	echo -e "[i] Enter command or type --help"
	read str
	if [[ $str != '' ]]
	then
	    if [[ $str == ${cmds[0]} ]]
	        then
	        	nmap_mod
	    elif [[ $str == ${cmds[1]} ]]
	        then
	        	wpscan_mod
	    elif [[ $str == '--help' ]]
	        then
	        	help_mod
	    else
	    		echo #Newline
	    		echo "████▌▄▌▄▐▐▌█████"
				echo "████▌▄▌▄▐▐▌▀████"
	        	echo "[!] Not a valid option"
	        	echo #Newline
	        	next
		fi
	fi
}

help_mod()
{
	echo ""
	echo "LAZYSCRIPT HELP"
	echo "    LAZYSCRIPT COMMANDS"
	echo "        ${cmds[0]}: run nmap scan on a specified domain or IP"
	echo "        ${cmds[1]}: run wpscan"
	echo "        --help: display this menu"
	next
}
nmap_mod() 
{
		echo "Enter target..."
     	read domain
     	echo #Newline
     	echo "╠╬╬╬╣"
		echo "╠╬╬╬╣ YO, WARNING! MISUSE OF THIS TOOL"
		echo "╠╬╬╬╣ CAN LAND YOU IN JAIL!!"
		echo "╚╩╩╩╝"
		echo #Newline
        nmap -sV -oN $domain -p 80 $domain
        clear
        echo "Analyzing nmap scan..."
		echo -n "What service are you looking for: "
		read serv
		clear
		echo "Looking for $serv"
		grep "open  $serv" $domain
		echo #Newline
		echo "Website appears to be running Wordpress"
		echo "Do you want to run wpscan? (y/n)"
		read answer
		clear
		if [[ $answer == 'y' ]]
        then
        	wpscan_mod $domain
        else
        	next
		fi
}

# WPSCAN MODULE
# Launch WP SCAN against identfied Wordpress installs
wpscan_mod()
{
	echo "Scanning, please be patient, this may take some time."
	if [ -d "wpscan" ]
	then
		echo "Directory wpscan exists. Continuing..."
	else
		echo "Error: Directory wpscan does not exists, will now create directory."
		mkdir wpscan
	fi
	if [[ $@ == '' ]]
        then
        	echo "Enter domain:"
        	read domain
        	continue_wpscan $domain
        else
			continue_wpscan $@
	fi
}
continue_wpscan()
{
	/opt/wpscan/wpscan.rb -u $@
	echo "Finished wp scan..."
	clear
	next
}

main
read str

if [[ $str != '' ]]
then
	if [[ $str == ${cmds[0]} ]]
	    then
	        nmap_mod
	elif [[ $str == ${cmds[1]} ]]
	    then
	       	wpscan_mod
	elif [[ $str == '--help' ]]
	    then
	        help_mod
	else
			echo #Newline
			echo "████▌▄▌▄▐▐▌█████"
			echo "████▌▄▌▄▐▐▌▀████"
	        echo "[!] Not a valid option"
	        echo #Newline
	        next
	fi
fi
