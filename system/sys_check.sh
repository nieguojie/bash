#!/bin/sh
#检查时间
Check_Time=$(date +"%Y-%m-%d-%H:%M:%S")
Exec_date=`date +%Y%m%d`
#echo $Check_Time

#系统IP地址
tmp_ip="`ip add|egrep '192.168.|172.31.' |grep 255 |awk '{print $2}'|awk -F '/' '{print $1}'|sed 's/ //g'|head -n1`"
c_ip="`echo -e $tmp_ip`"

#记录文件名称
log_file="${c_ip}_`date +"%Y%m%d%H"`_check.log"
report_file="${c_ip}_`date +"%Y%m%d%H"`_report.log"


##检查日志记录文件
function check_log()
{
  echo -e "[$c_ip][$Check_Time] $*\n" >> $log_file
}

##报告文件
function check_log_report()
{
  echo -e "$*\n" >> $report_file
}

####进入执行目录####
Exec_dir=/root/sys_check/$Exec_date
if [ ! -d $Exec_dir ]
 then
   mkdir -p $Exec_dir
   #进入目录
   cd $Exec_dir
   fi
mkdir -p $Exec_dir
cd $Exec_dir

#创建空文件
echo "">${log_file}
echo "">${report_file}

#####系统环境检查###
###检查操作系统的主机名称
u_hostname="`hostname`"
#echo $u_name
check_log "主机名称：$u_hostname"
check_log_report "主机名称：$u_hostname"


###检查操作系统的内核版本
u_name="`uname -a|awk '{print $1,$2}'`"
#echo $u_name
check_log "操作系统：$u_name"
check_log_report "操作系统：$u_name"


###系统运行的时间
up_time="`uptime|awk -F\, '{print $1}'`"
#echo $up_time
check_log "系统运行时间：$up_time"
check_log_report "系统运行时间：$up_time"


###检查操作系统的BASH环境
s_bash="`rpm -qa|grep bash-4.1.2-15.el6_5.2.x86_64`"
#echo $up_time
check_log "系统bash环境：$s_bash"
check_log_report "系统bash环境：$s_bash"


###检查操作系统的CPU负载
s_cpu_num="`grep 'model name' /proc/cpuinfo | wc -l`"
s_cpu_load="`uptime|awk '{print $8,$9,$10,$11,$12}'`"
#echo $up_time
check_log  "系统CPU核数：$s_cpu_num"
check_log  "系统CPU负载：$s_cpu_load"
check_log_report  "系统CPU核数：$s_cpu_num"
check_log_report  "系统CPU负载：$s_cpu_load"


###检查操作系统的内存
s_mem_num="`free -m|grep Mem|awk '{print $2}'`M"
s_mem_load="`free -m|awk '{print $4}'|tail -2|xargs`"
#echo $up_time
check_log "系统内存总数：$s_mem_num"
check_log "系统剩余缓存/swap：$s_mem_load"
check_log_report "系统内存总数：$s_mem_num"
check_log_report "系统剩余缓存/swap：$s_mem_load"


###检查操作系统的磁盘占用情况
s_hd_num="`df -h|awk '{print $1,$5}'|grep -v Use|xargs`"
#s_mem_load="`free -m|awk '{print $4}'|tail -2|xargs`"
#echo $up_time
check_log "系统磁盘占用情况：$s_hd_num"
check_log_report "系统磁盘占用情况：$s_hd_num"


###检查操作系统的磁盘IO负载
s_io_load="`iostat -x 1 1|awk '{print $1,$12}'|grep d |xargs`"
check_log "系统磁盘IO负载：$s_io_load"
check_log_report "系统磁盘IO负载：$s_io_load"


###检查操作系统的网络负载
s_net_load="`sar -n DEV 1 1|grep Average|grep -v IFACE|awk '{print $2,$3,$4}'|grep -v 0.00|xargs`"
check_log "系统网络负载(设备号,接收包,发送包)：$s_net_load"
check_log_report "系统网络负载(设备号,接收包,发送包)：$s_net_load"


