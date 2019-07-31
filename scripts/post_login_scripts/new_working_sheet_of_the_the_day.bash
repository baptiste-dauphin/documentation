#!/bin/bash

DIR=$1
FILE_OF_THE_DAY_LOCATION="$DIR/$(date +%Y_%m_%d.bash)"

if [[ -e $FILE_OF_THE_DAY_LOCATION ]]

then
	echo "file of the day $FILE_OF_THE_DAY_LOCATION already exists"
	echo "you can write on it !!!"
	echo "subl $FILE_OF_THE_DAY_LOCATION"
	exit 1

else 
	echo "Creation of $FILE_OF_THE_DAY_LOCATION"
	echo "you can :"
	echo "subl $FILE_OF_THE_DAY_LOCATION"
	exit 0
fi



