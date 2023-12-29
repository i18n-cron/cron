# 定时任务状态监控

[![contabo 快照](https://github.com/i18n-cron/cron/actions/workflows/contabo.snapshot.yml/badge.svg)](https://github.com/i18n-cron/cron/actions/workflows/contabo.snapshot.yml)
[![ssl](https://github.com/i18n-cron/cron/actions/workflows/ssl.yml/badge.svg)](https://github.com/i18n-cron/cron/actions/workflows/ssl.yml)
[![cname flatten](https://github.com/i18n-cron/cname_cron/actions/workflows/cname_flatten.yml/badge.svg)](https://github.com/i18n-cron/cname_cron/actions/workflows/cname_flatten.yml)

# 容器构建状态监控

[![dev](https://github.com/i18n-ops/docker/actions/workflows/dev.yml/badge.svg)](https://github.com/i18n-ops/docker/actions/workflows/dev.yml)
[![nginx](https://github.com/i18n-ops/docker/actions/workflows/nginx.yml/badge.svg)](https://github.com/i18n-ops/docker/actions/workflows/nginx.yml)
[![mariadb](https://github.com/i18n-ops/docker/actions/workflows/mariadb.yml/badge.svg)](https://github.com/i18n-ops/docker/actions/workflows/mariadb.yml)

# 使用说明

在 `github` 上创建 [token](https://github.com/settings/tokens)，并配置到私密变量 `GH_PAT`。

在同一个组织下面创建一个私密仓库 [conf](https://github.com/i18n-cron/conf) 设置配置的环境变量。

建议用一个单独的 `cron` 组织，避免 `github action` 超时。
