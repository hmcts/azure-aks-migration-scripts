#!/usr/bin/env bash

IPS=( "10.13.15.250"
  "10.13.31.250"
  "10.13.32.120"
)

HOST_NAME="$1"

function usage() {
  echo "usage: ./check-prod-health-host.sh  <host-name>"
}

if [ -z "${HOST_NAME}" ]
then
  usage
  exit 1
fi

_len=$(expr ${#IPS[@]} - 1)

HOST=${HOST_NAME}.service.core-compute-prod.internal

for i in $(seq 0 ${_len})
do
  echo "Host: ${HOST} -> http://${IPS[${i}]}/health"
  curl -H "Host: ${HOST}" http://${IPS[${i}]}/health
  echo
done
