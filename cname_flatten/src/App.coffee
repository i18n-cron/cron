> @3-/cname_flatten:flatten

{
  env
} = process


< ->
  {pathname} = new URL @url
  path = pathname.slice(1)

  args = path.split('/')
  if args.length == 4
    if ['A','AAAA'].includes args[0]
      # A 3ti.site 3ti.site.s2-web.dogedns.com
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
