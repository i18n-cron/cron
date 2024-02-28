
运行 `./gen.setup.sh` ，复制命令到需要 ssl 的服务器运行

mac 调试需要安装 sshpass

```
brew tap esolitos/ipa
brew install esolitos/ipa/sshpass
```

修改 js 之后 , 记得运行 `../dist.sh` 来更新定期执行的脚本

上传的是泛域名证书 , 会自动更新所有子域的对象存储证书。

华为配置 cloudflare 自定义域名的 _acme-challenge.xxx.site 的 CNAME 要设置区域是 " 地域解析 -> 全球 " 而不是 " 全网默认 " , 否则会导致没法添加 TXT 记录而更新失败