###检查操作系统的TCP连接负载
s_tcp_load="`netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'|xargs`"
check_log "系统TCP负载：$s_tcp_load"
check_log_report "系统TCP负载：$s_tcp_load"


###检查操作系统的IP连接请求负载
s_ip_load="`netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F\: '{print $1}'|sort|uniq -c |sort -r -n|head -3|xargs`"
check_log "系统IP负载：$s_ip_load"
check_log_report "系统IP负载：$s_ip_load"


###检查操作系统的进程运行量
s_proc_load="`ps -aux|wc -l`"
check_log "系统进程运行量：$s_proc_load"
check_log_report "系统进程运行量：$s_proc_load"


###检查操作系统/var/log/message中的错误日志
s_msg_err="`grep -E -i "err|fail" /var/log/messages|grep -v grep|awk '{print $5,$10,$11}'|grep -iv log`"
check_log "系统message错误情况：$s_msg_err"
check_log_report "系统message错误情况：$s_msg_err"


###检查操作系统当前日期时间
s_msg_date="`date`"
check_log "系统当前日期时间：$s_msg_date"
check_log_report "系统当前日期时间：$s_msg_date"


##passwd 文件检查
passwd_file_mtime="`ls -l /etc/passwd|awk '{print $6,$7,$8}'`"
#echo $passwd_file_mtime
check_log "/etc/passwd 最后修改时间：$passwd_file_mtime"
check_log_report  /etc/passwd 最后修改时间：$passwd_file_mtime


##passwd 文件属性
passwd_file_chmod="`ls -l /etc/passwd|awk '{print $1}'`"
#echo $passwd_file_chmod
check_log "/etc/passwd 文件属性：$passwd_file_chmod"
check_log_report "/etc/passwd 文件属性：$passwd_file_chmod"


##UID 为 0 的用户情况
passwd_super_user="`awk -F: '$3==0 {print $1}' /etc/passwd|xargs`"
#echo $passwd_super_user
check_log "/etc/passwd UID0 用户：$passwd_super_user"
check_log_report "/etc/passwd UID0 用户：$passwd_super_user"


##group 文件检查
group_file_mtime="`ls -l /etc/group|awk '{print $6,$7,$8}'`"
#echo $passwd_file_mtime
check_log "/etc/group 最后修改时间：$group_file_mtime"
check_log_report  /etc/group 最后修改时间：$group_file_mtime


##group 文件属性
group_file_chmod="`ls -l /etc/group|awk '{print $1}'`"
#echo $passwd_file_chmod
check_log "/etc/group 文件属性：$group_file_chmod"
check_log_report "/etc/group 文件属性：$group_file_chmod"


##UID 为 0 的用户情况
group_super_user="`awk -F: '$3==0 {print $1}' /etc/group|xargs`"
#echo $passwd_super_user
check_log "/etc/group UID0 用户：$group_super_user"
check_log_report "/etc/group UID0 用户：$group_super_user"


##计划任务检查
#root cron
crontab -l > root.crontab
crontab -l -u user01 >user01.crontab
crontab -l -u user02 >user02.crontab
check_log "root 定时任务：`cat root.crontab`"
check_log "user01 定时任务：`cat user01.crontab`"
check_log "user02 定时任务：`cat user02.crontab`"
check_log_report "root/user01/user02 计划任务："


###检查操作系统为TCP连接的端口
s_tcp_monitor="`netstat -anpl|grep LISTEN|awk '/^tcp/'|awk '{print $4}'|awk -F\: '{print $2}'|sort -u|uniq|xargs`"
check_log "系统TCP打开的端口：$s_tcp_monitor"
check_log_report "系统TCP打开的端口：$s_tcp_monitor"


