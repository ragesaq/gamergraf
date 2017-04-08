#!/bin/bash
cat > /etc/collectd/collectd.conf <<EOF
FQDNLookup true

<LoadPlugin curl_xml>
Interval 1
</LoadPlugin>

LoadPlugin write_graphite

<Plugin curl_xml>
    <URL "http://$HOST_IP:$HOST_PORT/mahm">
            Host "$HOST"
            Instance "afterburner"
            User "MSIAfterburner"
            Password "$AFTERBURNER_PASSWORD"
            <XPath "/HardwareMonitor/HardwareMonitorEntries/HardwareMonitorEntry">
                    InstanceFrom @srcName
                    ValuesFrom @data
                    Type "gauge"
            </XPath>
    </URL>
</Plugin>

<Plugin write_graphite>
       <Node "MSIAfterburner">
               Host "gamergraf-graphite"
               Port "2003"
               Protocol "tcp"
               LogSendErrors true
               Prefix "collectd."
               Postfix ""
               StoreRates true
               AlwaysAppendDS false
               EscapeCharacter "_"
       </Node>
</Plugin>
EOF

