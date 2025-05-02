#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints address and coordinate outputs to output_tiger.csv
# Prerequisite: sudo apt install jq
# To run: 1) sudo chmod 777 addr_3.sh 2) sudo ./addr_3.sh

> output_tiger.csv
> log.txt
while read line
do
	line="${line/ USA/}" # removes USA from end of address
	line="${line/-[0-9][0-9][0-9][0-9]/}" # removes 4-digit zip extension

	echo -n "$line," | sed "s/\r//g"  >> output_tiger.csv
	nominatim search --query "$line" 2>>log.txt | jq '.[]' | jq -r --slurp '.[0] | [.lat, .lon] | @csv' >> output_tiger.csv
	
done < randad.csv 
