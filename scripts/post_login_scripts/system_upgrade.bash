#!/usr/bin/env bash
set -e

DIR="$(dirname "$0")"

function display () {
	echo "---------------------------------------------"
	echo "[+]  $1"
	echo "---------------------------------------------"
	echo ""
} 

function display_separator () {
	echo ""
	echo "---------------------------------------------"
	echo ""
} 

function print_apt_repositories(){
	display 'Here are your configured APT repositories'
	$DIR/../get_remote_apt_reposotires_url.bash;
	display_separator
};

function list_upgradable(){
	display 'Here are a list of upgradable packages'
	display_separator
    apt list --upgradable;
    display_separator
    sudo apt-get update -y;
    display_separator
};

function upgrade(){
    # sudo specified because this was from my bootstrap script for an
    # ec2 instance remove the sudos as previously stated if you are 
    # going to exec it from your current shell
    display 'Running upgrade of all your packages (including linux version)'
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y;
    display_separator
};

function auto_remove(){
	display 'Clearing all your useless packages'
	sudo apt autoremove;
}


# main
print_apt_repositories;
list_upgradable;
upgrade;
auto_remove;