# 华为云 CNAME 拉平

华为云的 DNS 分地域线路的解析不要钱，果断弃用 DNSPOD。

基于 github aciton 全自动部署，流程如下：

1. [复刻并修改 `cname_cron/run.sh`](https://github.com/i18n-cron/cname_cron/blob/main/run.sh) (配置解读如下)

   ```
   CNAME="
   A,AAAA 3ti.site u-01.eu.org 3ti.site.s2-web.dogedns.com
   A,AAAA i18n.site i8.cloudns.biz i18n.site.s2-web.dogedns.com
   "
   ```

   其中 3ti.site 是网站域名，u-01.eu.org 是全网默认的 cname 指向（我这里用的 cloudflare 的 CNAME）u-01.eu.org , 第二个是中国大陆 CDN 的 cname。

   可以有多个网站，一行一个。会把他们都拉平。
2. [创建华为云访问秘钥](https://console.huaweicloud.com/iam/#/mine/accessKey)
3. [添加域名到华为云解析](https://console.huaweicloud.com/dns/#/dns/publiczones)
4. 配置 github action 的私密变量 `HW_AK` 和 `HW_SK` （如下图）

   ![](https://i-01.eu.org/2023/12/WRh2On9.webp)

5. 在网站根目录下创建一个 `.i` ，内容为小写的网站域名，比如 `i18n.site`，用来做效验。

6. 启用 [github action](https://github.com/i18n-cron/cname_cron/actions)，我配置的是每 15 分钟运行一次。

   ![](https://i-01.eu.org/2023/12/DKmHaXX.webp)

## 参考

* [使用华为云 DNS 拉平 CNAME 记录（CDN 场景）](https://r2wind.cn/articles/20230109.html)
