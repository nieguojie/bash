#!/bin/bash
stat_time1=`date +%Y%m%d` 
stat_time2=`date -d "1 minutes ago" | awk '{print $4}' | cut -d: -f1,2`
log_time=`date -d "1 minutes ago" | awk '{print $4}' | cut -d: -f1,2 | sed 's/\://'`
#stat_time2="01:50"
num1=$(cat -n /opt/service1-tomcat/logs/catalina.out | grep "$stat_time1 $stat_time2" | head -n1 | awk '{print $1}')
num2=$(cat -n /opt/service1-tomcat/logs/catalina.out | grep "$stat_time1 $stat_time2" | tail -n1 | awk '{print $1}')
sed -n "$num1,$num2 p" /opt/service1-tomcat/logs/catalina.out > /tmp/service1.txt
cp /tmp/service1.txt /dir/dir1/21_8080_${log_time}.txt
log_num=`cat -n /tmp/service1.txt  | grep  '^[[:space:]]' | grep -cw 'at'`
#
if [ $log_num -gt 5 ];then
start_num=`cat -n /tmp/service1.txt   | grep  '^ *[0-9]' | grep -w '[[:space:]]at' | grep -v 'at:' | head -n1 | awk '{print $1-20}'`
end_num=`cat -n /tmp/service1.txt    | grep  '^ *[0-9]' | grep -w '[[:space:]]at' | grep -v 'at:' | tail -n1 | awk '{print $1+10}'`
cc=$(echo $end_num-$start_num|bc)
dd=$(echo $start_num+200|bc)
        if [[ $cc -lt 250 ]];then
        echo $start_num $cc $dd
                sed -n "$start_num,$end_num p" /tmp/service1.txt >> /dir/dir1/21_8080.txt
#				echo >> /dir/dir1/112_8080.txt
#				echo >> /dir/dir1/112_8080.txt
        else
				echo "ok $dd"
                sed -n "$start_num,$dd p" /tmp/service1.txt >> /dir/dir1/21_8080.txt
#				echo >> /dir/dir1/112_8080.txt
#				echo >> /dir/dir1/112_8080.txt
        fi

fi

