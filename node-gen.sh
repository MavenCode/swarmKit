#!/usr/bin/env bash

# Author:   MavenCode
# Last Modified: May 15, 2016

# Scripts to deploy setup

. ./nodes/swarm/swarm-master/swarm-master.sh  --source-only
. ./nodes/swarm/swarm-nodes/swarm-nodes.sh  --source-only
. ./common/utils.sh  --source-only





usage(){
	echo ""
    echo "Usage: $ProgName <command> [options]"
    echo "commands:"
    echo "    --create   create a new docker-machine (swarm-master | swarm-node)"
    echo "    --deploy   deploy a docker container to swarm cluster (apps | kafka | cassandra | haproxy)"
    echo ""
    echo "For help with each command run:"
    echo "$ProgName <command> -h | --help"
    echo ""
}


setup_swarm_nodes()
{
	args="$@"

	log "Deploying swarm nodes"
	
	for i in $args
	do
	case $i in
	    -t=*|--type=*)
	    TYPE="${i#*=}"
	    shift
	    ;;
	    -n=*|--number=*)
	    NUMBER="${i#*=}"
	    shift
	    ;;
	    -aws_type=*|--amazonec2-instance-type=*)
	    AWS_INSTANCE_TYPE="${i#*=}"
	    shift
	    ;;	    	    
	    *)
	       # unknown option
	    ;;
	esac
	done


	[ -z "$AWS_INSTANCE_TYPE" ] && echo "Setting amazonec2-instance-type $AWS_INSTANCE_TYPE" && export AWS_INSTANCE_TYPE=$AWS_INSTANCE_TYPE;

	NUMBER=${NUMBER:-1}
	
	case $TYPE in	
	"swarm-master" )
		bootstrap_swarm_master $NUMBER
		;;
	"swarm-node" )
		bootstrap_swarm_nodes $NUMBER
		;;
    *)
        # unknown option
    ;;		
	esac
}



function join { local IFS="$1"; shift; echo "$* "; }




case $1 in

    --create)
    	setup_swarm_nodes "$@"
    ;;
    --deploy)
    	# deploy_containers "$@"
    ;; 
    --undeploy)
    	# undeploy_containers
    ;;   
    *)
        usage
    ;;
esac

