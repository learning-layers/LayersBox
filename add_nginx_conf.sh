#!/bin/bash
# This script serves to make a LayersBox Adapter aware of a new backend service.

if [ $# -le 1 ]
 then
	sn=$1
	echo "The new service is called '$sn' ."
	 elif [ $# -eq 0 ]
          then
		echo "No arguments passed to setup script. Aborting..."
		exit 1
 else
	echo "Too many service names specified! Aborting..."
	exit 1
fi

tc=/usr/local/openresty/conf
td=$tc/services
echo "The path for all service subdirectories is set to $td ."

out=$(docker ps -a | grep -c adapter-data)

if [ $out -gt 0 ]
 then
	echo "Adapter data container found. Checking whether the service has been added already..."
	nsv=$(docker exec adapter ls $tc)
	if [[ $nsv != *"services"* ]] 
	 then
	 	docker exec adapter mkdir -p $td/
	fi
	nsv=$(docker exec adapter ls $td)
	if [[ $nsv == *"$sn"* ]] 
	 then
	 	echo "Previous configuration detected. Deleting old configuration..."
		docker exec adapter rm -rf $td/$sn
		echo "Recreating path for new dir..."
	 else
		echo "No previous configuration for this service found. Proceeding with setup..."
		echo "Creating path for new dir..."
	fi

	docker exec adapter mkdir -p $td/$sn/

	sf="nginx.adapted.conf"
	if [ -f ./services/$sn/$sf ]
	 then
		echo "Service's nginx.adapted.conf found."
		echo "Copying service's nginx.adapted.conf to newly created path $nsv..."
		docker cp ./services/$sn/${sf} adapter-data:$td/$sn
	 else
		echo "No configuration file found! The file must be named 'nginx.adapted.conf'. Aborting..."
		exit 1
	fi

	echo "Finished."
fi
