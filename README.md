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
