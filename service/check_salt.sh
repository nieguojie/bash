#!/bin/bash 
## check salt running status and repair
source /etc/profile;
master_tmp=0
broker_tmp=0
minion_tmp=0

master="salt-master"
master_log="check_salt_master.log"

broker="salt-broker"
broker_log="check_salt_broker.log"

minion="salt-minion"
minion_log="check_salt_minion.log"

master_check() {
test -e /etc/init.d/$master &> /dev/null
result=$?
if [ $result -ne 0 ];then
	master_tmp=0;
else
        master_tmp=1;
	echo -e "\n That's salt-master machine! \n"
fi
	
if [ $master_tmp -eq 1 ];then
        /etc/init.d/$master status &> /dev/null
        master_status=$?
        /usr/bin/nc -vz -w 5 localhost 4505 &> /dev/null
        master_port_status1=$?
        /usr/bin/nc -vz -w 5 localhost 4506 &> /dev/null
        master_port_status2=$?
if [ $master_status -ne 0 -o $master_port_status1 -ne 0 -o $master_port_status2 -ne 0 ];then 
        echo -e "\n" >> /var/log/salt/$master_log
        echo "$master restart in `date +"%F %T"`" >> /var/log/salt/$master_log
        /etc/init.d/$master restart &>> /var/log/salt/$master_log
        echo -e "\n" >> /var/log/salt/$master_log	
fi
fi

}
	
broker_check() {
test -e /etc/init.d/$broker &> /dev/null
result=$?
if [ $result -ne 0 ];then
	broker_tmp=0;
else
        broker_tmp=1;
	echo -e "\n That's salt-broker machine! \n"
fi

if [ $broker_tmp -eq 1 ];then
        /etc/init.d/$broker status &> /dev/null
        broker_status=$?
        /usr/bin/nc -vz -w 5 localhost 4505 &> /dev/null
        broker_port_status1=$?
        /usr/bin/nc -vz -w 5 localhost 4506 &> /dev/null
        broker_port_status2=$?
if [ $broker_status -ne 0 -o $broker_port_status1 -ne 0 -o $broker_port_status2 -ne 0 ];then
        echo -e "\n" >> /var/log/salt/$broker_log
        echo "$broker restart in `date +"%F %T"`" >> /var/log/salt/$broker_log
        /etc/init.d/$broker restart &>> /var/log/salt/$broker_log
        echo -e "\n" >> /var/log/salt/$broker_log
fi
fi
}

minion_check() {
test -e /etc/init.d/$minion &> /dev/null
result=$?
if [ $result -ne 0 ];then
	minion_tmp=0;
else
        minion_tmp=1;
	echo -e "\n That's salt-minion machine! \n"
fi

if [ $minion_tmp -eq 1 ];then
        /etc/init.d/$minion status &> /dev/null
        minion_status=$?
        /usr/bin/nc -vz -w 5 salt 4505 &> /dev/null
        minion_port_status1=$?
        /usr/bin/nc -vz -w 5 salt 4506 &> /dev/null
        minion_port_status2=$?
if [ $minion_status -ne 0 -o $minion_port_status1 -ne 0 -o $minion_port_status2 -ne 0 ];then
        echo -e "\n" >> /var/log/salt/$minion_log
        echo "$minion restart in `date +"%F %T"`" >> /var/log/salt/$minion_log
        /etc/init.d/$minion restart &>> /var/log/salt/$minion_log
        echo -e "\n" >> /var/log/salt/$minion_log
fi
fi
}

#process master check
master_check

#process broker check
broker_check

#process minion check
minion_check
