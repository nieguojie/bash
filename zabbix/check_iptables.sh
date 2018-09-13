cat check_iptables.sh
#!/bin/bash
a=$(/sbin/iptables -nvL | wc -l)
if [[ $a == 8 ]];then
    echo 0
else
    echo 1
fi
