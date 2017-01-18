# ambari-shell-tools
Curl examples for using Ambari REST API from command line shell scripts

## Start/Stop/Check services

## Nagios/Icinga plugin

## Dependencies
- curl 
- jshon (jshon parses, reads and creates JSON and it is designed to be as usable as possible from within the shell and replaces fragile adhoc parsers made from grep/sed/awk as well as heavyweight one-line parsers made from perl/python)
- Other shell tools such as grep/sed/awk

In Ubuntu 16.04 LTS:
```
$ apt-get install curl jshon
```

- http://kmkeen.com/jshon/

## Tested with
- Ambari 2.2.2
- HDP 2.4

## External links

- http://www.zylk.net/es/web-2-0/blog/-/blogs/getting-ambari-metrics-via-curl-and-ambari-rest-api
- http://www.zylk.net/es/web-2-0/blog/-/blogs/monitoring-ambari-with-nagios-
- http://www.zylk.net/es/web-2-0/blog/-/blogs/starting-services-via-ambari-rest-api
