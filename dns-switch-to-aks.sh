#!/usr/bin/env bash

service=$1
env=$2

serviceName=${service}-${env}

function usage() {
  echo "usage: ./dns-switch-to-aks.sh <service, i.e cmc-claim-store> <env: prod or aat or ithc>" 
}

if [ -z "${service}" ] || [ -z "${env}" ] ; then
  usage
  exit 1
fi

domain=${serviceName}.service.core-compute-${env}.internal
ipAddress=""

case "${env}" in
  "aat")
    SWITCH_ADDRESS=10.10.24.121
    CONSUL_NODES=(10.96.136.7 10.96.136.9 10.96.136.10)
  ;;
  "ithc")
    SWITCH_ADDRESS=10.10.36.121
    CONSUL_NODES=(10.112.8.4 10.112.8.5 10.112.8.6)
  ;;
  "prod")
    SWITCH_ADDRESS=10.13.32.120
    CONSUL_NODES=(10.96.72.4 10.96.72.5 10.96.72.6)
esac

echo "Changing DNS entry to point to AKS in ${env} for ${domain}"

echo "DNS is currently pointing to:"
dig +short $domain

set -euo pipefail

for nodeIP in ${CONSUL_NODES[*]}
do
  curl -X PUT -H "Accept: application/json" http://${nodeIP}:8500/v1/agent/service/deregister/$service-$env  || echo "Failed deregistering from $nodeIP"
done

curl -X PUT -H "Accept: application/json" http://${CONSUL_NODES[0]}:8500/v1/agent/service/register -d '
{
  "ID": "'${serviceName}'",
  "Name": "'${serviceName}'",
  "Service": "'${serviceName}'",
  "Address": "'${SWITCH_ADDRESS}'",
  "Port": 80
}
'

sleep 5
echo "DNS is currently pointing to:"
dig +short $domain

echo "Switch complete"

echo
echo ' __      __                     .__                
/  \    /  \_____ _______  ____ |__| ____    ____  
\   \/\/   /\__  \\_  __ \/    \|  |/    \  / ___\ 
 \        /  / __ \|  | \/   |  \  |   |  \/ /_/  >
  \__/\  /  (____  /__|  |___|  /__|___|  /\___  / 
       \/        \/           \/        \//_____/  '

echo "You now need to make sure the disableLegacyDeployment() flag has been added to the teams Jenkinsfile_CNP"
echo "Otherwise Jenkins will revert this change"
