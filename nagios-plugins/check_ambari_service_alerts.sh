#!/bin/bash

SERVER=$1
PORT=$2
USERNAME=$3
PASSWORD=$4
CLUSTERNAME=$5 
SERVICE=$6

ENDPOINT="http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}/services/${SERVICE}"

if [[ "$1" == "" ]]; then
  echo "USAGE:"
  echo "  check_ambari_service_alerts.sh <SERVER> <PORT> <USERNAME> <PASSWORD> <CLUSTERNAME> <SERVICE>"
  echo
  exit
fi

CURL1=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=alerts_summary`
CURL2=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=ServiceInfo`
CHCK=`echo $CURL2 | grep ServiceInfo`

if [[ "$CHCK" == "" ]]; then
   CHECK="Failed"
else
   CHECK="OK"

   # States
   STATE=`echo $CURL2 | jshon -e ServiceInfo -e state`
   MAINTENANCE_STATE=`echo $CURL2 | jshon -e ServiceInfo -e maintenance_state`

   # Alerts
   CRITICAL=`echo $CURL1 | jshon -e alerts_summary -e CRITICAL`
   MAINTENANCE=`echo $CURL1 | jshon -e alerts_summary -e MAINTENANCE`
   OK=`echo $CURL1 | jshon -e alerts_summary -e OK`
   UNKNOWN=`echo $CURL1 | jshon -e alerts_summary -e UNKNOWN`
   WARNING=`echo $CURL1 | jshon -e alerts_summary -e WARNING`

   if [[ "$MAINTENANCE_STATE" == '"ON"' ]] || [[ "$MAINTENANCE" > 0 ]] || [[ "$WARNING" > 0 ]] || [[ "$UNKNOWN" > 0 ]];then
     CHECK="Warning"
   elif [[ "$CRITICAL" > 0 ]] || [[ "$STATE" == '"INSTALLED"' ]];then
     CHECK="Critical"
   fi 

fi

if [[ "$CHECK" == "OK" ]]; then
   echo "INFO: Service $SERVICE - STATE=$STATE, MAINTENANCE=$MAINTENANCE_STATE | Alerts: CRITICAL=$CRITICAL, WARNING=$WARNING, MAINTENANCE=$MAINTENANCE, OK=$OK, UNKNOWN=$UNKNOWN"
   exit 0
elif [[ "$CHECK" == "Warning" ]]; then
   echo "WARNING: Service $SERVICE - STATE=$STATE, MAINTENANCE=$MAINTENANCE_STATE | Alerts: CRITICAL=$CRITICAL, WARNING=$WARNING, MAINTENANCE=$MAINTENANCE, OK=$OK, UNKNOWN=$UNKNOWN"
   exit 1 
elif [[ "$CHECK" == "Critical" ]]; then
   echo "CRITICAL: Service $SERVICE - STATE=$STATE, MAINTENANCE=$MAINTENANCE_STATE | Alerts: CRITICAL=$CRITICAL, WARNING=$WARNING, MAINTENANCE=$MAINTENANCE, OK=$OK, UNKNOWN=$UNKNOWN"
   exit 2 
elif [[ "$CHECK" == "Failed" ]]; then
   echo "CRITICAL: ${SERVER} --> ${SERVICE}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
