addr_1.sh is a Linux-based bash script that takes a list of addresses (stored in randad.csv) and inputs them into nominatim to return address coordinates.  The address along with full nominatim output is printed to the console.  

Prerequisites: nominatim must be installed along with the appropriate dataset, and nominatim should be configured to work through the command line

addr_2.sh is similar to addr_1.sh, but extracts only the lat/lon coordinate fields from the nominatim output.  The address along with its coordiantes are outputted as a csv file.  May need to install jq first: sudo apt install jq 

addr_3.sh is the same as addr_2.sh, but also removes the 4-digit zip code extension along with country name (USA only) from inputted address before passing into nominatim.  It also ignores PO Box addresses.

addr_4.sh removes the 4-digit zip extension, country name (USA only), and the words APT, SUITE, UNIT along with the unit number before inputting to nominatim.  It also ignores PO Box addresses.

addr_5.sh does everything that addr_4.sh does, but it also removes the city and state names from the address, relying on the zip code to locate the city.  This can lead to more accurate results.  Additionally, it removes letters from house (street) numbers (e.g. 345A becomes 345).

addr_6.sh extracts the zip code and street address (house number plus street name) portions of address and passes them independently to nominatim.  It also runs nominatim using 8 parallel process, reducing computation time to one-fifth the original time (or almost 10 queries per second) on an 8-core processor at 3.7 GHz and 32GB of RAM.
