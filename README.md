centos7.9 目前还有大批的用户，由于centos7.9默认的内核版本是3.10，无法开启内核的BBR，所以需要首先升级内核再开启BBR.

这是一个简单的脚本
使用方法

git clone https://github.com/alfiy/centos7-bbr-enable.git

cd centos7-bbr-enable
sudo chmod +x tcp.sh

./tcp.sh

## tcp bbr 加速脚本

