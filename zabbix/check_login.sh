#!/bin/bash
h=`date +%H`
if [ $h -gt 7 -a $h -lt 21 ];then
    echo 
else
    echo "`/usr/bin/w |grep -v USER  | grep -v day`"
fi

