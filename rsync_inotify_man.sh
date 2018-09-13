#!/bin/sh
src=/data/dir1/
src2=/data/wwwroot/

   /usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e close_write,delete,create,attrib  $src $src1 $src2| while read files
   do
   rsync -avz  --progress  --exclude="log" --exclude='/data/dir1/system_admin/wwwroot/file/card/' $src web2@192.168.1.3::web21 --password-file=/etc/rsyncd.password
   rsync -avz --delete  --progress $src2 web2@192.168.1.3::web23 --password-file=/etc/rsyncd.password

   rsync -avz --delete --progress  --exclude="log" --exclude='/data/dir1/system_admin/wwwroot/file/card/' $src web3@192.168.1.4::web31 --password-file=/etc/rsyncd.password
   rsync -avz --delete --progress $src2 web3@192.168.1.4::web33 --password-file=/etc/rsyncd.password

   rsync -avz  --progress  --exclude="log" --exclude="ext/syn_trip.lock" --exclude='/data/dir1/system_admin/wwwroot/file/card/' $src web4@192.168.1.5::web41 --password-file=/etc/rsyncd.password
   rsync -avz --delete  --progress $src2 web4@192.168.1.5::web43 --password-file=/etc/rsyncd.password    
# for webfile
   #rsync -avz   --progress --exclude="log" $src  web@192.168.1.6::dir1 --password-file=/etc/rsyncd.password
   rsync -avz --delete --progress --exclude="log" $src  web@192.168.1.6::dir1 --password-file=/etc/rsyncd.password
   sleep 30
  done


