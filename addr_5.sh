#!/usr/bin/bash

# Reads addresses from randad.csv and feeds them into nominatim to obtain coordinates
# Prints address and coordinate outputs to output_tiger.csv
# Prerequisite: sudo apt install jq
# To run: 1) sudo chmod 777 addr_5.sh 2) sudo ./addr_5.sh

> output_tiger.csv
> log.txt
while read line
do
	if ! [[ "$line" =~ 'PO BOX' ]]; then #ignores PO Box addresses
	line="${line/ USA/}" # Removes USA from end of address
	line="${line/-[0-9][0-9][0-9][0-9]/}" # Removes 4-digit zip code extension

	# Removes APT, STE, UNIT from address along with unit number
	line=$(echo "$line" | sed "s/ APT [a-zA-Z0-9]*//")
	line=$(echo "$line" | sed "s/ STE [a-zA-Z0-9]*//")
	line=$(echo "$line" | sed "s/ UNIT [a-zA-Z0-9]*//")

	# Removes city/state from address, relies only on zip code.  Technically removes everything after the street suffix (e.g. RD, DR, ST) but before the zip code
	line=$(echo "$line" | perl -pe 's/(?:(?<= RD )|(?<= DR )|(?<= PL )|(?<= LN )|(?<= CT )|(?<= CIR )|(?<= ST )|(?<= AVE )|(?<= PKWY )|(?<= BLVD )|(?<= WAY )|(?<= LOOP )|(?<= HWY )|(?<= TRL )|(?<= TER )|(?<= HALL )).*(?=[0-9][0-9][0-9][0-9][0-9])(?!.* RD )(?!.* DR )(?!.* PL )(?!.* LN )(?!.* CT )(?!.* CIR )(?!.* ST )(?!.* AVE )(?!.* PKWY )(?!.* BLVD )(?!.* WAY )(?!.* LOOP )(?!.* HWY )(?!.* TRL )(?!.* TER )(?!.* HALL )//')
	
	# Removes letters from house numbers (e.g. 346A Random St becomes 346 Random St)

	line=$(echo "$line" | perl -pe 's/(?<=[\d])[a-zA-Z]*(?=[ ])//')
	echo -n "$line," | sed "s/\r//g"  >> output_tiger.csv
	nominatim search --query "$line" 2>>log.txt | jq '.[]' | jq -r --slurp '.[0] | [.lat, .lon] | @csv' >> output_tiger.csv
	fi
done < randad.csv 
