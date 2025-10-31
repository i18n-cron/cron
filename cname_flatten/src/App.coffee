> @3-/cname_flatten:flatten
  @3-/uws/Err.js > NOT_FOUND

{
  env
} = process


< ->
  {path} = @
  console.log path
  # {pathname} = new URL @url
  # pathname = pathname.slice(1)
  args = path.split('/')
  if args.length == 4

    dns_type = {4:'A',6:'AAAA'}[args[0]]
    if dns_type
      # 4 3ti.site 3ti.site.s2-web.dogedns.com
      return flatten(dns_type,...args.slice(1))

  throw NOT_FOUND
  return
  # func = MAP[path]
  # if func
  #   return await func.call(@)

  # if path == '6'
  #   url = 'https://api64.ipify.org'
  #   ip = '2607:f2d8:1:3c::3'
  # else
  #   url = 'https://4.ipw.cn'
  #   ip = '114.132.191.12'
  # console.log ip, url
  # fTxt(
  #   url
  #   ip
  #   20000
  # )
