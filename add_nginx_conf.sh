#!/bin/bash
# This script serves to make a LayersBox Adapter aware of a new backend service.

sn=@2
echo "The new service is called $sn ."

td=/usr/local/openresty/conf/services
echo "The path for all service subdirectories is set to $td ."

if [ -f ./services/documentation/nginx.documentation.conf ]
 then
	out=$(docker ps -a | grep -c adapter-data)
	if [ $out -gt 0 ]
	 then
		# create path in Adapter container
		nsv=$td/documentation
		docker exec adapter mkdir -p $nsv/
		# copy nginx configuration entry for service
		docker cp ./services/documentation/nginx.documentation.conf adapter-data:$nsv
		# restart nginx daemon in the adapter container
		docker kill --signal="HUP" adapter
	fi
fi
