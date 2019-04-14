#!/bin/bash

#initialize variables
bro_intel_dir="/opt/bro/share/bro/site/intel/"
bro_intel_file=""
cont="a"
intel_type="0"
intel_type_str=""
intel_source=""
intel_desc=""
intel_indicator=""

#allow single line entry
if [ $# -eq 0 ]
then
	echo "No input file. Single entry mode selected."
	echo "Input the intel indicator to import"
	read intel_indicator
	cont="y"
fi	

#loop until an expected input is received
while [ "$cont" != "y" ] && [ "$cont" != "n" ]; do
	#ensure the right file was selected
	echo "Import intel from file $1? (y or n)"
	#read user input
	read cont
	#convert to lower in case upper was chosen
	cont="${cont,,}" 
done

if [ "$cont" = "y" ]
then
	#find out what kind of intel is being processed
	while [ "$intel_type" != "1" ] && [ "$intel_type" != "2" ] &&
	[ "$intel_type" != "3" ] && [ "$intel_type" != "4" ] &&
	[ "$intel_type" != "5" ] && [ "$intel_type" != "6" ] &&
	[ "$intel_type" != "7" ] && [ "$intel_type" != "8" ]; do
		
		echo "What type of intel is it?"
		echo "1.IP Addresses"
		echo "2.URLs"
		echo "3.Software Names"
		echo "4.Domain Names"
		echo "5.User Names"
		echo "6.File Hashes"
		echo "7.File Names"
		echo "8.Certificate Hashes"
		read intel_type
	done

	#Fill in the Bro intel type based on user input
	case "$intel_type" in
		"1")
			intel_type_str="Intel::ADDR"
			bro_intel_file="addr.intel"
			;;
		"2")
			intel_type_str="Intel::URL"
			bro_intel_file="url.intel"
			;;
		"3")
			intel_type_str="Intel::SOFTWARE"
			bro_intel_file="software.intel"
			;;
		"4")
			intel_type_str="Intel::DOMAIN"
			bro_intel_file="domain.intel"
			;;
		"5")
			intel_type_str="Intel::USER_NAME"
			bro_intel_file="user_name.intel"
			;;
		"6")
			intel_type_str="Intel::FILE_HASH"
			bro_intel_file="file_hash.intel"
			;;
		"7")
			intel_type_str="Intel::FILE_NAME"
			bro_intel_file="file_name.intel"
			;;
		"8")
			intel_type_str="Intel::CERT_HASH"
			bro_intel_file="cert_hash.intel"
			;;
	esac

	#Get the intel source
	while [ "$intel_source" = "" ]; do
		echo "Where is this intel from?(enter - if blank)"
		read intel_source
	done

	#Get the intel description
	while [ "$intel_desc" = "" ]; do
        	echo "Why are you uploading this intel?(enter - if blank)"
        	read intel_desc
	done

	#Write single command line entry to file
	if [ $# -eq 0 ]
	then
		echo -e "$intel_indicator\t$intel_type_str\t$intel_source\t$intel_desc$f" >> $bro_intel_dir$bro_intel_file
	
	else
		#Write the file
		sed "s/$/\t$intel_type_str\t$intel_source\t$intel_desc$f/" $1 >> $bro_intel_dir$bro_intel_file

		#Remove any DOS type line endings
		sed -i -e "s/\r//g" $bro_intel_dir$bro_intel_file
	fi
	echo "Restart the bro or broctl service for changes to take effect."
fi
