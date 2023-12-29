#!/usr/bin/env coffee

> @3-/fetch/fJson.js
  @3-/retry

# 阿里云公共DNS安全传输服务介绍（DoH/DoT）https://alidns.com/articles/6018321800a44d0e45e90d71

TYPE = {
  AAAA: 28
  A: 1
}

export default main = retry (type, name, edns_client_subnet)=>
  options = {
    type
    name
  }
  if edns_client_subnet
    options.edns_client_subnet = edns_client_subnet

  url = 'https://dns.alidns.com/resolve?'+new URLSearchParams options

  r = []

  result = await fJson(url)

  {Answer} = result
  if Answer
    type = TYPE[type]
    for i in Answer
      if i.type == type
        r.push i.data
  else
    console.error(result)
  r = [...new Set(r)]
  r.sort()
  return r

# if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
#   name = 'i18n.site.s2-web.dogedns.com'
#   for type in 'A AAAA'.split(' ')
#     console.log await main(
#       name
#       type
#     )
#   process.exit()
