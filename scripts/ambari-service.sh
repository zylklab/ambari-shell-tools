#!/bin/bash
#
#  Author: Cesar Capillas
#
#  https://github.com/CesarCapillas
#
#  License: see accompanying LICENSE file
#

SERVER=ambari.planetexpress.net
PORT=8080
USERNAME=admin
PASSWORD=robot1729
CLUSTERNAME=bender
SERVICE=$1

ENDPOINT="http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}/services/${SERVICE}"

case "$2" in
  start)
        echo "Starting $SERVICE"
        curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Starting service via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' $ENDPOINT 
       	;;
  stop)
        echo "Stopping $SERVICE"
        curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Starting service via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' $ENDPOINT 
        ;;
  check)
        echo "Checking $SERVICE"
        curl --silent -u ${USERNAME}:${PASSWORD} -X GET ${ENDPOINT}?fields=ServiceInfo | grep state
        ;;
  *)
        echo 'Usage: ambari-service.sh [ZOOKEEPER|HDFS|YARN|MAPREDUCE2|HBASE|HIVE|SPARK|KAFKA|FLINK|ZK-NIFI|ZEPPELIN] [start|stop|check]'
        echo
        echo 'Available services:' 
        curl --silent -u $USERNAME:$PASSWORD -X GET http://${SERVER}:${PORT}/api/v1/clusters/${CLUSTERNAME}/services | grep service_name| awk -F":" '{print $2}' 
        ;;
esac
