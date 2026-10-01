import fs from 'node:fs'
import path from 'node:path'
import { prepare, weeks, prompts, root, out } from './prepare.mjs'

prepare()
const pages = new Map()
for (const p of fs.readdirSync(out, { recursive: true })) {
  if (!p.endsWith('.md') || p.replaceAll('\\', '/').startsWith('public/')) continue
  const key = p.replaceAll('\\', '/').slice(0, -3)
  pages.set('/' + key, fs.readFileSync(path.join(out, p), 'utf8'))
}
let count = 0
for (const w of weeks) {
  const authored = fs.readFileSync(path.join(root, `docs/content/weeks/${w.slug}.md`), 'utf8')
  const chapter = pages.get(`/weeks/${w.slug}`)
  const answers = pages.get(`/solutions/${w.slug}`)
  if (!answers.startsWith('---\nsearch: false')) throw new Error('Search spoiler: ' + w.slug)
  for (const id of Object.keys(w.exercises)) {
    if (authored.split(`<!-- exercise:${id} -->`).length !== 2) throw new Error(`Exercise must appear once: ${w.slug} ${id}`)
    for (const field of ['why', 'prerequisites', 'predict', 'steps', 'hint', 'evidence']) if (!w.exercises[id][field]?.trim()) throw new Error(`Missing ${field}: ${id}`)
  }
  const beginner = pages.get(`/beginners/${w.slug}`)
  const further = pages.get(`/further-reading/${w.slug}`)
  if (beginner) {
    // The beginner section's fixed shape (see the authoring guide and WRITINGFORBEGINNERS.md).
    for (const h of ['Purpose and prerequisites', 'Vocabulary', 'Concepts', 'Walk-through', 'Warm-ups', 'Check yourself', 'Ready for the lesson', 'Read alongside']) {
      if (!new RegExp(`^## ${h}\\b`, 'm').test(beginner)) throw new Error(`Beginner page ${w.slug} lacks "## ${h}"`)
    }
    if (!chapter.includes(`/beginners/${w.slug}`)) throw new Error(`Lesson ${w.slug} does not link its beginner section`)
  }
  if (further) {
    if (!/^### /m.test(further) || !further.includes('| Rung | Text | Section | Pages |')) throw new Error(`Further reading ${w.slug} has no cross-reference`)
    if (!chapter.includes(`/further-reading/${w.slug}`)) throw new Error(`Lesson ${w.slug} does not link its further reading`)
  }
  for (const p of prompts(w)) {
    const anchor = p.id.toLowerCase().replaceAll('.', '')
    const home = p.id.startsWith('W') ? beginner : p.id.startsWith('F') ? further : chapter
    if (!home?.includes(`{#${anchor}}`) || !answers.includes(`{#${anchor}}`)) throw new Error(`Missing coverage ${w.slug} ${p.id}`)
    count++
  }
}
// Internal page and asset targets are validated here; VitePress independently
// checks Markdown destinations during production build. Fragment checks run
// against the built HTML, where VitePress's actual slug rules are available.
for (const [origin, text] of pages) {
  // Directives named inside inline code (as in the authoring guide) are documentation, not directives.
  if (/<!-- (?:exercise:|readings|practice|report|contract-intro|warmup:|crossref|reading-questions)/.test(text.replace(/`[^`\n]*`/g, ''))) throw new Error(`Unexpanded directive: ${origin}`)
  const prose = text.replace(/^(`{3,}|~{3,})[^\n]*\n[\s\S]*?^\1\s*$/gm, '')
  for (const m of prose.matchAll(/\]\((\/[^\s)]+)\)/g)) {
    const target = decodeURI(m[1].split('#')[0])
    if (target.startsWith('/files/')) {
      if (!fs.existsSync(path.join(out, 'public', target))) throw new Error(`Missing asset ${origin} -> ${target}`)
    } else {
      const key = target.replace(/\.md$|\.html$/, '').replace(/\/$/, '/index')
      if (!pages.has(key)) throw new Error(`Missing page ${origin} -> ${target}`)
    }
  }
}
console.log(`PASS: ${weeks.length} lessons, ${count} prompt/answer pairs, ${pages.size} pages; sources and internal targets resolve.`)
