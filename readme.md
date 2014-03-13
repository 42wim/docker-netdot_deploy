# Netdot Deploy 
(idea blatantly stolen from shipyard)

This will deploy a componentized Netdot stack on your Docker host. It will pull, launch, and link the various services (apache/mysql) together so you have an entire Netdot stack. (Netdot is open source tool designed to help network administrators collect, organize and maintain network documentation. https://osl.uoregon.edu/redmine/projects/netdot)

# Usage
You must bind the Docker socket into the container in order for the deploy container
to work with the Docker host.

## Setup Netdot Stack

`docker run -i -t -v /var/run/docker.sock:/docker.sock 42wim/netdot_deploy setup`

It will fetch all the necessary images (could take a while) and start up 3 containers (netdot_init/netdot_apache/netdot_db)
You can then connect on  http://<docker-host-ip>:8888/netdot/ and login with admin/admin

## Remove Netdot Stack 
To remove the Netdot Stack containers run:
`docker run -i -t -v /var/run/docker.sock:/docker.sock 42wim/netdot_deploy cleanup`

## Purge the imgages
To remove the images (except netdot_deploy) run:
`docker run -i -t -v /var/run/docker.sock:/docker.sock 42wim/netdot_deploy purge`

## Run updatedevices.pl
You can also run updatedevices.pl as such:

`docker run -rm -name netdot_update -link netdot_db:db centos/netdot /usr/local/netdot/bin/updatedevices.pl –H switch-ip -I`

# Sources
The dockerfiles for the different containers can be found on:
* https://github.com/42wim/docker-netdot
* https://github.com/42wim/docker-netdot_db
* https://github.com/42wim/docker-netdot_deploy

They can be used to rebuild your containers based on latest git.
