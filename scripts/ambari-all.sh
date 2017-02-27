#!/bin/bash
#
#  Author: Cesar Capillas
#
#  https://github.com/CesarCapillas
#
#  License: see accompanying LICENSE file
#

###############LOAD PROPERTIES#######################
PROPERTIESPATH=`pwd`
PROPERTIESFILE=ambari.props
source $PROPERTIESPATH/$PROPERTIESFILE
#####################################################
SERVER=$AMBARIHOST
PORT=$AMBARIPORT
USERNAME=$AMBARIADMINUSER
PASSWORD=$AMBARIADMINPASS
CLUSTERNAME=$CLUSTERNAME
####################################################


ENDPOINT="http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}/services/${SERVICE}"

case "$1" in
  start)
      for i in `echo $ALL1`;
        do
  	      echo "Starting $i"
  	      curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Starting service via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' $ENDPOINT 
        done
      ;;
  stop)
      for i in `echo $ALL2`;
        do
  	      echo "Stopping $i"
  	      curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Starting service via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' $ENDPOINT 
          done
      ;;
  check)
      echo 'Available services:' 
  	  curl --silent -u $USERNAME:$PASSWORD -X GET http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}/services | grep service_name| awk -F":" '{print $2}' 
      ;;
  *)
      echo 'Usage: ambari-all.sh [start|stop]'
      echo
      ;;
esac