###检查操作系统为UDP连接的端口
s_udp_monitor="`netstat -anpl|grep LISTEN|awk '/^udp/'|awk '{print $4}'|awk -F\: '{print $2}'|sort -u|uniq|xargs`"
check_log "系统UDP打开的端口：$s_udp_monitor"
check_log_report "系统UDP打开的端口：$s_udp_monitor"


###检查操作系统对应的服务端口
s_server_monitor="`netstat -anpl|grep LISTEN|awk '/^tcp/'|awk '{print $4,$7}'|awk -F\: '{print $2}'|sort -u|uniq|xargs`"
check_log "系统对应的服务端口：$s_server_monitor"
check_log_report "系统对应的服务端口：$s_server_monitor"


###检查操作系统对应全开的规则
s_iptable_monitor="`iptables -vnL|awk '{if($10=="")print $0}'|grep -iE "ACCEPT|REJECT"|grep -v Chain|grep -Ev "icmp|lo"|xargs`"
check_log "系统异常的iptables规则：$s_iptable_monitor"
check_log_report "系统异常的iptables规则：$s_iptable_monitor"


##是否为root 用户或 异常用户登陆
user_login="`last -n 2|grep log|awk '{print $1}'|grep -ivE "user"`"
#echo $user_last_login
check_log "root或异常在线用户：$user_login"
check_log_report  "root或异常在线用户：$user_login"


##登陆系统的用户
who_login="`lastlog|grep -ivE "Never|Username|user"`"
check_log "登录过系统的用户：$who_login"
check_log_report "登录过系统的用户：$who_login"


##登陆系统失败的最近3个用户
w_date="`date|awk '{print $1,$2,$3}'`"
who_login_fail="`lastb|head -3|grep "$w_date"|awk '{print $1}'|xargs`"
check_log "登录系统失败的最近3个用户：$who_login_fail"
check_log_report "登录系统失败的最近3个用户：$who_login_fail"



##############服务检查############################
##系统日志检查
#/var/log/message 检查
#针对 cd|vi|vim|sh|\.\/|rz|sz|scp|rm|mv|cp|tar|unzip|iptables|tcpdump 扫描
#messages_log="`grep -iE "cd|vi|vim|sh|\.\/|rz|sz|scp|rm|mv|cp|tar|unzip|iptables|tcpdump" /var/log/messages|grep -v grep`"
#check_log "/var/log/message 异常情况：$messages_log"

#rsync 服务进程
rsync_num="`ps -ef|grep rsync.sh|grep -v grep|wc -l`"
check_log "运行的rsync数量：$rync_num"
check_log_report "运行的rsync数量：$rync_num"

#rsync 端口
rsync_port="`netstat -anpl|grep 873|grep LISTEN|awk '{print $4}'`"
check_log "运行的rsync监听端口：$rsync_port"
check_log_report "运行的rsync监听端口：$rsync_port"

#rsync 错误日志
r_date="`date +"%Y/%m/%d"`"
rsync_log_err="`grep -i err /var/log/rsyncd.log|grep "$r_date"|grep -ivE "configuration|protocol"`"
check_log "rsync错误日志：$rsync_log_err"
check_log_report "rsync错误日志：$rsync_log_err"


#################
#mysql 服务
#mysql_num="`ps -ef|grep mysql|grep -v grep|wc -l`"
#check_log "运行的mysql数量：$mysql_num"
#check_log_report "运行的mysql数量：$mysql_num"

#rsync 端口
#mysql_port="`netstat -anpl|grep 3306|grep LISTEN|awk '{print $4}'`"
#check_log "运行的mysql监听端口：$mysql_port"
#check_log_report "运行的rsync监听端口：$mysql_port"

#rsync 错误日志
#mysql_log_err="`grep -i err /var/log/rsyncd.log|grep `date +"%Y/%m/%d"`|grep -ivE "configuration|protocol"`"
#check_log "rsync错误日志：$rsync_log_err"
#check_log_report "rsync错误日志：$rsync_log_err"

#退出
exit 1
