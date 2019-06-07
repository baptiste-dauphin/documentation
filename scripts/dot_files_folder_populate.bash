#!/bin/bash
#title           : dot_files_folder_populate.bash
#description     : This script will make copy all your specified dot file from your home in your backup folder.
#author 		 : Baptiste Dauphin
#date            : 8th june 2019
#version         : 0.1

set -e
export LANG=C

DOT_FILE_DESTINATION_FOLDER=~/git/documentation/dot_files
DOT_FILE_LIST=" \
.vimrc \
.zshrc \
.bashrc \
.bash_profile"

echo "======================================================================"
echo "dot file list : $DOT_FILE_LIST"
echo "will be copied in : $DOT_FILE_DESTINATION_FOLDER"
echo "======================================================================"
echo ""

for DOT_FILE in ${DOT_FILE_LIST[@]}
	do
		cp -v ~/"$DOT_FILE" "$DOT_FILE_DESTINATION_FOLDER"
	done
echo ""