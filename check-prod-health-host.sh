HOST=${1}.service.core-compute-prod.internal
curl -H "Host: ${HOST}" http://10.13.15.250/health
echo
curl -H "Host: ${HOST}" http://10.13.31.250/health
echo
curl -H "Host: ${HOST}" http://10.13.32.120/health
