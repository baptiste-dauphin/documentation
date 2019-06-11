#!/bin/sh

# Usage: ./crack-keepass.sh passwords.kdbx dict.txt
# 
# The dictionary file can be generated with:
# https://github.com/TimurKiyivinski/permutatify

while read i
do
	echo "====================================="
    echo "Using password: \"$i\""
    echo "$i" | keepassxc-cli ls $1 -q
    
    if [[ $? -eq 0 ]]; then
    	echo "###################"
    	echo "####  FOUND !!! ###"
    	echo "###################"
    	echo "Keepass entries : "
    	echo "$i" | keepassxc-cli show $1 $(echo "$i" | keepassxc-cli ls $1 -q) -q
    	exit 0
    else
    	echo "password: \"$i\" was incorrect"
    fi
done < $2