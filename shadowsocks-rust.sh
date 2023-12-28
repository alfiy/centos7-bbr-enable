#!/bin/bash

# 生成随机端口号和密码
random_port=$((1024 + RANDOM % (9999 - 1024 + 1)))
random_password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')

# 安装依赖
yum install -y yum-utils epel-release && \
yum-config-manager --enable epel

# 安装teddysun.repo源
yum-config-manager --add-repo https://dl.lamp.sh/shadowsocks/rhel/teddysun.repo

# 重建repo缓存
yum makecache
wait

# 通过yum安装shadowsocks-rust
yum install -y shadowsocks-rust

# 定义配置文件路径
shadowsocks_rust_config="/etc/shadowsocks-rust/config.json"

# 创建目录和配置文件
mkdir -p "$(dirname "$shadowsocks_rust_config")" && touch "$shadowsocks_rust_config"

# 修改配置文件
cat > "$shadowsocks_rust_config" <<EOF
{
    "server": "0.0.0.0",
    "server_port": $random_port,
    "password": "$random_password",
    "timeout": 300,
    "method": "aes-256-gcm",
    "fast_open": false,
    "mode": "tcp_and_udp"
}
EOF

# 检查配置文件是否创建成功
if [ ! -f "$shadowsocks_rust_config" ]; then
    echo "Failed to create Shadowsocks-Rust config file."
    exit 1
fi

# 将端口加入防火墙
firewall-cmd --add-port=$random_port/tcp --zone=public --permanent && \
firewall-cmd --reload

# 启动服务并添加开机自启
systemctl start shadowsocks-rust-server && \
systemctl enable shadowsocks-rust-server

# 检查服务是否成功启动
if ! systemctl is-active --quiet shadowsocks-rust-server; then
    echo "Failed to start Shadowsocks-Rust server."
    exit 1
fi

echo "Shadowsocks-Rust 安装配置成功，请牢记以下配置."
echo "服务器端口: $random_port"
echo "密码: $random_password"
echo "加密: aes-256-gcm"
