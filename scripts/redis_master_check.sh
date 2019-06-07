#!/bin/sh
###/etc/keepalived/scripts/redis_master_check.sh

# return 0 if specifiec ip is a redis master
# return 1 else

# bad usage of commande case
if [ $# -lt 3 ]; then
		echo "Wrong usage"
        echo "Syntax: ./redis_master_check.sh {redis-server ip} {redis-server port} {redis-server password (requirepass)}"
        exit 1
fi

REDIS_SERVER_IP=$1
REDIS_SERVER_PORT=$2
REDIS_PASSWORD=$3

redis-cli -h $REDIS_SERVER_IP -p $REDIS_SERVER_PORT -a $REDIS_PASSWORD info replication | grep role | grep master

if [ $? -eq 0 ]; then
    echo "`date +'%Y-%m-%d %H:%M:%S'` | Success: MASTER "
    exit 0
else
    echo "`date +'%Y-%m-%d %H:%M:%S'` | Failed: NOT MASTER "
    exit 1
fi
