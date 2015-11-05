# LayersBox
An npm- and bower-like script to setup and configure a Docker host with a reverse proxy serving various microservices - the Layers Box.

# Installation
1. Clone the repository
2. run `python setup.py --user` to install the layersbox command for your current user. You don't need to install it, but if you don't, make sure that you install the needed packages.

# Usage
* run `layersbox init` to initialize a Layers Box with the nginx (the Layers Adapter) and MySQL
* run `layersbox start` to start the Layers Box
* run `layersbox stop` to stop the Layers Box
* run `layersbox status` to see the status of the currently deployed services
* run `layersbox install repo#version` to install a new service on the Layers Box, e.g. `layersbox install learning-layers/documentation#0.0.1`

# Conventions
1. In your docker-compose.yml, you must name the resulting container the exact same way you name your service in your nginx.conf.
2. The nginx.conf file must be in the same directory from which you run the layersbox script.
3. There are some limitations on the names you may assign to your services imposed by the current Docker Compose implementation stage. Among others, it is strongly recommended you name your services and containers only with lowercase letters (no hyphens, no lowerscore, no digits).
