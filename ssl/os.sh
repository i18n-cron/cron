#!/usr/bin/env bash

set -ex

id ssl 2>/dev/null || useradd -m ssl

echo "ssl:$SSHPASS" | chpasswd

NGINX_RESTART='ssl ALL=(ALL) NOPASSWD:/usr/bin/systemctl reload nginx'

# 给 ssl 用户添加 systemctl nginx reload 的权限

cat /etc/sudoers | grep "$NGINX_RESTART" || echo "$NGINX_RESTART" >>/etc/sudoers

# 把 www-data 用户添加到 ssl 用户组
usermod -a -G ssl www-data

mkdir -p /opt/ssl
chown ssl:ssl /opt/ssl
chmod 750 /opt/ssl

sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

systemctl restart ssh

if command -v zsh &>/dev/null; then
  sh=$(which zsh)
else
  sh=$(which bash)
fi

usermod -s $sh ssl
