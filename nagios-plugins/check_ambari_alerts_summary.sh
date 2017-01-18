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
  echo "  check_ambari_alerts_summary.sh <SERVER> <PORT> <USERNAME> <PASSWORD> <CLUSTERNAME>"
  echo
  exit
fi

CURL=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=alerts_summary`
CHCK=`echo $CURL | grep alerts_summary`

if [[ "$CHCK" == "" ]]; then
   CHECK="Failed"
else
   CHECK="OK"
   CRITICAL=`echo $CURL | jshon -e alerts_summary -e CRITICAL`
   MAINTENANCE=`echo $CURL | jshon -e alerts_summary -e MAINTENANCE`
   OK=`echo $CURL | jshon -e alerts_summary -e OK`
   UNKNOWN=`echo $CURL | jshon -e alerts_summary -e UNKNOWN`
   WARNING=`echo $CURL | jshon -e alerts_summary -e WARNING`
   if [[ "$CRITICAL" > 0 ]];then
     CHECK="Critical"
   elif [[ "$WARNING" > 0 ]];then
     CHECK="Warning"
   fi 
fi
 
if [[ "$CHECK" == "OK" ]]; then
   echo "INFO: Ambari Services - CRITICAL=$CRITICAL, WARNING=$WARNING, OK=$OK, UNKNOWN=$UNKNOWN, MAINTENANCE=$MAINTENANCE"
   exit 0
elif [[ "$CHECK" == "Warning" ]]; then
   echo "WARNING: Ambari Services - CRITICAL=$CRITICAL, WARNING=$WARNING, OK=$OK, UNKNOWN=$UNKNOWN, MAINTENANCE=$MAINTENANCE"
   exit 1 
elif [[ "$CHECK" == "Critical" ]]; then
   echo "CRITICAL: Ambari Services - CRITICAL=$CRITICAL, WARNING=$WARNING, OK=$OK, UNKNOWN=$UNKNOWN, MAINTENANCE=$MAINTENANCE"
   exit 2
elif [[ "$CHECK" == "Failed" ]]; then
   echo "CRITICAL: ${SERVER}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
