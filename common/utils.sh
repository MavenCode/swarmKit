#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Utility Scripts


. ./common/env.sh  --source-only

. ./cluster.conf --source-only

# Usage: 


log() {
    echo ""
    echo "-------------------------------------------------"
	echo -e " $1"
	echo "-------------------------------------------------"
    echo ""    
}

cleanup_docker_machine()
{
	DOCKER=$1

	log "Clean up previous docker-machine setup: $DOCKER"

	PREV_DOCKER=$(docker-machine ls -q --filter name=$DOCKER)

    if ! [ -z "$PREV_DOCKER" ]; then
        docker-machine rm -f $PREV_DOCKER
    fi

    log "Clean up $DOCKER done!"

    echo ""
    echo ""
}

cleanup_all_docker_machines()
{
    
    PREV_DOCKER=$(docker-machine ls -q | grep swarm)

    if ! [ -z "$PREV_DOCKER" ]; then
        docker-machine rm -f $PREV_DOCKER
    fi

    echo ""
    echo ""
}


docker_machine_provider()
{    
    if [[ "$DOCKER_MACHINE_DRIVER" == "amazonec2" ]]; then
        
        # For more options, see https://docs.docker.com/machine/drivers/aws/ 

        [ -z "$AWS_ACCESS_KEY_ID" ] && echo "Cannot read property AWS_ACCESS_KEY_ID in config file" && exit;
        [ -z "$AWS_SECRET_ACCESS_KEY" ] && echo "Cannot read property AWS_SECRET_ACCESS_KEY in config file" && exit;
        [ -z "$AWS_VPC_ID" ] && echo "Cannot read property AWS_VPC_ID in config file" && exit;
        [ -z "$AWS_SUBNET_ID" ] && echo "Cannot read property AWS_SUBNET_ID in config file" && exit;
        [ -z "$AWS_DEFAULT_REGION" ] && echo "Cannot read property AWS_DEFAULT_REGION in config file" && exit;
        [ -z "$AWS_ZONE" ] && echo "Cannot read property AWS_ZONE in config file" && exit;
        [ -z "$AWS_INSTANCE_TYPE" ] && echo "Cannot read property AWS_INSTANCE_TYPE in config file" && exit;


        echo -e "Using amazonec2 provider\n"
        export DOCKER_OPTS="-d $DOCKER_MACHINE_DRIVER \
                            --amazonec2-access-key $AWS_ACCESS_KEY_ID \
                            --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY  \
                            --amazonec2-vpc-id $AWS_VPC_ID \
                            --amazonec2-subnet-id $AWS_SUBNET_ID \
                            --amazonec2-region $AWS_DEFAULT_REGION \
                            --amazonec2-zone $AWS_ZONE \
                            --amazonec2-instance-type $AWS_INSTANCE_TYPE "

    else
        echo -e "Using virtualbox provider\n"
        export DOCKER_OPTS="-d $DOCKER_MACHINE_DRIVER  --virtualbox-memory $DOCKER_MACHINE_MEMORY"
    fi
}



get_swarm_master()
{

    echo "Searching swarm-master..."

    export SWARM_MASTER_NODE=$(docker-machine ls -q  --filter label=machine=$SWARM_MASTER_NODE)

    if [ -z "$SWARM_MASTER_NODE" ]; then
            echo "ERROR: - swarm-master not found"
            exit
    fi

    echo "Found swarm-master: $SWARM_MASTER_NODE"

}


get_swarm_master_ip()
{

    SWARM_MASTER_NODE=$1

    if [[ "$DOCKER_MACHINE_DRIVER" == "amazonec2" ]]; then
        export SWARM_MASTER_IP=$(docker-machine inspect $SWARM_MASTER_NODE  --format '{{.Driver.PrivateIPAddress}}')
    else        
        export SWARM_MASTER_IP=$(docker-machine ip $SWARM_MASTER_NODE)
    fi



    if [ -z "$SWARM_MASTER_IP" ]; then
            echo "ERROR: - swarm-master IP not found"
            exit
    fi


    echo "Found swarm-master IP: $SWARM_MASTER_IP"

}

get_first_swarm_master_ip()
{
    EXISTING_SWARM_MASTER_IP=$(docker-machine ip $(docker-machine ls -q --filter label=machine=swarm-master-node | head -1))
}


get_swarm_node_ip()
{

    #NODE=$1

    if [[ "$DOCKER_MACHINE_DRIVER" == "amazonec2" ]]; then
        export SWARM_NODE_IP=$(docker-machine inspect $1  --format '{{.Driver.PrivateIPAddress}}')
    else        
        export SWARM_NODE_IP=$(docker-machine ip $1)
    fi



    if [ -z "$SWARM_NODE_IP" ]; then
            echo "ERROR: - swarm node IP not found"
            exit
    fi


    echo "Found swarm-node IP: $SWARM_NODE_IP"

}

number_of_masters()
{
    TOTAL_SWARM_MASTER=$(docker-machine ls -q  --filter label=machine=swarm-master-node | wc -l)
}

number_of_nodes()
{
  
    TOTAL_SWARM_NODE=$(docker-machine ls -q  --filter label=machine=$SWARM_NODE | wc -l)

}



