#!/bin/bash
source /etc/profile;
osver=`cat /etc/redhat-release | awk '{print $(NF-1)}' | cut -c1`
init_os6() {
local ip_addr=`ifconfig|grep addr:|grep -v HWaddr|grep -v 127.0.0.1|awk '{print $2}'|awk -F\: '{print $2}'|head -1`
echo  "$ip_addr   `hostname`" >>  /etc/hosts
#set server off
for CURSRV in `ls /etc/rc3.d/S*|cut -c 15-`
do
        case $CURSRV in
                sendmail | postfix )
                echo "change $CURSRV to off"
                chkconfig --level 235 $CURSRV off
                service $CURSRV stop
                ;;
        esac
done


#inittab mode 3
sed -i 's/id:.*$/id:3:initdefault:/g' /etc/inittab
sed -i 's@ca::ctrlaltdel:/sbin/shutdown -t3 -r now@#ca::ctrlaltdel:/sbin/shutdown -t3 -r now@' /etc/inittab

#set ulimit
sed -i '/ulimit/d' /etc/rc.local
echo "ulimit -SHn 200000" >> /etc/rc.local
sed -i "/^*/s/[0-9]\{4\}/4096/" /etc/security/limits.d/90-nproc.conf
sed -i "/^*/d" /etc/security/limits.conf
sed -i "/# End of file/d" /etc/security/limits.conf 
cat >> /etc/security/limits.conf << EOF
*        soft    nofile  200000
*        hard    nofile  200000
*        soft    nproc   200000
*        hard    nproc   200000
# End of file
EOF

#disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

#set epel
which wget ||  yum install wget -y &> /dev/null
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

#
sed -i '/PROMPT_COMMAND/d' /etc/profile
sed -i '/TMOUT/d' /etc/profile
cat >>/etc/profile  <<EOF
export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });logger "[euid=\$(whoami)]":\$(who am i):[\`pwd\`]"\$msg"; }'
HISTSIZE=1000000
HISTFILESIZE=200000
HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
EOF


#disable ip*tables
echo "alias net-pf-10 off" >> /etc/modprobe.d/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.d/modprobe.conf
/etc/init.d/iptables stop
> /etc/sysconfig/iptables
chkconfig ip6tables off
chkconfig iptables off

#disable sshd UseDNS
sed -i "/#UseDNS yes/c \UseDNS no" /etc/ssh/sshd_config
/etc/init.d/sshd reload

#set sysctl
mv /etc/sysctl.conf /etc/sysctl.conf.bak
\cp /tmp/sysctl.conf /etc/sysctl.conf
/sbin/sysctl -p

#update 
yum -y update  glibc glibc-devel glibc-common glibc-headers bash
yum -y install gcc gcc-c++ vim-enhanced unzip  sysstat cmake pcre-devel wget dos2unix
yum -y install ncurse ncurse-devel bison ntp git
yum -y install patch make gcc gcc-c++ flex bison file
yum -y install libtool libtool-libs autoconf kernel-devel
yum -y install libjpeg libjpeg-devel libpng libpng-devel  gd gd-devel
yum -y install freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel
yum -y install glib2 glib2-devel bzip2 bzip2-devel libevent libXpm-devel
yum -y install ncurses ncurses-devel curl curl-devel e2fsprogs
yum -y install e2fsprogs-devel krb5-devel libidn libidn-devel
yum -y install openssl openssl-devel vim-minimal  

yum -y install gettext gettext-devel
yum -y install gmp-devel
yum -y install fonts-chinese pspell-devel  libevent-devel
yum -y install iftop htop atop
yum -y install lrzsz telnet tree lsof
}

init_os7() {
#!/bin/bash
local ip_addr=`ifconfig  | grep inet | grep -v 127.0.0.1 |grep netmask | awk '{print $2}' |tail -n1`
echo  "$ip_addr   `hostname`" >>  /etc/hosts


#set ulimit
sed -i '/ulimit/d' /etc/rc.local
echo "ulimit -SHn 200000" >> /etc/rc.local
sed -i "/^*/s/[0-9]\{4\}/4096/" /etc/security/limits.d/20-nproc.conf
sed -i "/^*/d" /etc/security/limits.conf
sed -i "/# End of file/d" /etc/security/limits.conf 
cat >> /etc/security/limits.conf << EOF
*        soft    nofile  200000
*        hard    nofile  200000
*        soft    nproc   200000
*        hard    nproc   200000
# End of file
EOF

#disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config

#
sed -i '/PROMPT_COMMAND/d' /etc/profile
sed -i '/TMOUT/d' /etc/profile
sed -i '/HISTSIZE/d' /etc/profile
sed -i '/HISTFILESIZE/d' /etc/profile
sed -i '/HISTTIMEFORMAT/d' /etc/profile
cat >>/etc/profile  <<EOF
export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });logger "[euid=\$(whoami)]":\$(who am i):[\`pwd\`]"\$msg"; }'
HISTSIZE=1000000
HISTFILESIZE=2000000
HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
EOF

#set epel
which wget ||  yum install wget -y &> /dev/null
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo


#disable service
echo "alias net-pf-10 off" >> /etc/modprobe.d/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.d/modprobe.conf
yum -y install iptables iptables-services
/etc/init.d/iptables stop
> /etc/sysconfig/iptables
for i in iptables firewalld postfix sendmail
do
    systemctl stop $i
    systemctl disable $i
done

#disable sshd UseDNS
sed -i "/#UseDNS yes/c \UseDNS no" /etc/ssh/sshd_config
systemctl reload sshd

#set sysctl
mv /etc/sysctl.conf /etc/sysctl.conf.bak
\cp /tmp/sysctl.conf /etc/sysctl.conf
/sbin/sysctl -p


#update 
yum -y update  glibc glibc-devel glibc-common glibc-headers bash bash-completion
yum -y install gcc gcc-c++ vim-enhanced unzip  sysstat cmake pcre-devel wget dos2unix
yum -y install ncurse ncurse-devel bison ntp git
yum -y install patch make gcc gcc-c++ flex bison file
yum -y install libtool libtool-libs autoconf kernel-devel
yum -y install libjpeg libjpeg-devel libpng libpng-devel  gd gd-devel
yum -y install freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel
yum -y install glib2 glib2-devel bzip2 bzip2-devel libevent libXpm-devel
yum -y install ncurses ncurses-devel curl curl-devel e2fsprogs
yum -y install e2fsprogs-devel krb5-devel libidn libidn-devel
yum -y install openssl openssl-devel vim-minimal  
yum -y install gettext gettext-devel
yum -y install gmp-devel
yum -y install fonts-chinese pspell-devel  libevent-devel
yum -y install iftop htop atop
yum -y install lrzsz telnet tree lsof
}

case $osver in 
    6)
        init_os6
        ;;
    7)
        init_os7
        ;;
esac
