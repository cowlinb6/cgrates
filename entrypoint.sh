#!/bin/bash
# CGRateS Docker (default)
# https://github.com/cowlinb6/cgrates

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

service rsyslog start
service redis-server start

# Cat the cgrates.json file to screen (for debug)
#cat /etc/cgrates/cgrates.json

# Set versions (if first time launch)
/usr/bin/cgr-migrator -exec=*set_versions -config_path=/etc/cgrates

# Start 
/usr/bin/cgr-engine -config_path=/etc/cgrates
