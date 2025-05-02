#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints address and coordinate outputs to output_tiger.csv
# Prerequisite: sudo apt install jq
# To run: 1) sudo chmod 777 addr_4.sh 2) sudo ./addr_4.sh

> output_tiger.csv
> log.txt
while read line
do
	if ! [[ "$line" =~ 'PO BOX' ]]; then #ignores PO Box addresses
	line="${line/ USA/}" # removes USA from end of address
	line="${line/-[0-9][0-9][0-9][0-9]/}" # removes 4-digit zip code extension

	# removes APT, STE, UNIT from addresses along with unit number
	line=$(echo "$line" | sed "s/ APT [a-zA-Z0-9]*//")
	line=$(echo "$line" | sed "s/ STE [a-zA-Z0-9]*//")
	line=$(echo "$line" | sed "s/ UNIT [a-zA-Z0-9]*//")
	echo -n "$line," | sed "s/\r//g"  >> output_tiger.csv
	nominatim search --query "$line" 2>>log.txt | jq '.[]' | jq -r --slurp '.[0] | [.lat, .lon] | @csv' >> output_tiger.csv
	fi
done < randad.csv 
