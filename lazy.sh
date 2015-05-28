#!/bin/bash

str=''

function main
{
        echo "Welcome to lazyscript!"
        echo "--help: type this command to show help menu"
}

function next 
{
	echo "Enter command..."
	read str
	if [[ $str != '' ]]
	then
	    if [[ $str == '--nmap' ]]
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

function help_mod
{
	echo "LAZYSCRIPT HELP"
	echo "    LAZYSCRIPT COMMANDS"
	echo "        --nmap: run nmap scan on a specified domain or IP"
	echo "        --wpscan: run wpscan"
	echo "        --help: display this menu"
	next
}
function nmap_mod 
{
		echo "Enter target..."
     	read domain
        nmap -sV -oN $domain -p 80 $domain
        echo "Analyzing nmap scan..."
		echo -n "What service are you looking for: "
		read serv
		echo "Looking for $serv"
		grep "open  $serv" $domain
		echo "Website appears to be running Wordpress, launching wpscan..."
		echo "Do you want to run wpscan? (y/n)"
		read answer
		if [[ $answer == 'y' ]]
        then
        	wpscan_mod
        else
        	next
		fi
}
function wpscan_mod
{
	echo "Scanning, please be patient, this may take some time."
	if [ -d "wpscan" ]
	then
		echo "Directory wpscan exists. Continuing..."
	else
		echo "Error: Directory wpscan does not exists, will now create directory."
		mkdir wpscan
	fi
	/opt/wpscan/wpscan.rb -u $domain
	echo "Finished wp scan..."
	next
}

main
read str

if [[ $str != '' ]]
then
    if [[ $str == '--nmap' ]]
        then
        	nmap_mod
    elif [[ $str == '--help' ]]
        then
        	help_mod
    else
        	echo "Not a valid option" 
	fi
fi
