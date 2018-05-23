#!/bin/bash
cp /redis-config/sentinel.conf /redis-data/sntnl.conf
chmod +rw /redis-data/sntnl.conf
while ! ping -c 1 redis-0.redis; do
    echo 'Waiting for server'
    sleep 1
done

redis-sentinel /redis-data/sntnl.conf