#!/usr/bin/env coffee

> esbuild

await esbuild.build({
  entryPoints: ["lib/main.js"]
  outfile: "cname.js"
  bundle: true
  minify: true
  sourcemap: false
  format: 'esm'
  legalComments: 'none'
  platform: 'node'
  banner: {
    js: "import { createRequire as topLevelCreateRequire } from 'module';\n const require = topLevelCreateRequire(import.meta.url);"
  }
})

process.exit()
