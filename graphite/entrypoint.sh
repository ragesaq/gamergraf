#!/bin/bash
/etc/collectd/collectd-conf.sh
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
exec "$@"
