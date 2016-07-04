#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Scripts to deploy Swarm-master, Consul-agent and Rancher  

# Usage: 

. ./common/utils.sh  --source-only



bootstrap_swarm_master()
{

      INSTANCES=$1

      docker_machine_provider

      log "Creating Swarm master..."

      for i in $(seq 1 $1)
      {
            export SWARM_MASTER=$SWARM_MASTER_NODE-$i
        
            MASTER_QUERY=$(docker-machine ls -q --filter label=node=$SWARM_MASTER)            

            if [ -z "$MASTER_QUERY" ]; then
                  
                  log "Creating Swarm master: $SWARM_MASTER"

                  docker-machine create $DOCKER_OPTS \
                                    --engine-label machine=$SWARM_MASTER_NODE \
                                    --engine-label node=$SWARM_MASTER \
                                    --engine-label env=$ENV \
                                    --engine-label memory=$DOCKER_MACHINE_MEMORY \
                                    $SWARM_MASTER



                  get_swarm_master_ip $SWARM_MASTER

                  echo "swarm-master node ($SWARM_MASTER) created with ip = $SWARM_MASTER_IP"

                  eval $(docker-machine env $SWARM_MASTER)

                  number_of_masters

                  echo "Total master $TOTAL_SWARM_MASTER"

                  if [[ $TOTAL_SWARM_MASTER -gt 1 ]]; then

                        get_first_swarm_master_ip

                        echo "Join cluster (-> $EXISTING_SWARM_MASTER_IP) as master node"

                        docker swarm join --secret $SWARM_JOIN_SECRET --manager --listen-addr $SWARM_MASTER_IP:2377 $EXISTING_SWARM_MASTER_IP:2377 
                  else 
                        docker swarm init --secret $SWARM_JOIN_SECRET --listen-addr $SWARM_MASTER_IP:2377      
                  fi
                  

                  log "Swarm cluster"                  
                  docker node ls

            else
                  echo "Host already exists: $MASTER_QUERY skipping"    
            fi

      }
      
     echo ""

}
