#!/bin/bash
# path: /etc/keepalived/scripts/redis_master_check.sh

# return 0 if the specified IP is a redis master
# return 1 otherwise

export LANG=C

# bad usage of commande case
if [ $# -lt 3 ]; then
    echo "Wrong usage"
    echo "Syntax: $0 <ip> <port> <redis-requirepass>"
    exit 1
fi

REDIS_SERVER_IP="$1"
REDIS_SERVER_PORT="$2"
REDIS_PASSWORD="$3"

redis-cli -h "$REDIS_SERVER_IP" \
          -p "$REDIS_SERVER_PORT" \
          -a "$REDIS_PASSWORD" info replication | \
    grep role | grep master

now="`date +'%Y-%m-%d %H:%M:%S'`" 
if [ $? -eq 0 ]; then
    echo "$now | Success: MASTER"
    exit 0
else
    echo "$now | Failed: NOT A MASTER"
    exit 1
fi