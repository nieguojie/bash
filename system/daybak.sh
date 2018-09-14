#!/bin/sh
daytime=`date "+%Y%m%d"`
IP=`ifconfig|grep addr:|grep -v HWaddr|grep -v 127.0.0.1|awk '{print $2}'|awk -F\: '{print $2}'|head -1 | awk -F\. '{print $NF}'`
tar cvzf  /tmp/21all${daytime}.tar.gz /var/spool/cron/root /usr/local/sbin/ --exclude=ROOT/dbscarImages  --exclude=ROOT/images /opt/mycarmaven/ROOT --exclude=newmycar1-tomcat/logs /opt/newmycar1-tomcat/  /usr/local/nginx/conf/ /etc/rc.local /etc/sysconfig/iptables /etc/hosts
sleep 2
rsync -av --progress /tmp/21all${daytime}.tar.gz  bak@172.19.102.10::bak/21/ --password-file=/etc/rsync10.passwd 
sleep 2
rm -f /tmp/21all${daytime}.tar.gz
