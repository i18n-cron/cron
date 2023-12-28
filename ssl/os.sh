#!/usr/bin/env bash

set -ex

id ssl 2>/dev/null || useradd -m ssl

echo "ssl:$SSHPASS" | chpasswd

NGINX_RESTART='ssl ALL=(ALL) NOPASSWD:/usr/bin/systemctl reload nginx'

# 给 ssl 用户添加 systemctl nginx reload 的权限

cat /etc/sudoers | grep "$NGINX_RESTART" || echo "$NGINX_RESTART" >>/etc/sudoers

# 把 ssl 用户添加到 www 用户组
usermod -a -G www-data ssl

mkdir -p /opt/ssl
chown ssl:www-data /opt/ssl
chmod 750 /opt/ssl

sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

systemctl restart ssh

if command -v zsh &>/dev/null; then
  sh=$(which zsh)
else
  sh=$(which bash)
fi

usermod -s $sh ssl
