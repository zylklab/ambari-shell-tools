# Nagios plugins

## Scripts
You may check the scripts directly:

```
$ /usr/lib/nagios/plugins/check_ambari_service.sh ambari.planetexpress.net 8888 admin robot1729 bender HDFS
WARNING: Service HDFS - STATE="STARTED", MAINTENANCE="OFF" * Alerts: CRITICAL=0, WARNING=0, MAINTENANCE=0, OK=33, UNKNOWN=1
```

## Nagios/Icinga configuration

First, place shell scripts (*sh) in your Nagios scripts directory (usually /usr/lib/nagios/scripts) 

In /etc/icinga/objects/ambari-commands.cfg, you have the comand invocations to shell scripts for Nagios services.

In /etc/icinga/objects/hosts.cfg 

```
define host{
        host_name                       ambari
        alias                           ambari
        address                         ambari.planetexpress.net
        use                             generic-host
}
```

In /etc/icinga/objects/services_icinga.cfg

```
define service {
        use                             generic-service
        host_name                       ambari
        service_description             Ambari Alerts
        max_check_attempts              3
        normal_check_interval           10
        retry_check_interval            3
        check_command                   check_ambari_alerts_summary!$HOSTADDRESS$!8080!admin!robot1729!bender
}
```

Finally restart Nagios/Icinga service

```
$ sudo service icinga restart
```

## Screenshots

https://github.com/CesarCapillas/ambari-shell-tools/blob/master/nagios-plugins/icinga.png
