#!/usr/bin/bash
for file in $(find /opt/dir -type f)
do
md5sum $file >> /home/user01/sz_dir
done




#!/usr/bin/bash
cat /home/user01/sz_dir |while read a b 
do
    cat /home/user01/us_dir | while read c d
    do
    if [  $a != $c ] && [ "$b" == "$d" ]
    then
        echo "$b    $d" >> /home/user01/diff
    fi
    done
done

