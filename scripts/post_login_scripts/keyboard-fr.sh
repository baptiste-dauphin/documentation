#!/bin/bash
setxkbmap fr
if [ $? -eq 0 ]; then
    echo -e "\e[92mKeyboard correctly set in French"
else
    echo -e "\e[91mkeyboard set error"
fi