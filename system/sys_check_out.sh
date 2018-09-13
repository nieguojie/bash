#!/bin/bash
Exec_date=`date +%Y%m%d`
Exec_dir=/root/sys_check/$Exec_date
Backup_date=`date +%Y%m%d%H`
Backup_dir=$Exec_dir/backup/$Backup_date
mkdir -p $Backup_dir
cd $Exec_dir
/bin/bash /usr/local/sbin/sys_check.sh &> /dev/null 
sleep 3
egrep '主机名称|系统CPU核数|系统CPU负载|系统内存总数|系统剩余缓存|系统磁盘占用情况|系统磁盘IO负载|系统TCP负载|系统IP负载|系统进程运行量|系统对应的服务端口|登录过系统的用户'   $Exec_dir/*_check.log >> sys_check_out_$Backup_date.log
ls |egrep -v 'backup|sys_check_out' |xargs -i mv -f {} $Backup_dir
