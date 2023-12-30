{
  env
} = process

MAP = {
  cname:=>
    env.CNAME
}

< ->
  {pathname} = new URL @url
  path = pathname.slice(1)

  func = MAP[path]
  if func
    return await func.call(@)

  if path == '6'
    url = 'https://api64.ipify.org'
    ip = '2607:f2d8:1:3c::3'
  else
    url = 'https://4.ipw.cn'
    ip = '114.132.191.12'
  console.log ip, url
  fTxt(
    url
    ip
    20000
  )

