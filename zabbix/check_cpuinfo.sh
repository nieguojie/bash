#!/bin/bash
cpuinfo=$(sar  1 1 | grep Average | awk '{print $NF}' | awk -F\. '{print $1}')
if [ $cpuinfo -lt 30 ];then
	/etc/init.d/nginx restart
fi
