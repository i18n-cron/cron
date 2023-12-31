> @3-/cname_flatten:flatten

{
  env
} = process


< ->
  {pathname} = new URL @url
  path = pathname.slice(1)

  for i from ['A/','AAAA/']
    if path.startsWith i
      args = path.split('/')
      # A 3ti.site 3ti.site.s2-web.dogedns.com
      if args.length == 3
        return flatten(...args)

 #
  # func = MAP[path]
  # if func
  #   return await func.call(@)

  '404'
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
