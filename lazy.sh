#!/bin/bash

str=''
cmds=(menu whois dnsrecon harvester nmap wpscan cupp)

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
	echo -e "[i] Enter module name or type --help for details and menu to see the main menu again"
    echo -e "[i] Available modules: ${cmds[@]}"
	read str
	nav $str	
}
menu_mod()
{
	echo "Select an option..."
	echo #NewLine
	echo "1) Fully Automated"
	echo "2) Basic Automation"
	echo "3) No Automation"
	echo "4) Automated, but make it look like I'm working, the boss is around!"
	echo "5) Impress my friends"
	echo "6) Run a module on it's own"
	echo #Newline
	read option
	if [[ $option == '1' ]]
	    then
	    	echo "Enter domain or IP..."
	    	read domain
	       	automated $domain
    elif [[ $option == '2' ]]
		then
		    basic
	elif [[ $option == '3' ]]
		then
		    manual
	elif [[ $option == '4' ]]
		then
		    lazy
	elif [[ $option == '5' ]]
		then
		    leet
	elif [[ $option == '6' ]]
		then
		    run
    else
        run
	fi
}

cmds=(menu whois dnsrecon harvester nmap wpscan cupp)

help_mod()
{
	echo ""
	echo "LAZYSCRIPT HELP"
	echo "    LAZYSCRIPT COMMANDS"
	echo "        ${cmds[0]}: show the main menu"
	echo "        ${cmds[1]}: check who owns/registered a domain/IP"
	echo "        ${cmds[2]}: dnsrecon time motherfucker"
	echo "        ${cmds[3]}: Rape the search engines with harvester"
	echo "        ${cmds[4]}: run nmap scan on a specified domain or IP"
	echo "        ${cmds[5]}: that shit runs WP? Scan it!"
	echo "        ${cmds[6]}: Cupp, generate custome password lists for bruteforce"
	echo "        --help: display this menu"
	run
}

whois_mod()
{
	
    if [[ $@ == '' ]]
        then
        	echo "Enter target..."
    		read domain
    		whois $domain
        else
			whois $@
		fi
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
		if [[ $@ == '' ]]
        then
        	echo "Enter domain:"
        	read domain
        	nmap -sV -oN $domain -p 80 $domain
        else
			nmap -sV -oN $domain -p 80 $@
		fi
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
	./wpscan.rb -u $@ | tee $@.txt
	echo "Finished wp scan..."
	clear
	run
}

cupp_mod()
{
	python arsenal/cupp-master/cupp.py
	run
}

automated()
{
	whois_mod $@
	nmap_mod $@
	wpscan_mod $@
	dnsrecon_mod $@
	harvester_mod $@
}
basic()
{
	echo "Works"
	run
}
manual()
{
	echo "Works"
	run
}
lazy()
{
	echo "Works"
	run
}
leet()
{
	echo "Enter IP"
	read ip
	echo "Connecting to $ip..."
	echo "Enter Mod Security bypass"
	read mod_sec
	echo "System cracked...now decrypting full drive."
	echo "Estimated time, 3 mins"
	run
}

nav()
{

	if [[ $@ != '' ]]
	then
	    if [[ $@ == ${cmds[0]} ]]
	        then
	        	menu_mod
	    elif [[ $@ == ${cmds[1]} ]]
	        then
	        	whois_mod
	    elif [[ $@ == ${cmds[2]} ]]
	        then
	        	dnsrecon_mod
	    elif [[ $@ == ${cmds[3]} ]]
	        then
	        	harvester_mod
	    elif [[ $@ == ${cmds[4]} ]]
	        then
	        	nmap_mod
	    elif [[ $@ == ${cmds[5]} ]]
	        then
	        	wpscan_mod
	    elif [[ $@ == ${cmds[6]} ]]
	        then
	        	cupp_mod
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
menu_mod