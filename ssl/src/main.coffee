#!/usr/bin/env coffee

> @3-/alissl
  @3-/dogessl
  @3-/zx > $raw
  @3-/retry
  ./CONF.js > HOST_RSYNC HOST_DNS HOST_RSYNC_HOOK
  fs > existsSync
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

rsync = (host, ip)=>
  $raw"""rsync -e "#{SSH}" --exclude='*.conf' --chown=ssl:www-data --chmod=750 --delete -avz ~/.acme.sh/#{host}_ecc ssl@#{ip}:/opt/ssl"""

LOG = if IS_DEV then '--debug 2' else '>/dev/null'

issue = retry (dns, host)=>
  console.log dns, host
  ssl = hostSsl host
  if not existsSync ssl
    tryed = 0
    server_li = ['','--server letsencrypt']
    for arg from server_li
      try
        await $raw"#{acme} #{arg} --dns dns_#{dns} --issue -d #{host} -d *.#{host} #{LOG}"
        break
      catch err
        if ++tryed == server_li.length
          throw err
        console.error err

  Promise.all(
    for to from (HOST_RSYNC[host] or [])
      console.log '→',to
      rsync host, to
  )

hostSsl = (host)=>"#{join(adir,host)}_ecc"

ing = []

host_all = []
for [dns, host_li] from Object.entries HOST_DNS
  for host from host_li
    host_all.push host
    ing.push issue dns, host

await Promise.all ing
await Promise.all(
  (
    for i from host_all
      hook = HOST_RSYNC_HOOK[i]
      if hook
        $"#{SSH} ssl@#{i} #{hook}"
  ).concat [
    alissl
    dogessl
  ].map (i)=>i()
)

process.exit()
