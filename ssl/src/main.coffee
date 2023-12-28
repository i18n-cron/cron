#!/usr/bin/env coffee

> @3-/alissl
  @3-/dogessl
  @3-/zx > $raw
  ./CONF.js > HOST_RSYNC HOST_DNS HOST_RSYNC_HOOK
  fs > existsSync
  os > homedir
  path > join

{
  CONF
  MAIL
} = process.env

SSH = "sshpass -e ssh -q -o StrictHostKeyChecking=no -F "+join CONF, 'ssh_config'

HOME = homedir()

adir = join HOME,'.acme.sh'

acme = join adir,'acme.sh'

# known_hosts = join HOME, '.ssh/known_hosts'
# if not existsSync known_hosts
#   await $"mkdir -p ~/.ssh && touch #{known_hosts} && chmod -R 700 ~/.ssh"

if not existsSync acme
  await $"curl https://get.acme.sh | sh -s email=#{MAIL} > /dev/null"

RSYNCED = new Set()

rsync = (host, ip)=>
  if not RSYNCED.has host
    RSYNCED.add host
  $raw"""rsync -e "#{SSH}" --exclude='*.conf' --chown=ssl:www-data --chmod=750 --delete -avz ~/.acme.sh/#{host}_ecc ssl@#{ip}:/opt/ssl"""

issue = (dns, host)=>
  console.log dns, host
  ssl = hostSsl host
  if not existsSync ssl
    await $"#{acme} --dns dns_#{dns} --issue -d #{host} -d *.#{host} > /dev/null"

  Promise.all(
    for to from (HOST_RSYNC[host] or [])
      console.log '→',to
      rsync host, to
  )

hostSsl = (host)=>"#{join(adir,host)}_ecc"

for [dns, host_li] from Object.entries HOST_DNS
  for host from host_li
    await issue dns, host

await Promise.all (
  for i from RSYNCED
    hook = HOST_RSYNC_HOOK[i]
    if hook
      $"#{SSH} ssl@#{i} #{hook}"
).concat [
  alissl
  dogessl
].map (i)=>i()

process.exit()
