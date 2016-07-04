#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Scripts to teardown cluster setup

# Usage: 

. ./common/utils.sh  --source-only


log "Destroying existing swarm cluster and containers"


cleanup_all_docker_machines

log "Setup destroy done!"

docker-machine ls

echo ""
echo ""
