#!/bin/bash
#eval $(ssh-agent)
echo "Qwant ssh key password : "
ssh-add /home/baptiste/.ssh/id_rsa/id_RSA_user

if [ $? -eq 0 ]; then
    echo -e "\e[92mSSH key correctly added"
else
    echo -e "\e[91mSSH key add has failed"
fi

echo "Personnal ssh key password : "
ssh-add /home/baptiste/Documents/unCloudable_for_Security/ssh_keypair_2019/id_RSA_user

if [ $? -eq 0 ]; then
    echo -e "\e[92mSSH key correctly added"
else
    echo -e "\e[91mSSH key add has failed"
fi
