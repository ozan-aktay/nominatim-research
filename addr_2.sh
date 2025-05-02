#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints address and coordinates to output_tiger.csv file
# Prerequisite: sudo apt install jq
# To run: 1) sudo chmod 777 addr_2.sh 2) sudo ./addr_2.sh

# Makes two new files for output and logging
> output_tiger.csv
> log.txt
while read line
do

	# The address (called 'line') is printed to the output file, followed by a comma and then the lat and lon values nominatim returned for the address
        # sed \r removes stray return carriage characters at end of line
        # 2>>log.txt redirects error output to log file
        # jq extracts lat and lon values from nominatim's json output then converts to csv style, the values are printed to output file following the address
        # command to install jq: sudo apt install jq

	echo -n "$line," | sed "s/\r//g"  >> output_tiger.csv
	nominatim search --query "$line" 2>>log.txt | jq '.[]' | jq -r --slurp '.[0] | [.lat, .lon] | @csv' >> output_tiger.csv
	
done < randad.csv 
