#!/bin/bash

str=''
cmds=(nmap wpscan)

main()
{
        echo ""
        echo ""
        echo "Welcome to lazyscript!"
        echo "by @porthunter"
        echo ""
        echo "Enter command or type --help"
        echo "Available commands: ${cmds[@]}"
}

next() 
{
	echo "Enter command..."
	read str
	if [[ $str != '' ]]
	then
	    if [[ $str == ${cmds[0]} ]]
	        then
	        	nmap_mod
	    elif [[ $str == '--help' ]]
	        then
	        	help_mod
	    else
	        	echo "Not a valid option" 
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
        nmap -sV -oN $domain -p 80 $domain
        clear
        echo "Analyzing nmap scan..."
		echo -n "What service are you looking for: "
		read serv
		clear
		echo "Looking for $serv"
		grep "open  $serv" $domain
		echo ""
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
		continue_wpscan $@
	else
		echo "Error: Directory wpscan does not exists, will now create directory."
		mkdir wpscan
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
    elif [[ $str == '--help' ]]
        then
        	help_mod
    else
        	echo "Not a valid option" 
	fi
fi
