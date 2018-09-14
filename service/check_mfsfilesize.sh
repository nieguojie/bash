#!/bin/bash
for file in `cat /tmp/mfsfile.txt`
do
    ls -l $file
        if [ $? -eq 0 ];then
            ls -l $file | awk '{print $5}' >> /tmp/mfsfilesize.txt
        else
            echo "$file" >> /tmp/mfsnotexists.txt
        fi
done
cat /tmp/mfsfilesize.txt | awk '{total=$1+total} END{print "total_size: ",total/1024/1024,"M"}'
