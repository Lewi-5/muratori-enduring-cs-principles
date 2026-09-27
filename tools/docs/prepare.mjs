import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

export const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')
export const out = path.join(root, 'docs/.generated')
const read = p => fs.readFileSync(path.join(root, p), 'utf8').replaceAll('\r\n', '\n')
const json = p => JSON.parse(read(p))
export const weeks = json('tools/docs/catalogue.json')
export const files = json('tools/docs/files.json')
const allowed = new Set(files)
const emitted = new Set()
const generatedDirectories = ['week-05/instructor/fixtures/expected']
export const slug = s => s.toLowerCase().replace(/[^\p{L}\p{N}\s_-]/gu, '').replace(/\s+/g, '-')
export function sections(file) {
  const text = read(file)
  const matches = [...text.matchAll(/^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))\s*$/gm)]
  return { intro: text.slice(0, matches[0]?.index ?? text.length), entries: matches.map((m, i) => ({
    id: m[1], body: text.slice(m.index + m[0].length, matches[i + 1]?.index ?? text.length).trim(), file
  })) }
}
export function prompts(w) { return w.promptFiles.flatMap(f => sections(f).entries) }
function sourcePath(file) { return `source/${file.replace(/(^|\/)\.(?=[^/]+$)/, '$1dot-')}` }
function route(file) { return file.endsWith('.md') ? `/materials/${file.slice(0, -3)}` : `/${sourcePath(file)}.html` }
function linkTarget(raw, origin) {
  if (/^(?:https?:|mailto:|#)/.test(raw)) return raw
  const [filename, anchor] = raw.split('#')
  const dest = path.posix.normalize(path.posix.join(path.posix.dirname(origin), filename))
  if (dest.startsWith('docs/content/') && dest.endsWith('.md')) return '/' + dest.slice(13, -3) + (anchor ? `#${anchor}` : '')
  if (allowed.has(dest)) return route(dest) + (anchor ? `#${anchor}` : '')
  if (generatedDirectories.includes(dest)) return `/source-index/${dest}`
  if (files.some(f => f.startsWith(dest.replace(/\/$/, '') + '/'))) return `/source-index/${dest.replace(/\/$/, '')}`
  throw new Error(`Unlisted link ${origin}: ${raw} -> ${dest}`)
}
function rebase(text, origin) {
  return text.replace(/(!?\[[^\]\n]*\])\(([^\s)]+)([^)]*)\)/g, (all, label, dest, tail) => `${label}(${linkTarget(dest, origin)}${tail})`)
    .replace(/^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))\s*$/gm, (_, id) => `### ${id} {#${slug(id)}}`)
}
function write(file, text) {
  const dest = path.join(out, file)
  emitted.add(path.resolve(dest))
  fs.mkdirSync(path.dirname(dest), { recursive: true })
  if (!fs.existsSync(dest) || fs.readFileSync(dest, 'utf8') !== text) fs.writeFileSync(dest, text)
}
function front(search = true) { return `---\nsearch: ${search}\nprev: false\nnext: false\n---\n\n` }
function listing(file, lineAnchors = false) {
  if (!allowed.has(file)) throw new Error(`Unlisted source: ${file}`)
  const ext = path.extname(file).slice(1)
  const language = ({ h: 'c', sh: 'bash', py: 'python', Makefile: 'makefile' })[ext || path.basename(file)] || ext || 'text'
  const buf = fs.readFileSync(path.join(root, file))
  const content = ext === 'bin' ? buf.toString('hex').match(/.{1,2}/g)?.join(' ') || '(empty file)' : buf.toString('utf8')
  const fence = '`'.repeat(Math.max(3, ...[...content.matchAll(/`+/g)].map(m => m[0].length + 1)))
  const body = lineAnchors
    ? `<pre class="line-source"><code>${content.trimEnd().split('\n').map((line, i) => `<span id="L${i + 1}">${line.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;')}</span>`).join('\n')}</code></pre>`
    : `${fence}${ext === 'bin' ? 'text' : language}\n${content.trimEnd()}\n${fence}`
  return `\n**Repository file:** \`${file}\` · <a href="/files/${file}" download>Download original</a>\n\n${body}\n`
}
function sourceLinks(w, id) {
  return (w.exercises[id].sources || []).map(f => `<details><summary>Source: ${f}</summary>\n\n${listing(f)}\n</details>`).join('\n\n')
}
function readingBlock(w) {
  return `**Required and optional:** the listed viewing portions are required unless marked optional. Consult the specified standard and manual sections while working on the associated questions; they are references, not whole-document reading assignments. Beej is optional preparation when you need a gentler explanation.\n\n| Resource | Assigned portion | Why and when to use it |\n| --- | --- | --- |\n` + w.readings.map(r => `| ${r.resource} | ${r.portion} | ${r.purpose} |`).join('\n') +
    `\n\n**Gentler companion:** ${w.companion.map(r => `[${r.title}](${r.url})`).join('; ')}. Read these before the exercises when the C vocabulary is unfamiliar. These explain the language; the primary references above establish the exact contracts.\n\nComputer, Enhance! is a required subscription resource. The exercises here are original. Existing timing estimates and source-verification qualifications are retained in the [package guide](/materials/${w.slug}/README).\n`
}
function renderExercise(w, id) {
  const note = w.exercises[id]
  if (!note) throw new Error(`No guidance for ${w.slug} ${id}`)
  const parts = sections(`${w.slug}/learner/exercises.md`).entries.filter(p => p.id.startsWith(id + '.'))
  if (parts.length !== 2) throw new Error(`Missing contract pair ${w.slug} ${id}`)
  return `### ${id} · ${note.title}\n\n${note.why}\n\n**Ideas to bring:** ${note.prerequisites}.\n\n**Before you run:** ${note.predict}\n\n**Work through it:** ${note.steps}\n\n**Local work:** in \`${w.slug}\`, use \`make\` to compile and \`make test\` to check the package. The listings below are supplied scaffolds; the contract specifies what you implement or record.\n\n${sourceLinks(w, id)}\n\n` + parts.map(p =>
    `#### ${p.id} — ${p.id.endsWith('.C') ? 'contract and checks' : 'written reasoning'} {#${slug(p.id)}}\n\n${rebase(p.body, p.file)}\n\n[Compare with the ${p.id} answer after your attempt](/solutions/${w.slug}#${slug(p.id)}).`
  ).join('\n\n') + `\n\n::: details Hint for ${id}\n${note.hint}\n:::\n\n**Read your evidence:** ${note.evidence}\n`
}
function renderOther(w, kind) {
  const selected = prompts(w).filter(p => kind === 'practice' ? /^[PS]/.test(p.id) : /^R/.test(p.id))
  return selected.map(p => {
    const note = w.guidance[p.id]
    if (!note) throw new Error(`Missing guidance ${w.slug} ${p.id}`)
    return `### ${p.id} {#${slug(p.id)}}\n\n${note}\n\n${rebase(p.body, p.file)}\n\n[Compare with the ${p.id} answer](/solutions/${w.slug}#${slug(p.id)}).`
  }).join('\n\n')
}
function solutions(w) {
  const seen = new Set()
  let text = front(false) + `# Week ${w.n} solutions — spoilers\n\n[Return to the lesson](/weeks/${w.slug}). Make your predictions and attempt the work before comparing. These are complete reference answers, not the files used by the default learner build. Historical observations retain their original dates and platform qualifications.\n\n`
  for (const f of w.answerFiles) {
    const doc = sections(f)
    text += rebase(doc.intro.replace(/^# /gm, '## '), f) + '\n\n'
    for (const p of doc.entries) {
      if (seen.has(p.id)) throw new Error(`Duplicate answer ${p.id}`)
      seen.add(p.id)
      text += `### ${p.id} {#${slug(p.id)}}\n\n${rebase(p.body, f)}\n\n[Back to ${p.id}](/weeks/${w.slug}#${slug(p.id)}).\n\n`
    }
  }
  for (const p of prompts(w)) if (!seen.has(p.id)) throw new Error(`No answer ${w.slug} ${p.id}`)
  text += '## Reference source\n\n'
  for (const f of files.filter(f => f.startsWith(`${w.slug}/instructor/`) && /\.(?:c|h|sh)$/.test(f))) {
    text += `<details><summary>${f}</summary>\n\n${listing(f)}\n</details>\n\n`
  }
  text += `## Reports and validation\n\n` + files.filter(f => f.startsWith(`${w.slug}/instructor/`) && f.endsWith('.md')).map(f => `- [${f}](${route(f)})`).join('\n')
  return text
}
export function prepare() {
  emitted.clear()
  for (const f of files) if (!fs.existsSync(path.join(root, f))) throw new Error(`Missing allowlisted file ${f}`)
  const dirs = new Set()
  for (const dir of generatedDirectories) write(`source-index/${dir}.md`, front(false) + `# Generated fixture expectations\n\nThis directory is generated locally by the supplied oracle. From \`week-05\`, run \`make PACKAGE=instructor expected\` to recreate the reference outputs, or \`make expected\` for your learner fixtures. The website does not generate or substitute answers into your checkout. See the [fixture contract](/materials/week-05/instructor/fixtures/README).\n`)
  for (const f of files) {
    const dest = path.join(out, 'public/files', f)
    emitted.add(path.resolve(dest))
    fs.mkdirSync(path.dirname(dest), { recursive: true })
    fs.copyFileSync(path.join(root, f), dest)
    let dir = path.posix.dirname(f)
    while (dir !== '.') { dirs.add(dir); dir = path.posix.dirname(dir) }
    // Package documents are reference views. Keep them out of search to prevent
    // answer spoilers and duplicate hits; the authored chapters are searchable.
    if (f.endsWith('.md')) write(`materials/${f}`, front(false) + rebase(read(f), f))
    else write(`${sourcePath(f)}.md`, front(false) + `# ${path.posix.basename(f)}\n\n[Browse its folder](/source-index/${path.posix.dirname(f) === '.' ? 'root' : path.posix.dirname(f)})\n` + listing(f, f === 'rawTranscript.txt'))
  }
  for (const dir of dirs) write(`source-index/${dir}.md`, front(false) + `# Files: ${dir}\n\nThese files are read from the local course checkout when the site is built.\n\n` + files.filter(f => f.startsWith(dir + '/')).map(f => `- [${f.slice(dir.length + 1)}](${route(f)})`).join('\n'))
  write('source-index/root.md', front(false) + '# Course background files\n\n' + files.filter(f => !f.includes('/')).map(f => `- [${f}](${route(f)})`).join('\n'))
  for (const entry of fs.readdirSync(path.join(root, 'docs/content'), { recursive: true })) {
    if (!entry.endsWith('.md')) continue
    const relative = entry.replaceAll('\\', '/')
    const w = weeks.find(w => relative === `weeks/${w.slug}.md`)
    let text = read(`docs/content/${relative}`)
    text = text.replace(/\]\((\/source\/[^)#]+)(#[^)]*)?\)/g, (_, target, anchor = '') => `](${target.endsWith('.html') ? target : target + '.html'}${anchor})`)
    if (w) {
      text = text.replace(/<!-- exercise:(E\d{2}) -->/g, (_, id) => renderExercise(w, id))
        .replace('<!-- readings -->', readingBlock(w))
        .replace('<!-- practice -->', renderOther(w, 'practice'))
        .replace('<!-- report -->', renderOther(w, 'report'))
        .replace('<!-- contract-intro -->', rebase(sections(`${w.slug}/learner/exercises.md`).intro.replace(/^# /gm, '### ').replace(/^## /gm, '### '), `${w.slug}/learner/exercises.md`))
      text += `\n## Assessment and original package\n\n${rebase(read(`${w.slug}/rubric.md`).replace(/^# /gm, '### ').replace(/^## /gm, '### '), `${w.slug}/rubric.md`)}\n\n[Original package guide, commands, workload and cautions](/materials/${w.slug}/README) · [All package files](/source-index/${w.slug}) · [Full solutions](/solutions/${w.slug})\n`
    }
    write(relative, text)
  }
  for (const w of weeks) write(`solutions/${w.slug}.md`, solutions(w))
  write('reference/readings.md', front() + '# Readings and videos\n\nRead for a question, then return to code. The assigned portions below preserve the package reading tables; their verification status is recorded in the source audit. Durations are not guarantees of learner completion time.\n\n[Source audit and limitations](/reference/source-audit)\n\n' + weeks.map(w => `## Week ${w.n} · ${w.title}\n\n[Open the lesson](/weeks/${w.slug})\n\n${readingBlock(w)}`).join('\n'))
  // Retired allowlist entries must not remain exposed as stale generated pages
  // or downloads. Only remove files inside this fixed generated directory.
  for (const entry of fs.readdirSync(out, { recursive: true })) {
    const dest = path.resolve(out, entry)
    if (!dest.startsWith(path.resolve(out) + path.sep)) throw new Error(`Invalid generated path: ${dest}`)
    const info = fs.lstatSync(dest)
    if ((info.isFile() || info.isSymbolicLink()) && !emitted.has(dest)) fs.unlinkSync(dest)
  }
}
if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  prepare()
  console.log(`Prepared ${weeks.length} chapters and solution pages from ${files.length} allowlisted course files.`)
}
