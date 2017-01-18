#!/bin/bash

SERVER=$1
PORT=$2
USERNAME=$3
PASSWORD=$4
CLUSTERNAME=$5 

ENDPOINT="http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}"

if [[ "$1" == "" ]]; then
  echo "USAGE:"
  echo "  check_ambari_total_hosts.sh <SERVER> <PORT> <USERNAME> <PASSWORD> <CLUSTERNAME>"
  echo
  exit
fi

CURL=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=Clusters/total_hosts`
CHCK=`echo $CURL | grep "Clusters/total_hosts"`

if [[ "$CHCK" == "" ]]; then
   CHECK="Failed"
else
   CHECK="OK"
   TOTAL_HOSTS=`echo $CURL | jshon -e Clusters -e total_hosts`

   ALL_HOSTS=`curl -silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}/hosts| awk -F: '/host_name/{print $2}' ORS=''`

fi
 
if [[ "$CHECK" == "OK" ]]; then
   echo "INFO: Ambari Total Hosts = $TOTAL_HOSTS ::$ALL_HOSTS"
   exit 0
elif [[ "$CHECK" == "Failed" ]]; then
   echo "CRITICAL: ${SERVER}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
