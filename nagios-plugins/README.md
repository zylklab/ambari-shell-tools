# Nagios plugins

## Scripts

TODO

## Nagios Config

First, place shell scripts (*sh) in your Nagios scripts directory (usually /usr/lib/nagios/scripts) 

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

TODO
