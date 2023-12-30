#!/usr/bin/env coffee

> @3-/ipreq/fTxt.js
  ./App.js

process.on 'uncaughtException', (err)=>
  console.error('uncaughtException : ' + err)
  return

{env} = process

{
  PORT
} = env

# Bun.serve({
#   fetch(req) {
#     const url = new URL(req.url);
#     if (url.pathname === "/") return new Response("Home page!");
#     if (url.pathname === "/blog") return new Response("Blog!");
#     return new Response("404!");
#   },
# });
# To configure which port and hostname the server will listen on:
# 要配置服务器将侦听的端口和主机名：

PORT = Number.parseInt(PORT) || 3000

console.log 'http://127.0.0.1:'+PORT

Bun.serve({
  port: PORT
  fetch: (req) =>
    r = await App.call req
    if not (
      r.constructor == String \
      or \
      r instanceof Buffer \
      or \
      r instanceof Uint8Array
    )
      r = JSON.stringify(r)
    return new Response(r)
})
#   uWebSockets.js:uWs
#
# # https://github.com/uNetworking/uWebSockets.js/tree/master/examples
#
#
#
#
#
# do =>
#   uWs.App()
#     .get(
#       '/*'
#       (res, req) =>
#         url = req.getUrl().slice(1)
#         method = req.getMethod()
#         console.log method, url
#         res.onAborted =>
#           res.aborted = true
#           return
#         try
#           r = await app.call(
#             new Proxy(
#               {
#                 url
#               }
#               get: (self, name) =>
#                 {
#                   head:=>
#                     r = []
#                     self.forEach (k,v)=>
#                       r.push [k,v]
#                     r
#                   url:=>
#                 }[name]() or self[name]
#             )
#             res
#           )
#           if Array.isArray(r)
#             r = JSON.stringify r
#           code = '200'
#         catch err
#           console.error(
#             '❌'
#             method
#             url
#             err
#           )
#           r = err.toString()
#           code = '500'
#         if not res.aborted
#           res.cork =>
#             console.log r
#             res.writeStatus(code)
#             #.writeHeader('IsExample', 'Yes')
#             .end r
#             return
#         return
#     ).listen(
#       PORT
#       (listenSocket) =>
#         if listenSocket
#           console.log('LISTEN '+PORT)
#         return
#     )
#   return
