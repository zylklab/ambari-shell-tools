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
  echo "  check_ambari_health_report.sh <SERVER> <PORT> <USERNAME> <PASSWORD> <CLUSTERNAME>"
  echo
  exit
fi

CURL=`curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=Clusters/health_report`
CHCK=`echo $CURL | grep Clusters/health_report`

if [[ "$CHCK" == "" ]]; then
   CHECK="Failed"
else
   CHECK="OK"
   STATUS_ALERT=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_status/ALERT`
   STATUS_UNHEALTHY=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_status/UNHEALTHY`
   STATE_UNHEALTHY=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_state/UNHEALTHY`
   STATE_HEARTBEAT_LOST=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_state/HEARTBEAT_LOST`
   STATUS_UNKNOWN=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_status/UNKNOWN`
   STATE_INIT=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_state/INIT`
   STATE_HEALTHY=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_state/HEALTHY`
   STATUS_HEALTHY=`echo $CURL | jshon -e Clusters -e health_report -e Host/host_status/HEALTHY`
   MAINTENANCE=`echo $CURL | jshon -e Clusters -e health_report -e Host/maintenance_state`

   if [[ "$STATUS_UNHEALTHY" > 0 ]] || [[ "$STATUS_ALERT" > 0 ]] || [[ "$STATE_UNHEALTHY" > 0 ]];then
     CHECK="Critical"
   elif [[ "$STATE_INIT" > 0 ]] || [[ "$MAINTENANCE" > 0 ]] || [[ "$STATUS_UNKNOWN" > 0 ]] || [[ "$STATE_HEARTBEAT_LOST" > 0 ]];then
     CHECK="Warning"
   fi 
fi
 
if [[ "$CHECK" == "OK" ]]; then
   echo "INFO: Ambari Health Status - host_status/ALERT=$STATUS_ALERT, host_status/UNHEALTHY=$STATUS_UNHEALTHY, host_state/UNHEALTHY=$STATE_UNHEALTHY, host_state/HEARTBEAT_LOST=$STATE_HEARTBEAT_LOST, host_status/UNKNOWN=$STATUS_UNKNOWN, host_state/INIT=$STATE_INIT, host_state/HEALTHY=$STATE_HEALTHY, host_status/HEALTHY=$STATUS_HEALTHY, maintenance_state=$MAINTENANCE"
   exit 0
elif [[ "$CHECK" == "Warning" ]]; then
   echo "WARNING: Ambari Health Status - host_status/ALERT=$STATUS_ALERT, host_status/UNHEALTHY=$STATUS_UNHEALTHY, host_state/UNHEALTHY=$STATE_UNHEALTHY, host_state/HEARTBEAT_LOST=$STATE_HEARTBEAT_LOST, host_status/UNKNOWN=$STATUS_UNKNOWN, host_state/INIT=$STATE_INIT, host_state/HEALTHY=$STATE_HEALTHY, host_status/HEALTHY=$STATUS_HEALTHY, maintenance_state=$MAINTENANCE"
   exit 1 
elif [[ "$CHECK" == "Critical" ]]; then
   echo "CRITICAL: Ambari Health Status - host_status/ALERT=$STATUS_ALERT, host_status/UNHEALTHY=$STATUS_UNHEALTHY, host_state/UNHEALTHY=$STATE_UNHEALTHY, host_state/HEARTBEAT_LOST=$STATE_HEARTBEAT_LOST, host_status/UNKNOWN=$STATUS_UNKNOWN, host_state/INIT=$STATE_INIT, host_state/HEALTHY=$STATE_HEALTHY, host_status/HEALTHY=$STATUS_HEALTHY, maintenance_state=$MAINTENANCE"
   exit 2
elif [[ "$CHECK" == "Failed" ]]; then
   echo "CRITICAL: ${SERVER}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
