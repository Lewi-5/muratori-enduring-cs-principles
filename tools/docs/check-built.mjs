import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')
const dist = path.join(root, 'docs/.vitepress/dist')
const pages = new Map()
for (const f of fs.readdirSync(dist, { recursive: true })) {
  if (f.endsWith('.html')) pages.set('/' + f.replaceAll('\\', '/'), fs.readFileSync(path.join(dist, f), 'utf8'))
}
let checked=0
const errors=[]
for (const [file, html] of pages) {
  const duplicate=new Set()
  for (const m of html.matchAll(/\bid="([^"]+)"/g)) {
    if(duplicate.has(m[1])) errors.push(`Duplicate fragment ${file}#${m[1]}`)
    duplicate.add(m[1])
  }
  for (const m of html.matchAll(/href="([^"\s]+)"/g)) {
    const href=m[1].replaceAll('&amp;','&')
    if (/^(?:https?:|mailto:|data:)/.test(href)) continue
    const url=new URL(href, 'http://local'+file)
    const target=decodeURIComponent(url.pathname)
    if (!target.startsWith('/')) continue
    let key=target.endsWith('/') ? target+'index.html' : target
    if(!path.posix.extname(key)) key+='.html'
    if (target.startsWith('/files/') || target.startsWith('/assets/') || target.endsWith('.css')) {
      if(!fs.existsSync(path.join(dist,target))) errors.push(`Missing asset ${file} -> ${target}`)
    } else if (pages.has(key)) {
      const fragment=decodeURIComponent(url.hash.slice(1))
      if(fragment && !pages.get(key).includes(`id="${fragment}"`)) errors.push(`Missing fragment ${file} -> ${key}#${fragment}`)
    } else errors.push(`Missing page ${file} -> ${key}`)
    checked++
  }
}
const indexes=fs.readdirSync(path.join(dist,'assets'), {recursive:true}).filter(f=>f.endsWith('.js') && /localSearchIndex|local-search-index|en\.[\w-]+\.js$/i.test(f))
if(!indexes.length) errors.push('No built local search index found')
for(const f of indexes) {
  const data=fs.readFileSync(path.join(dist,'assets',f),'utf8')
  if(/\\?\/solutions\\?\/|\\?\/materials\\?\/|\\?\/source\\?\//.test(data)) errors.push(`Spoiler route in search index ${f}`)
}
if(errors.length) { const unique=[...new Set(errors)]; console.error(`${unique.length} issues:\n`+unique.slice(0,60).join('\n')); process.exit(1) }
console.log(`PASS: ${pages.size} rendered pages, ${checked} internal links/fragments/assets; solution routes absent from search index.`)
