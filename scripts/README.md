# Service scripts

With no parameters, the script checks the available services in Ambari.
```
$ ./ambari-service.sh 
Usage: ambari-service.sh [service] [start|stop|check]

Available services:
 "AMBARI_METRICS"
 "FLINK"
 "HBASE"
 "HDFS"
 "HIVE"
 "KAFKA"
 "MAPREDUCE2"
 "PIG"
 "SLIDER"
 "SPARK"
 "TEZ"
 "YARN"
 "ZEPPELIN"
 "ZK-NIFI"
 "ZOOKEEPER"
 ```
 
## Starting|Stopping|Checking a service

```
$ ./ambari-service.sh HIVE start
Starting HIVE
.
.

$ ./ambari-service.sh HIVE check
Checking HIVE
    "maintenance_state" : "OFF",
    "state" : "STARTING"
   
$ ./ambari-service.sh HIVE stop
Stopping HIVE
.
.   
```

## Starting all services

```
$ ./ambari-all.sh 
Usage: ambari-all.sh [start|stop]
```
