> @3-/fetch/fBin.js
  @3-/nt/loads.js

splitKeyLoad = (conf)=>
  r = {}
  for [host_li, val] in Object.entries(loads conf)
    for host in host_li.split('|')
      pre = r[host]
      if Array.isArray(pre)
        if Array.isArray(val)
          pre.push ...val
        else
          pre.push val
      else
        r[host] = [val]
  r

{
  HOST_RSYNC
  HOST_RSYNC_HOOK
  HOST_DNS
} = process.env

export HOST_RSYNC = splitKeyLoad HOST_RSYNC
export HOST_RSYNC_HOOK = splitKeyLoad HOST_RSYNC_HOOK
export HOST_DNS = loads HOST_DNS
