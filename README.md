# 定时任务状态监控

[![ssl](https://github.com/i18n-cron/cron/actions/workflows/ssl.yml/badge.svg)](https://github.com/i18n-cron/cron/actions/workflows/ssl.yml)
[![cname flatten](https://github.com/i18n-cron/cname_cron/actions/workflows/cname_flatten.yml/badge.svg)](https://github.com/i18n-cron/cname_cron/actions/workflows/cname_flatten.yml)

# 使用说明

在 `github` 上创建 [token](https://github.com/settings/tokens)，并配置到私密变量 `GH_PAT`。

在同一个组织下面创建一个私密仓库 [conf](https://github.com/i18n-cron/conf) 设置配置的环境变量。

建议用一个单独的 `cron` 组织，避免 `github action` 超时。
