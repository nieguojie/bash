#!/bin/bash
# function:rsyn 192.168.1.120 to 192.168.1.121
if [ ! -f /etc/121.pass ];then
	echo "launch" > /etc/121.pass
	/bin/chmod 600 /etc/121/pass
fi


log=/usr/local/inotify/log/rsync.log
src="/data/wwwroot/node1"
host="192.168.1.121"
host1="192.168.1.122"
module="node2"


#rsync -avH --delete --bwlimit=100 --progress --password-file=/etc/121.pass  /data/wwwroot/node1 rsyncuser@192.168.1.121::node2
/usr/local/inotify/bin/inotifywait -mrq  -e  create,move,delete,modify  $src | while read a b c 
do
# rsync -avH --delete --bwlimit=100K --progress --password-file=/etc/121.pass  $src rsyncuser@$host::$module >/dev/null &
 rsync -avH --delete  --progress --password-file=/etc/121.pass --exclude-from="/usr/local/inotify/log/rules.txt" $src rsyncuser@$host::$module >/dev/null &
 rsync -avH --delete  --progress --password-file=/etc/122.pass --exclude-from="/usr/local/inotify/log/rules.txt" $src rsyncuser@$host1::node3 >/dev/null &
done
