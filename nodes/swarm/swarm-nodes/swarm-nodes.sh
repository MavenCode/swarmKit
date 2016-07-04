#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Scripts to deploy Swarm-nodes, API 

# Usage: 

. ./common/utils.sh  --source-only


bootstrap_swarm_nodes()
{
        
    INSTANCES=$1

    docker_machine_provider

    get_swarm_master

    log "Creating Swarm nodes..."

    for i in $(seq 1 $1)
    {
        export SWARM_NODE_INSTANCE=$SWARM_NODE-$i
        
        NODE_QUERY=$(docker-machine ls -q --filter label=node=$SWARM_NODE_INSTANCE)

        if [ -z "$NODE_QUERY" ]; then
            echo "creating swarm-node: $SWARM_NODE_INSTANCE"

             log "Creating Swarm API Docker Node: $SWARM_NODE_INSTANCE"
        

            docker-machine create   $DOCKER_OPTS \
                                    --engine-label node=$SWARM_NODE_INSTANCE \
                                    --engine-label env=$ENV \
                                    --engine-label memory=$DOCKER_MACHINE_MEMORY \
                                    $SWARM_NODE_INSTANCE
            
            get_swarm_node_ip $SWARM_NODE_INSTANCE

            echo "swarm-node ($SWARM_NODE_INSTANCE) created with ip = $SWARM_NODE_IP"


            get_swarm_master_ip $SWARM_MASTER_NODE


            eval "$(docker-machine env $SWARM_NODE_INSTANCE)"
            docker swarm join --secret $SWARM_JOIN_SECRET $SWARM_MASTER_IP:2377

            log "Swarm cluster"
            eval "$(docker-machine env $SWARM_MASTER_NODE)"            
            docker node ls
            
        else 
            echo "Host already exists: $NODE_QUERY skipping"    
        fi
        
    }
    
    echo ""
}