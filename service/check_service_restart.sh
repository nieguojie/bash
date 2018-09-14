#!/bin/bash
while true;
do
sleep 5
#curl -I http://127.0.0.1:8084 &>/dev/null || continue
curl -I http://127.0.0.1:8080 &>/dev/null
RETVAL=$?
ps -ef | grep service | grep -v grep | grep -v restart | wc -l
RETVAL2=$?
if [ "$RETVAL" -eq 0 -a "$RETVAL1" -ne 0 ];then
   /etc/init.d/service stop
   sleep 5
   ps -ef | grep service |  grep -v grep |  grep -v restart | awk '{print $2}' | xargs kill -9
   /etc/init.d/service start
   exit
else
   continue
fi
done

