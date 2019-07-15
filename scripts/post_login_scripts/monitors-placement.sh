#!/bin/bash
xrandr --output DP-1 --auto --right-of eDP-1
if [ $? -eq 0 ]; then
    echo -e "\e[92mfirst screen corretly swap"
else
    echo -e "\e[91mxrandr error"
fi
xrandr --output HDMI-1 --auto --right-of DP-1
if [ $? -eq 0 ]; then
    echo -e "\e[92msecond screen corretly swap"
else
    echo -e "\e[91mxrandr error"
fi
