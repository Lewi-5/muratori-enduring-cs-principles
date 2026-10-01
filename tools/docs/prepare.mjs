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
// E = exercise (.C/.Q), P/S = practice/stretch, R = report, W = beginner warm-up, F = further-reading question.
const promptHeading = /^### ((?:E\d{2}\.[CQ])|(?:[PSRWF]\d{2}))\s*$/gm
export const readings = json('tools/docs/readings.json')
const pageExists = (dir, w) => fs.existsSync(path.join(root, `docs/content/${dir}/${w.slug}.md`))
export const beginnerWeeks = weeks.filter(w => pageExists('beginners', w))
export const readingWeeks = weeks.filter(w => pageExists('further-reading', w))
export function sections(file) {
  const text = read(file)
  const matches = [...text.matchAll(promptHeading)]
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
    .replace(promptHeading, (_, id) => `### ${id} {#${slug(id)}}`)
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
  const language = ({ h: 'c', sh: 'bash', py: 'python', s: 'text', S: 'text', hex: 'text', map: 'text', Makefile: 'makefile' })[ext || path.basename(file)] || ext || 'text'
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
    `\n\n**Gentler companion:** ${w.companion.map(r => `[${r.title}](${r.url})`).join('; ')}. Read these before the exercises when the C vocabulary is unfamiliar. These explain the language; the primary references above establish the exact contracts.\n\n` +
    (beginnerWeeks.includes(w) ? `**Beginner section:** [ease into Week ${w.n}](/beginners/${w.slug}) before the lesson. ` : '') +
    (readingWeeks.includes(w) ? `**Further reading:** [guided readings and the full cross-reference](/further-reading/${w.slug}) to the seven companion texts.\n\n` : (beginnerWeeks.includes(w) ? '\n\n' : '')) +
    `Computer, Enhance! is a required subscription resource. The exercises here are original. Existing timing estimates and source-verification qualifications are retained in the [package guide](/materials/${w.slug}/README).\n`
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
// ---- Beginner sections and further reading -------------------------------------------------
const TEXT_SHORT = { bhdik: 'But How Do It Know?', bgc: "Beej's Guide to C", bgclr: "Beej's C Library Reference", dis: 'Dive Into Systems', cs341: 'CS 341 Coursebook', csapp: 'CS:APP 3e', hp: 'Hennessy & Patterson 6e' }
const LEVEL_LABEL = { gentle: 'Gentle', bridge: 'Bridge', core: 'Core', deep: 'Deep', reference: 'Reference' }
const cell = s => String(s).replaceAll('|', '\\|')
function citation(id) {
  const s = readings.sections[id]
  if (!s) throw new Error(`Unknown reading section ${id}`)
  const [text, loc] = id.split(':')
  const label = text === 'bhdik' ? `“${s.title}”` : `§${loc} ${s.title}`
  const where = s.url ? `[${cell(label)}](${s.url})` : cell(label)
  const nb = str => str.replaceAll(' ', '&nbsp;') // keep "p. 151" and "PDF p. 144" on one line each
  const pages = s.url ? 'online' : text === 'bhdik' ? nb(`PDF p. ${s.pdf_page}`) : `${nb(`p. ${s.printed_page}`)} · ${nb(`PDF p. ${s.pdf_page}`)}`
  return { text: TEXT_SHORT[text], where, pages, level: LEVEL_LABEL[s.level] }
}
function readingTable(refs) {
  if (!refs.length) return ''
  return '| Rung | Text | Section | Pages | What to take from it |\n| --- | --- | --- | --- | --- |\n' + refs.map(r => {
    const c = citation(r.id)
    return `| ${c.level} | ${c.text} | ${c.where} | ${c.pages} | ${cell(r.why || '—')} |`
  }).join('\n')
}
function crossref(w) {
  const week = readings.weeks[String(w.n)]
  if (!week) throw new Error(`No cross-reference for ${w.slug}`)
  const blocks = week.crossref.map(row => {
    const m = readings.muratori[row.muratori]
    const source = m.url ? `[Open the episode page](${m.url}). ` : ''
    return `### ${m.title}\n\n${source}**Assigned portion:** ${row.portion}. **Mechanism:** ${row.mechanism}\n\n${readingTable(row.sections)}${row.gap ? `\n\n::: info Where the texts stop\n${row.gap}\n:::` : ''}`
  })
  const extra = week.extra.length ? `\n\n### Readings with no Muratori counterpart\n\nThese sections support the week's exercises directly rather than a particular video.\n\n${readingTable(week.extra)}` : ''
  return `Each block starts from a Computer, Enhance! or Handmade Hero item this week cites, then lists the sections of the companion texts that explain the same mechanism, from the gentlest rung to the deepest. Page numbers are the printed page first, then the page in the PDF. The [reading map](/reference/reading-map) shows every week at once.\n\n` + blocks.join('\n\n') + extra
}
function renderPrompt(w, id, file, kind) {
  const entry = sections(file).entries.find(p => p.id === id)
  if (!entry) throw new Error(`No ${kind} ${id} in ${file}`)
  const src = `${w.slug}/learner/src/${id.toLowerCase()}.c`
  const starter = allowed.has(src) ? `\n\n<details><summary>Starter: ${src}</summary>\n\n${listing(src)}\n</details>` : ''
  return `### ${id} {#${slug(id)}}\n\n${rebase(entry.body, file)}${starter}\n\n[Compare with the ${id} answer after your attempt](/solutions/${w.slug}#${slug(id)}).`
}
function readingMap() {
  const keys = Object.keys(TEXT_SHORT)
  const status = { complete: 'built', planned: 'planned', draft: 'draft map' }
  const rows = Object.entries(readings.weeks).map(([n, week]) => {
    const w = weeks.find(x => x.n === Number(n))
    const ids = [...week.crossref.flatMap(r => r.sections.map(s => s.id)), ...week.extra.map(s => s.id)]
    const cells = keys.map(k => [...new Set(ids.filter(id => id.startsWith(k + ':')))].map(id => {
      const s = readings.sections[id], loc = id.split(':')[1]
      const label = k === 'bhdik' ? s.title : loc
      return s.url ? `[${cell(label)}](${s.url})` : cell(label)
    }).join(', ') || '—')
    const title = w ? `[${n}](${readingWeeks.includes(w) ? `/further-reading/${w.slug}` : `/weeks/${w.slug}`})` : n
    return `| ${title} | ${status[week.status]} | ${cells.join(' | ')} |`
  })
  const texts = Object.entries(readings.texts).map(([k, t]) => `- **${TEXT_SHORT[k]}**: ${t.author}, *${t.title}*, ${t.edition}. ${t.role} ${t.access}`).join('\n')
  return front() + `# Reading map\n\nEvery week of the 52-week syllabus against the seven companion texts. Built weeks have a full cross-reference on their further-reading page; weeks marked *draft map* are a first pass from the syllabus and will be revised when the week is written. Section numbers are the books' own; Scott's book is cited by chapter title.\n\n${texts}\n\n| Week | Status | ${keys.map(k => TEXT_SHORT[k]).join(' | ')} |\n| --- | --- | ${keys.map(() => '---').join(' | ')} |\n${rows.join('\n')}\n`
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
      text += `### ${p.id} {#${slug(p.id)}}\n\n${rebase(p.body, f)}\n\n[Back to ${p.id}](/${p.id.startsWith('W') ? 'beginners' : p.id.startsWith('F') ? 'further-reading' : 'weeks'}/${w.slug}#${slug(p.id)}).\n\n`
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
    const bw = weeks.find(w => relative === `beginners/${w.slug}.md`)
    const rw = weeks.find(w => relative === `further-reading/${w.slug}.md`)
    // The catalogue defines published weekly packages. Other week pages may
    // be drafts under concurrent construction with unresolved directives.
    if (/^(weeks|beginners|further-reading)\/week-\d+\.md$/.test(relative) && !w && !bw && !rw) continue
    let text = read(`docs/content/${relative}`)
    if (bw) text = text.replace(/<!-- warmup:(W\d{2}) -->/g, (_, id) => renderPrompt(bw, id, `${bw.slug}/learner/warmups.md`, 'warm-up'))
    if (rw) text = text.replace('<!-- crossref -->', crossref(rw))
      .replace('<!-- reading-questions -->', () => sections(`${rw.slug}/learner/reading-questions.md`).entries.map(p => renderPrompt(rw, p.id, p.file, 'reading question')).join('\n\n'))
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
  write('reference/reading-map.md', readingMap())
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
