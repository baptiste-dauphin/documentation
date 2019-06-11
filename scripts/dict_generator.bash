#!/bin/bash

for i in {1..999}
do
   echo "appending :" "$1""$i" to dict.txt
   echo "$1""$i" >> dict.txt
done