#!/usr/bin/env bash
set -e

list_upgradable(){
    apt list --upgradable;
};

patching(){
    # sudo specified because this was from my bootstrap script for an
    # ec2 instance remove the sudos as previously stated if you are 
    # going to exec it from your current shell
    sudo apt-get update -y;
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y;
};

list_upgradable;
patching;