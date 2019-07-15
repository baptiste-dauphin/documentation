#!/bin/bash
pulseaudio --start
if [ $? -eq 0 ]; then
    echo -e "\e[92mpulseaudio correctly started "
else
    echo -e "\e[91mpulseaudio failed to start"
fi