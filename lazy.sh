#!/bin/bash

str=''
cmds=(whois dnsrecon harvester nmap wpscan)

init()
{
        echo #Newline
        echo -e "Welcome to \e[31mLAZYSCRIPT!"
        echo -e "\e[0mby @porthunter"
        echo #Newline
     	echo "╠╬╬╬╣"
		echo "╠╬╬╬╣ WARNING! MISUSE OF THIS SCRIPT AND THE TOOLS"
		echo "╠╬╬╬╣ INCLUDED CAN LAND YOU IN JAIL!!"
		echo "╚╩╩╩╝"
		echo #Newline
        
}
run() 
{
	echo -e "[i] Enter command or type --help"
    echo -e "[i] Available commands: ${cmds[@]}"
	read str
	nav $str	
}
help_mod()
{
	echo ""
	echo "LAZYSCRIPT HELP"
	echo "    LAZYSCRIPT COMMANDS"
	echo "        ${cmds[0]}: run nmap scan on a specified domain or IP"
	echo "        ${cmds[1]}: run wpscan"
	echo "        --help: display this menu"
	run
}

whois_mod()
{
	echo "Enter target..."
    read domain
    whois $domin
}
dnsrecon_mod()
{
	echo "Enter target..."
    read domain
    ./dnsrecon.py -d $domain -t brt > domains.txt
    cat domains.txt
    run
}
harvester_mod()
{
	echo "Enter target..."
    read domain
    theharvester -d $domain -b all
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
		echo #Newline
		echo "Website appears to be running Wordpress"
		echo "Do you want to run wpscan? (y/n)"
		read answer
		clear
		if [[ $answer == 'y' ]]
        then
        	wpscan_mod $domain
        else
        	run
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
	run
}

nav()
{

	if [[ $@ != '' ]]
	then
	    if [[ $@ == ${cmds[0]} ]]
	        then
	        	whois_mod
	    elif [[ $@ == ${cmds[1]} ]]
	        then
	        	dnsrecon_mod
	    elif [[ $@ == ${cmds[2]} ]]
	        then
	        	harvester_mod
	    elif [[ $@ == ${cmds[3]} ]]
	        then
	        	nmap_mod
	    elif [[ $@ == ${cmds[4]} ]]
	        then
	        	wpscan_mod
	    elif [[ $@ == '--help' ]]
	        then
	        	help_mod
	    else
	    		echo #Newline
	    		echo "████▌▄▌▄▐▐▌█████"
				echo "████▌▄▌▄▐▐▌▀████"
	        	echo "[!] Not a valid option"
	        	echo #Newline
	        	run
		fi
	fi
}

init
run