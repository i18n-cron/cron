#!/usr/bin/env coffee

> esbuild
  @3-/zx:
  @3-/uridir
  @3-/read
  @3-/write
  path > join
  fs > existsSync

ROOT = uridir import.meta

dist = (name)=>
  cd ROOT
  await Promise.all [
    $"cd #{name} && direnv allow && direnv exec . ./build.sh"
    $"cd dist && rm -rf * && git checkout #{name} 2>/dev/null || git checkout -b #{name} && git pull || true"
  ]
  await esbuild.build({
    entryPoints: [
      "#{name}/lib/main.js"
    ]
    outfile: 'dist/run'
    bundle: true
    minify: true
    sourcemap: false
    format: 'esm'
    legalComments: 'none'
    platform: 'node'
    banner: {
      js: "import {createRequire as topLevelCreateRequire} from 'module';const require=topLevelCreateRequire(import.meta.url)"
    }
  })

  pkgjson = 'package.json'
  dpkgjson = 'dist/'+pkgjson

  if not existsSync dpkgjson
    write(
      dpkgjson
      '{"type":"module"}'
    )
    await $"cd dist && git add #{pkgjson}"

  await $"cd dist && chmod +x run && git add run && git commit -m. 2>/dev/null|| exit 0 && git push origin #{name}"
  return

{argv} = process
argv = argv.slice(2)

for i in (if argv.length then argv else 'ssl contabo.snapshot'.split(' '))
  console.log i
  await dist i


process.exit()
