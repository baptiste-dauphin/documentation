#!/bin/bash
DEB_LINES=$(grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*)

for DEB_LINE in $DEB_LINES; do
	if [[ $DEB_LINE =~ ^http ]]
	then
		echo $DEB_LINE
	fi
done