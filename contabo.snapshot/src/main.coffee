#!/usr/bin/env coffee

> ./api.js

CPU_CORES_SNAPSHOT_LIMIT = {
  24:1
  10:4
  8:3
  6:2
  4:1
}

do =>
# 没做分页
  {data} = await api 'compute/instances'
  for {instanceId, displayName, cpuCores} from data
    limit = CPU_CORES_SNAPSHOT_LIMIT[cpuCores] or 1
    {data} = await api "compute/instances/#{instanceId}/snapshots"
    n = data.length
    console.log '❯', displayName, 'snapshots limit', limit
    for {snapshotId,createdDate} from data.reverse()
      if n < limit
        break
      console.log n--, 'rm', snapshotId, createdDate
      await api(
        "compute/instances/#{instanceId}/snapshots/#{snapshotId}"
        {
          method:"DELETE"
        }
      )
    await api.post(
      "compute/instances/#{instanceId}/snapshots"
      name: (new Date()).toISOString()[..18]
    )
