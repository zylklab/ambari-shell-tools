#!/bin/bash
#
#  Author: Cesar Capillas
#
#  https://github.com/CesarCapillas
#
#  License: see accompanying LICENSE file
#

SERVER=$1
PORT=$2
USERNAME=$3
PASSWORD=$4
CLUSTERNAME=$5 

ENDPOINT="http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}"

if [[ "$1" == "" ]]; then
  echo "USAGE:"
  echo "  check_ambari_version.sh <SERVER> <PORT> <USERNAME> <PASSWORD> <CLUSTERNAME>"
  echo
  exit
fi

CURL=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=Clusters/version`
CHCK=`echo $CURL | grep "Clusters/version"`

if [[ "$CHCK" == "" ]]; then
   CHECK="Failed"
else
   CHECK="OK"
   VERSION=`echo $CURL | jshon -e Clusters -e version`
fi
 
if [[ "$CHECK" == "OK" ]]; then
   echo "INFO: Ambari Version = $VERSION"
   exit 0
elif [[ "$CHECK" == "Failed" ]]; then
   echo "CRITICAL: ${SERVER}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
