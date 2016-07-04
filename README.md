# swarmKit
Script to help create and manage swarm cluster on docker-machine for testing

Requires docker 1.12

Usage
--

### Setup swarm cluster

To setup a new cluster, use the command

`./cluster-init.sh`

To add a swarm worker to the cluster, use the command

`./node-gen.sh --create -t=swarm-node -n=2`

Where `n` is the number of nodes you want to scale up to

### Clean up

Use the command below the tear down the cluster

cleanup.sh

Developers
--
* Charles O. Adetiloye
* Philip K. Adetiloye
