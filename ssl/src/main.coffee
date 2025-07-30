#!/usr/bin/env coffee

> @3-/alissl
  @3-/dogessl
  @3-/baidussl
  @3-/zx > $raw
  @3-/retry
  ./CONF.js > HOST_DNS
  fs > readFileSync existsSync rmSync readdirSync writeFileSync
  @3-/hwdns/acme.js:hwacme
  os > homedir
  path > join

ROOT = process.cwd()

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
  await $"""curl https://get.acme.sh | sh -s email=#{MAIL} && sed -i '/^[[:space:]]*cat "\$CERT_PATH"[[:space:]]*$/d' ~/.acme.sh/acme.sh"""
  # wait for https://github.com/acmesh-official/acme.sh/pull/5263 merge
  dns_huaweicloud = join(adir, 'dnsapi', 'dns_huaweicloud.sh')
  writeFileSync(
    dns_huaweicloud
    readFileSync(dns_huaweicloud, 'utf8').replaceAll 'recordsets?name=${_domain}"', 'recordsets?name=${_domain}&status=ACTIVE"'
    'utf8'
  )
  await $"rsync -av #{CONF}/ssl/acme.sh/ ~/.acme.sh"

HOST_ALL = new Set

rsync = (host, pc)=>
  HOST_ALL.add pc
  $raw"""rsync -e "#{SSH}" --exclude='*.conf' --chown=ssl:ssl --chmod=750 --delete -avz ~/.acme.sh/#{host}_ecc ssl@#{pc}:/opt/ssl"""

LOG = if IS_DEV then '--debug 2' else '>/dev/null'

hostSsl = (host)=>"#{join(adir,host)}_ecc"

_issue = (dns, host)=>
  console.log dns, host
  ssl = hostSsl host
  if not existsSync ssl
    tryed = 0
    server_li = ['','--server letsencrypt','--server google']
    for arg from server_li
      try
        await $raw"""#{acme} #{arg} --ecc --dns dns_#{dns} --log --issue -d "#{host}" -d "*.#{host}" #{LOG}"""
        break
      catch err
        rmSync ssl, { recursive: true, force: true }
        if IS_DEV
          throw err
        if ++tryed == server_li.length
          throw err
        console.error err


if not IS_DEV
  rsync = retry rsync
  issue = retry _issue

hwIssue = (dns, host)=>
  enable = await hwacme(host)
  try
    return await issue(dns, host)
  finally
    await enable()
  return

for [dns, host_li] from Object.entries HOST_DNS
  for host from host_li
    # 貌似不能并发，不然会出错
    func =  if dns == 'huaweicloud' then hwIssue else issue
    await func dns, host

id_ed25519 = join(ROOT,'conf/ssh/id_ed25519')

await $"chmod 600 #{id_ed25519}"
process.env.GIT_SSH_COMMAND="ssh -i #{id_ed25519}"

cd '/tmp'
await $"rm -rf ssl && git clone --depth=1 git@github.com:i18n-cron/ssl.git"
cd 'ssl'

for i from readdirSync adir
  if i.endsWith '_ecc'
    await $"rm -rf #{i} && cp -R #{adir}/#{i} #{i}"

await $"git config user.email i18n.site@gmail.com && git config user.name i18n && git add . && git commit -m '#{new Date().toISOString().slice(0,10)}' && git push"

err_count = 0

for [project, upload] from Object.entries {
  alissl
  baidussl
  dogessl
}
  try
    await upload()
  catch err
    err_count += 1
    console.error project, err

process.exit(if err_count then 1 else 0)
