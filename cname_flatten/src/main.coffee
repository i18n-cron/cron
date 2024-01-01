#!/usr/bin/env coffee
> ./App.js
  uWebSockets.js:uWs

# @3-/ipreq/fTxt.js

process.on 'uncaughtException', (err)=>
  console.error('uncaughtException : ' + err)
  return

{env} = process

{
  PORT
} = env

PORT = Number.parseInt(PORT) || 3000

console.log 'http://127.0.0.1:'+PORT

dump = (r)=>
  + json
  loop
    try
      if r.constructor == String
        json = true
    catch
      break
    json = (r instanceof Buffer) or (r instanceof Uint8Array)
    break

  if json
    r = JSON.stringify(r)
  return r

# Bun.serve({
#   port: PORT
#   fetch: (req) =>
#     r = await App.call(req)
#     return new Response(dump(r))
# })

# To configure which port and hostname the server will listen on:
# 要配置服务器将侦听的端口和主机名：


# https://github.com/uNetworking/uWebSockets.js/tree/master/examples
do =>
  uWs.App()
    .any(
      '/*'
      (res, req) =>
        path = req.getUrl().slice(1)
        method = req.getMethod()
        console.log method, path
        res.onAborted =>
          res.aborted = true
          return
        try
          r = dump await App.call(
            new Proxy(
              {
                path
                method
              }
              get: (self, name) =>
                func = {
                  head:=>
                    r = []
                    self.forEach (k,v)=>
                      r.push [k,v]
                    r
                }[name]
                if func then func() else self[name]
            )
            res
          )
          code = '200'
        catch err
          console.error(
            '❌'
            method
            path
            err
          )
          r = err.toString()
          code = '500'
        if not res.aborted
          res.cork =>
            console.log r
            res.writeStatus(code)
            #.writeHeader('IsExample', 'Yes')
            .end r
            return
        return
    ).listen(
      PORT
      (listenSocket) =>
        if listenSocket
          console.log('LISTEN '+PORT)
        return
    )
  return
