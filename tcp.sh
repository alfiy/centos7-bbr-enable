#!/bin/bash

# 1. 创建目录
cd /home
mkdir bbr
cd bbr
# 2. 下载内核
wget http://mirrors.coreix.net/elrepo-archive-archive/kernel/el7/x86_64/RPMS/kernel-lt-devel-5.4.226-1.el7.elrepo.x86_64.rpm &
wget http://mirrors.coreix.net/elrepo-archive-archive/kernel/el7/x86_64/RPMS/kernel-lt-headers-5.4.226-1.el7.elrepo.x86_64.rpm &
wget http://mirrors.coreix.net/elrepo-archive-archive/kernel/el7/x86_64/RPMS/kernel-lt-5.4.226-1.el7.elrepo.x86_64.rpm &
wait
# 3. 安装内核
rpm -ivh kernel-lt-5.4.226-1.el7.elrepo.x86_64.rpm &
rpm -ivh kernel-lt-devel-5.4.226-1.el7.elrepo.x86_64.rpm &
wait
# 4. 设置启动
# 设置启动顺序 
grub2-set-default 'CentOS Linux (5.4.226-1.el7.elrepo.x86_64) 7 (Core)'
wait
# 5. 安装BBR
echo 'net.core.default_qdisc=cake' | tee -a /etc/sysctl.conf &
echo 'net.ipv4.tcp_congestion_control=bbr' | tee -a /etc/sysctl.conf &
# sysctl -p
wait
# 6. 重启系统
reboot
