#!/bin/bash
blueman-applet

if [ $? -ne 0 ]; then
    echo -e "blueman-applet failed to start"
else
