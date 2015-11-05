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

td=/usr/local/openresty/conf/services
echo "The path for all service subdirectories is set to $td ."

out=$(docker ps -a | grep -c adapter-data)

if [ $out -gt 0 ]
 then
	echo "Adapter data container found. Checking whether the service has been added already..."
	nsv=$td/documentation
	osv=$(docker exec adapter ls $nsv)	
	
	if [ -z $osv  ]
	 then 
		echo "No previous configuration for this service found. Proceeding with setup..."
		echo "Creating path for new dir..."	
	 else
		echo "Previous configuration detected. Deleting old configuration..."
		docker exec adapter rm -rf $osv
		echo "Recreating path for new dir..."	
	fi

	docker exec adapter mkdir -p $nsv/

	sf="nginx.${sn}.conf"
	if [ -f ./services/$sn/$sf ] 
	 then 
		echo "Service's nginx.conf found."
		echo "Copying service's nginx.conf to newly created path $nsv..."
		docker cp ./services/documentation/${sf} adapter-data:$nsv
	 else
		echo "No configuration file found! The file must be named 'nginx.conf'. Aborting..."
		exit 1
	fi

	echo "Loading newly copied configuration..."
	docker kill --signal="HUP" adapter
	echo "Finished."
fi
