#!/bin/bash

DIR=$1
FILE_OF_THE_DAY_LOCATION="$DIR/$(date +%Y_%m_%d.bash)"


if [ "$#" -ne 1 ]
then
    echo "Illegal number of parameters"
    echo "you have to specify a directory where store working sheet !!!"
    echo "example : new_working_sheet_of_the_the_day /home/baptiste/Documents"
    exit 1
else
	if [[ -e $FILE_OF_THE_DAY_LOCATION ]]
	then
		echo "file of the day $FILE_OF_THE_DAY_LOCATION already exists"
		echo "Opening document..."
		subl $FILE_OF_THE_DAY_LOCATION
		exit 2
	else 
		echo "Creation of $FILE_OF_THE_DAY_LOCATION"
		touch $FILE_OF_THE_DAY_LOCATION
		echo "Opening document..."
		subl $FILE_OF_THE_DAY_LOCATION
		exit 0
	fi
fi




