#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016


# docker machine settings
export DOCKER_MACHINE_DRIVER=virtualbox 	# options: amazonec2 or virtualbox
export DOCKER_MACHINE_MEMORY=512

# docker-compose timeout
export COMPOSE_HTTP_TIMEOUT=200

# global constants
export SWARM_MASTER_NODE="swarm-master-node"
export SWARM_NODE="swarm-node"
export ENV=DEV

export SWARM_JOIN_SECRET=abracadabra




