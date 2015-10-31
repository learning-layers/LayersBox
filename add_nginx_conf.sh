#!/bin/bash
# This script serves to make a LayersBox Adapter aware of a new backend service.
# Will become obsolete in the future as there should be only one such script included in the default LayersBox.

if [ -f ./services/documentation/nginx.documentation.conf ]
 then
	out=$(docker ps -a | grep -c adapter-data)
	if [ $out -gt 0 ]
	 then
		# create path in Adapter container
		nsv=/usr/local/openresty/conf/services/documentation
		docker exec adapter mkdir -p $nsv/
		# copy nginx configuration entry for service
		docker cp ./services/documentation/nginx.documentation.conf adapter-data:$nsv
		# restart nginx daemon in the adapter container
		docker kill --signal="HUP" adapter
	fi
fi
