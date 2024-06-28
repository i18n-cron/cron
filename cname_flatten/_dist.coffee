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
  await $"direnv allow && direnv exec . ./build.sh"
  run_js = 'lib/run.js'
  await esbuild.build({
    entryPoints: [
      "#{name}/lib/main.js"
    ]
    outfile: run_js
    bundle: true
    minify: false
    sourcemap: false
    format: 'esm'
    legalComments: 'none'
    platform: 'node'
    banner: {
      js: "import {createRequire as topLevelCreateRequire} from 'module';const require=topLevelCreateRequire(import.meta.url)"
    }
    external: [
      'uWebSockets.js'
    ]
    # loader: {
    #   ".node": "file",
    # }
  })

  # run = read run_js
  # p = run.indexOf('\n')+1
  # write(
  #   run_js
  #   run.slice(p)
  # )
  return

{argv} = process
argv = argv.slice(2)

await dist('.')

process.exit()
