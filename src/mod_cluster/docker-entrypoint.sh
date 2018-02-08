#!/bin/bash
set -e

if [ "$1" = 'start' ]; then

  #get the current ip addr of the continer
  IPADDRESS=$(hostname -i)
  CONTAINER_IP_ADDR=$(/sbin/ip route|awk '/default/ { print $3 }')
	MODCLUSTER_PORT=${MODCLUSTER_PORT:-6666}
	MODCLUSTER_ADVERTISE=${MODCLUSTER_ADVERTISE:-On}
	MODCLUSTER_ADVERTISE_GROUP=${MODCLUSTER_ADVERTISE_GROUP:-224.0.1.105:23364}
	MODCLUSTER_NET=${MODCLUSTER_NET:-172.}
	MODCLUSTER_MANAGER_NET=${MODCLUSTER_MANAGER_NET:-$MODCLUSTER_NET}

	echo
	echo "Starting httpd with mod_cluster"
	echo "==============================="
	echo "IPADDRESS                  ${IPADDRESS}"
	echo "CONTAINER_IP_ADDR          ${CONTAINER_IP_ADDR}"
	echo "MODCLUSTER_PORT            ${MODCLUSTER_PORT}"
	echo "MODCLUSTER_ADVERTISE       ${MODCLUSTER_ADVERTISE}"
	echo "MODCLUSTER_ADVERTISE_GROUP ${MODCLUSTER_ADVERTISE_GROUP}"
	echo "MODCLUSTER_NET             ${MODCLUSTER_NET}"
	echo "MODCLUSTER_MANAGER_NET     ${MODCLUSTER_MANAGER_NET}"
	echo "mod_cluster server advertise url: http://${CONTAINER_IP_ADDR}:${MODCLUSTER_PORT}"
	echo

	MOD_CLUSTER_CONF_PATH=${HTTPD_MC_BUILD_DIR}/conf/extra/mod_cluster.conf

    # create mod-cluster.conf from environment variables
    echo "Creating ${MOD_CLUSTER_CONF_PATH} configuration file:"
    echo

    cat >${MOD_CLUSTER_CONF_PATH} <<EOT
LoadModule proxy_cluster_module modules/mod_proxy_cluster.so
LoadModule cluster_slotmem_module modules/mod_cluster_slotmem.so
LoadModule manager_module modules/mod_manager.so
LoadModule advertise_module modules/mod_advertise.so
MemManagerFile ${HTTPD_MC_BUILD_DIR}/cache/mod_cluster

# Adjust to you hostname and subnet.
<IfModule manager_module>
    Listen ${IPADDRESS}:6666
    LogLevel debug

    <VirtualHost ${IPADDRESS}:6666>
        ErrorLog logs/mod_cluster_error.log
        CustomLog logs/mod_cluster.log common

        <Directory />
          Require ip 172.
        </Directory>

        KeepAliveTimeout 60
        ManagerBalancerName mycluster
        ServerAdvertise On
        EnableMCPMReceive On

        <Location /mcm>
          SetHandler mod_cluster-manager
          Require ip 172.
        </Location>

    </VirtualHost>
</IfModule>
EOT

    cat ${MOD_CLUSTER_CONF_PATH}
    echo

	echo "-- ${HTTPD_MC_BUILD_DIR}/bin/apachectl $@"
	${HTTPD_MC_BUILD_DIR}/bin/apachectl "$@"
else
	exec "$@"
fi