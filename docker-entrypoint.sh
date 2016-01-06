#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Elasticsearch configuration
export CLUSTER_NAME=${CLUSTER_NAME:-elasticsearch-default-cluster}
export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_ENABLE=${HTTP_ENABLE:-true}
export MULTICAST=${MULTICAST:-true}

# Kubernetes configuration
export KUBERNETES_DISCOVERY_SERVICE=${KUBERNETES_DISCOVERY_SERVICE:-elasticsearch-discovery-service}
export KUBERNETES_NAMESPACE=${KUBERNETES_NAMESPACE:-default-namespace}

# Give permission to lock memory
# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration.html
#
# Error: now allowed
# http://stackoverflow.com/questions/24318543/how-to-set-ulimit-file-descriptor-on-docker-container-the-image-tag-is-phusion
# ulimit -l unlimited

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
	# Change the ownership of /data to elasticsearch
	chown -R elasticsearch:elasticsearch /data
	exec gosu elasticsearch "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
