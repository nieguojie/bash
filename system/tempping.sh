#!/bin/bash
while :;
do
echo `date +%Y%m%d%H%M%S` >>/tmp/ping.txt
ping -c 1 100.100.10.1 | grep icmp >>/tmp/ping.txt
sleep 0.5
done


#!/bin/bash
while [ 0 == 0 ];
do
    echo  `date +%Y%m%d-%H%M%S` `ping -w 1 -c 1 192.168.1.1 | grep icmp` >> /tmp/aliping.txt
    sleep 1
done

