#!/usr/bin/env coffee

> uuid > v4:uuid

{default:KEY} = await import(process.env.CONTABO_KEY_JS)
body = new FormData()
body.append('grant_type','password')

for [k,v] from Object.entries(KEY)
  body.append(k,v)

req = (url, opt)=>
  retry = 9
  while --retry
    try
      r = await fetch(url,opt)
      break
    catch err
      console.trace()
      console.error url
      console.error err
  if r.status == 204
    return
  r = await r.json()
  if r.error
    throw r
  r

{access_token} = await req(
  'https://auth.contabo.com/auth/realms/contabo/protocol/openid-connect/token'
  {
    method: 'POST'
    body:new URLSearchParams body
  }
)

export default api = (url, opt={})=>
  req(
    'https://api.contabo.com/v1/'+url
    {
      headers: {
        'Content-Type': 'application/json'
        Authorization: 'Bearer '+access_token
        'x-trace-id':new Date - 0
        'x-request-id':uuid()
      }
      ...opt
    }
  )

api.post = (url, body)=>
  api url,{
    method: 'POST'
    body: JSON.stringify body
  }
