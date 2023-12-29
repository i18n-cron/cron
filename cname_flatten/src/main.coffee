#!/usr/bin/env coffee

> @huaweicloud/huaweicloud-sdk-core:core
  @huaweicloud/huaweicloud-sdk-dns/v2/public-api.js:dns
  @3-/sleep
  @3-/retry
  lodash-es > chunk
  @3-/u8/u8eq.js
  ./doh.js
  ./DNS.js:@ > DEFAULT_EDNS


default_view = 'default_view'


###

令牌申请
https://console.huaweicloud.com/iam/?locale=zh-cn#/mine/apiCredential

API 调试
https://console.huaweicloud.com/apiexplorer/#/openapi/DNS/sdk?api=ListPublicZones

###
{
  HW_AK
  HW_SK
  CNAME
} = process.env

endpoint = "https://dns.cn-north-4.myhuaweicloud.com"
project_id = ""

CNAME = (
  for i in CNAME.split("\n")
    i = i.trim()
    if i
      i.split(' ')
    else
      continue
)

credentials = new core.BasicCredentials()
.withAk(HW_AK)
.withSk(HW_SK)
.withProjectId(project_id)
client = dns.DnsClient.newBuilder()
.withCredential(credentials)
.withEndpoint(endpoint)
.build()

rm = retry (zoneId, recordsetId)=>
  if recordsetId.length
    for li from chunk(recordsetId,100)
      request = new dns.BatchDeleteRecordSetWithLineRequest()
      request.zoneId = zoneId
      body = new dns.BatchDeleteRecordSetWithLineRequestBody()
      body.withRecordsetIds(li)
      request.withBody(body)
      await client.batchDeleteRecordSetWithLine(request)
  return


create = retry (zoneId, type, name, all)=>
  if not all.length
    return

  for li from chunk(all,20)
    request = new dns.CreateRecordSetWithBatchLinesRequest()
    request.zoneId = zoneId
    body = new dns.CreateRSetBatchLinesReq()
    body.withLines li.map ([line,records])=>
      console.log 'new', name, type, line
      new dns.BatchCreateRecordSetWithLine()
            .withLine(line)
            .withRecords(records)
    body.withType(type)
    body.withName(name+'.')
    request.withBody(body)
    await client.createRecordSetWithBatchLines(request)
  return


recordsByZoneId = retry (zoneId, name, type)=>
  exist = new Map
  offset = 0
  limit = 500
  to_rm = []
  loop
    request = new dns.ShowRecordSetByZoneRequest()
    Object.assign(request, {
      zoneId
      limit
      type
      offset
      state: 'ACTIVE'
    })
    offset += limit
    {
      recordsets
      metadata:{
        total_count
      }
    } = await client.showRecordSetByZone(request)
    for i from recordsets
      if i.name.slice(0,-1) == name
        {id,line,records} = i
        pre = exist.get(line)
        if pre
          console.log '删除重复线路',line
          to_rm.push id
          continue
        records.sort()
        exist.set(line,[
          id
          records
        ])
    console.log total_count
    if offset >= total_count
      break
  console.log name, type+'记录条目数', exist.size
  await rm(zoneId, to_rm)
  return exist

zoneIdByName = retry (name)=>
  request = new dns.ListPublicZonesRequest()
  request.name = name
  result = await client.listPublicZones(request)
  loop
    if result.httpStatusCode == 200
      zoneId = result.zones[0]?.id
      if zoneId
        return zoneId
    console.error(result)
  return

main = =>
  for [type_li, name, default_host, cname] in CNAME
    zoneId = await zoneIdByName(name)
    if not zoneId
      console.error name, 'not found'
      continue
    for type from type_li.split(',')
      exist = await recordsByZoneId(zoneId, name, type)

      to_update = []
      to_create = []

      _doh = doh.bind(undefined,type)

      add = (line, li)=>
        if li.length
          pre = exist.get(line)
          if pre
            exist.delete(line)
            if u8eq(pre[1],li)
              console.log '✅',line,type,name,li.length
            else
              to_update.push [
                pre[0]
                li
              ]
          else
            to_create.push [
              line
              li
            ]
        return

      global = await _doh(default_host,DEFAULT_EDNS)
      add default_view, global
      global_ignore = new Set(global)
      ing = []

      for [line, edns, sub] from DNS
        ignore = structuredClone(global_ignore)

        li = await _doh(cname, edns)
        t = []
        for i in li
          if not ignore.has i
            ignore.add(i)
            t.push i
        add line,t

        add_no_ignore = (line, edns)=>
          li = await _doh(cname,edns)
          if not li.length
            console.log name, line, 'not found'
            return
          li = li.filter (i)=>not ignore.has i
          if not li.length
            console.log name, line, 'same as 默认区域'
            return
          add line,li
          return

        for i from Object.entries sub
          ing.push add_no_ignore(...i)

      await Promise.all ing

      await create zoneId, type, name, to_create
      if to_update.length
        for update_li from chunk(to_update, 50)
          request = new dns.BatchUpdateRecordSetWithLineRequest()
          request.zoneId = zoneId
          body = new dns.BatchUpdateRecordSetWithLineReq()

          body.withRecordsets update_li.map ([id, li])=>
            new dns.BatchUpdateRecordSet()
              .withId(id)
              .withRecords(li)

          request.withBody(body)
          await client.batchUpdateRecordSetWithLine(request)

      to_rm = []
      for [line,[id]] from exist.entries()
        if line == default_view
          continue
        to_rm.push id
        console.log 'rm line',name,type,line
      await rm zoneId, to_rm
      console.log 'done',name
  return

await main()
process.exit()
