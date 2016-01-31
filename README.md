# LayersBox
An npm- and bower-like script to setup and configure a Docker host with a reverse proxy serving various microservices - the Layers Box.

# Try It Out!
For now, we think the best way to try out `layersbox` is on an Ubuntu server. We have put online a short tutorial on how to set up your test environment: http://developer.learning-layers.eu/documentation/layers-box/environment-setup/

# Installation
1. Clone the repository: `git clone https://github.com/learning-layers/LayersBox.git`

# Usage
* run `layersbox init` to initialize a Layers Box with Nginx (the Layers Adapter) and MySQL
* run `layersbox start` to start the Layers Box
* run `layersbox stop` to stop the Layers Box
* run `layersbox status` to see the status of the currently deployed services
* run `layersbox install repo#version` to install a new service on the Layers Box, e.g. `layersbox install learning-layers/documentation#0.0.1`

# How It Works
`layersbox` is a Python script that makes it easy to install new software packages on your server. All you need is a Docker and Docker Compose installation. It heavily relies on Docker Compose for starting your Web app containers. Whenever you type `layersbox install repo#version`, it will download the latest release of the `repo` from GitHub. Then, it gets the `docker-compose.yml` file from the repo and combines it with the existing docker-compose.yml of the Layers Box. The great thing when instantiating the combined file is that already running containers are not shut down. Only the new ones are started and linked to the existing ones.

Besides adding new containers, the script can also perform some `Actions`: http://developer.learning-layers.eu/documentation/layers-box/actions/
For example, `layersbox` enters your Web app into the Nginx config file (in our terminology, we often say 'Layers Adapter' instead of 'Nginx'). Therefore it reads out the content of your `nginx.conf` file and adds it to the configuration of Nginx. Then, Nginx is instructed to reload its configuration. Your Web app is then served through the Layers Adapter.

# Conventions
1. In your docker-compose.yml, you must name the resulting container the exact same way you name your service in your nginx.conf.
2. There are some limitations on the names you may assign to your services imposed by the current Docker Compose implementation stage. Among others, it is strongly recommended you name your services and containers only with lowercase letters (no hyphens, no lowerscore, no digits).

# F&Q
