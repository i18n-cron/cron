#!/usr/bin/env coffee

> @3-/alissl
  @3-/dogessl
  @3-/baidussl
  @3-/zx > $raw
  @3-/retry
  ./CONF.js > HOST_RSYNC HOST_DNS HOST_RSYNC_HOOK
  fs > existsSync rmdirSync
  @3-/hwdns/acme.js:hwacme
  os > homedir
  path > join

{
  CONF
  MAIL
  NODE_ENV
} = process.env

IS_DEV = NODE_ENV!='production'

SSH = "sshpass -e ssh -q -o StrictHostKeyChecking=no -F "+join CONF, 'ssh_config'

HOME = homedir()

adir = join HOME,'.acme.sh'

acme = join adir,'acme.sh'

# known_hosts = join HOME, '.ssh/known_hosts'
# if not existsSync known_hosts
#   await $"mkdir -p ~/.ssh && touch #{known_hosts} && chmod -R 700 ~/.ssh"

if not existsSync acme
  await $"curl https://get.acme.sh | sh -s email=#{MAIL}"
  await $"rsync -av #{CONF}/ssl/acme.sh/ ~/.acme.sh"

HOST_ALL = new Set

rsync = (host, pc)=>
  HOST_ALL.add pc
  $raw"""rsync -e "#{SSH}" --exclude='*.conf' --chown=ssl:www-data --chmod=750 --delete -aAvz ~/.acme.sh/#{host}_ecc ssl@#{pc}:/opt/ssl"""

LOG = if IS_DEV then '--debug 2' else '>/dev/null'

hostSsl = (host)=>"#{join(adir,host)}_ecc"

_issue = (dns, host)=>
  console.log dns, host
  ssl = hostSsl host
  if not existsSync ssl
    tryed = 0
    server_li = ['--server google','','--server letsencrypt']
    for arg from server_li
      try
        await $raw"""#{acme} #{arg} --dns dns_#{dns} --issue -d "#{host}" -d "*.#{host}" #{LOG}"""
        break
      catch err
        rmdirSync ssl, { recursive: true, force: true }
        if IS_DEV
          throw err
        if ++tryed == server_li.length
          throw err
        console.error err

  Promise.all(
    for to from (HOST_RSYNC[host] or [])
      rsync host, to
  )

if not IS_DEV
  rsync = retry rsync
  _issue = retry _issue

issue = (dns, host)=>
  enable = await hwacme(host)
  try
    return await _issue(dns, host)
  finally
    await enable()
  return

for [dns, host_li] from Object.entries HOST_DNS
  for host from host_li
    # 貌似不能并发，不然会出错
    await issue dns, host

upload = await Promise.all(
  [
    alissl
    baidussl
    dogessl
  ].map (i)=>
    i()
)

for i from HOST_ALL
  hook = HOST_RSYNC_HOOK[i]
  if hook
    for cmd from hook
      await $raw"#{SSH} ssl@#{i} #{cmd}"

await upload

process.exit()
