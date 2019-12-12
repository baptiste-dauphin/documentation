#!/usr/bin/env bash
set -e

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
	../get_remote_apt_reposotires_url.bash;
	display_separator
};

function list_upgradable(){
	display 'Here are a list of upgradable packages'
    apt list --upgradable;
    display_separator
};

function patching(){
    # sudo specified because this was from my bootstrap script for an
    # ec2 instance remove the sudos as previously stated if you are 
    # going to exec it from your current shell
    display 'Running upgrade of all your packages (including linux version)'
    sudo apt-get update -y;
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y;
    display_separator
};


# main
print_apt_repositories;
list_upgradable;
patching;