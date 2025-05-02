#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints address and coordinate outputs to output_tiger.csv
# Prerequisite: sudo apt install jq
# To run: 1) sudo chmod 777 addr_6.sh 2) sudo ./addr_6.sh

> output_tiger.csv
> log.txt

# Takes single address as input, formats address then calls nominatim, printing coordinate outputs to file
function calculate_coords {

	if ! [[ "$1" =~ 'PO BOX' ]]; then #ignores PO Box addresses
	# Extracts zip code component of address
	zip=""
	street=""
	if [[ "$1" =~ ^.+([0-9]{5}) ]]; then
		zip=${BASH_REMATCH[1]}
	fi

	# Extracts street component of address (house number plus street name)
	if [[ "$1" =~ ([a-zA-Z0-9 ]+)( RD | DR | PL | LN | CT | CIR | ST | AVE | PKWY | BLVD | WAY | LOOP | HWY | TRL | TER | HALL ) ]]; then
		street="${BASH_REMATCH[0]}"
	fi

	# Removes letters from house numbers (e.g. 346A Random St becomes 346 Random St)
	street=$(echo "$street" | perl -pe 's/(?<=[\d])[a-zA-Z]*(?=[ ])//')
	# Removes extra carriage characters
	street=$(echo "$street" | sed "s/\r//g")

	addr=$street$zip
	nom=$(nominatim search --street "$street" --postalcode "$zip" 2>>log.txt | jq '.[]' | jq -r --slurp '.[0] | [.lat, .lon] | @csv') #>> output_tiger.csv
	echo "$addr,$nom" >> output_tiger.csv
	
	fi
}

# Runs 8 parallel processes calling function with different addresses. Specific number of processes can be modified based on computer specs

while read -r line
do
	read -r line2
	read -r line3
	read -r line4
	read -r line5
	read -r line6
	read -r line7
	read -r line8
	calculate_coords "$line" &
	calculate_coords "$line2" &
	calculate_coords "$line3" &
	calculate_coords "$line4" &
	calculate_coords "$line5" &
	calculate_coords "$line6" &
	calculate_coords "$line7" &
	calculate_coords "$line8"
	wait
done < randad.csv 
