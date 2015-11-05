#!/bin/bash
# This script serves to make a LayersBox Adapter aware of a new backend service.

if [ $# -le 1 ]
 then
	sn=$1
	echo "The new service is called $sn ."
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
	
	if [ -z "$osv"  ]
	 then 
		echo "No previous configuration for this service found. Proceeding with setup..."
	 else
		echo "Previous configuration detected. Deleting old configuration..."
		docker exec adapter rm -rf $osv
	fi
	
	docker exec adapter mkdir -p $nsv/
	echo "Copying service's nginx.conf to newly created path $nsv..."
	docker cp ./services/documentation/nginx.documentation.conf adapter-data:$nsv
	echo "Loading newly copied configuration..."
	docker kill --signal="HUP" adapter
	echo "Finished."
fi
