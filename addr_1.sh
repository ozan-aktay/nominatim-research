#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints full output to console
# To run script: 1) chmod 777 addr_1.sh 2) sudo ./addr_1.sh

while read line
do
	echo "$line"
	nominatim search --query "$line"

done < randad.csv 
