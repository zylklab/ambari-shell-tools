# ambari-shell-tools
Curl examples for using Ambari REST API from command line shell scripts

## Cluster services
This section is composed of two scripts for starting/stopping/checking services from command line via REST API in an Ambari cluster.
 - ambari-all.sh [start|stop] all cluster services in an ordered and defined sequence
 - ambari-service.sh [start|stop|check] a given cluster service

## Nagios/Icinga plugin
This is a collection of basic shell scripts ready for monitoring your Big Data cluster via Ambari REST API in a Nagios / Icinga server. 
 - check_ambari_alerts_summary.sh (checks alerts summary)
 - check_ambari_hosts_alerts_summary.sh (checks host alerts summary)
 - check_ambari_health_report.sh (checks health report)
 - check_ambari_service.sh (checks a given service state and alerts)
 - check_ambari_total_hosts.sh (checks the total number of hosts in the cluster)
 - check_ambari_version.sh (checks the cluster version)
 - ambari-commands.cfg (Ambari comands for nagios)
 - services_icinga.cfg (Nagios service definitions)

## Dependencies
The main goal of these collection of shell scripts is the simplicity in comparison with other advanced modules in terms of dependencies. Just need few packages such as:
- curl 
- jshon (jshon parses, reads and creates JSON and it is designed to be as usable as possible from within the shell and replaces fragile adhoc parsers made from grep/sed/awk as well as heavyweight one-line parsers made from perl/python)
- Other shell tools such as grep/sed/awk

In Ubuntu 16.04 LTS:
```
$ apt-get install curl jshon
```
Links:
- http://kmkeen.com/jshon/

## Tested with
- Ambari 2.2.2
- HDP 2.4

## External links
- http://www.zylk.net/es/web-2-0/blog/-/blogs/getting-ambari-metrics-via-curl-and-ambari-rest-api
- http://www.zylk.net/es/web-2-0/blog/-/blogs/monitoring-ambari-with-nagios-
- http://www.zylk.net/es/web-2-0/blog/-/blogs/starting-services-via-ambari-rest-api
