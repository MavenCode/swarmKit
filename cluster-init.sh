#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Scripts to basic setup 

. ./common/utils.sh  --source-only


echo -e "\n\n Setting up default swarm cluster.\n This will take some few minutes...grab a coffee\n\n"


# clean up existing clusters
./cleanup.sh


log "Step 2: setup 1 swarm master node"
./node-gen.sh --create -t=swarm-master -n=1

log "Step 3: add 1 node to the swarm cluster"
./node-gen.sh --create -t=swarm-node -n=1

# Optional: specify instance type
# ./node-gen.sh --create -t=swarm-node -n=1 -aws_type=t2.small

# Next: deploy containers
# ./node-gen.sh --deploy -c=haproxy1

# Optional: specify node
# ./node-gen.sh --deploy -c=haproxy1 -e=ls-swarm-node-2


#Optional: remove all running containers
# ./node-gen.sh --undeploy




