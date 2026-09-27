import { defineConfig } from 'vitepress'
import { prepare, weeks, files, out, root } from '../../tools/docs/prepare.mjs'
import path from 'node:path'

const lessonItems = weeks.map(w => ({ text: `W${w.n} · ${w.title}`, link: `/weeks/${w.slug}` }))
export default defineConfig({
  title: 'Enduring CS Principles',
  description: 'From C source to evidence: six guided weeks of systems programming.',
  srcDir: '.generated',
  srcExclude: ['public/**'],
  cleanUrls: false,
  markdown: { lineNumbers: true },
  themeConfig: {
    nav: [
      { text: 'Start here', link: '/guide/start' },
      { text: 'Weeks', link: '/weeks/week-01' },
      { text: 'Readings and videos', link: '/reference/readings' },
      { text: 'Reference', link: '/reference/tools' },
      { text: 'Solutions', link: '/solutions/' }
    ],
    sidebar: [
      { text: 'Start here', items: [
        { text: 'Why this course', link: '/guide/start' },
        { text: 'Local setup', link: '/guide/setup' },
        { text: 'How to do a week', link: '/guide/how-to-study' }
      ] },
      { text: 'C, representation, and an experiment', items: lessonItems.slice(0, 5) },
      { text: 'From bytes to instructions', items: lessonItems.slice(5) },
      { text: 'Reference', items: [
        { text: 'Readings and videos', link: '/reference/readings' },
        { text: 'Tools and commands', link: '/reference/tools' },
        { text: 'Glossary', link: '/reference/glossary' },
        { text: '52-week syllabus', link: '/materials/PLAN' },
        { text: 'Maintaining the companion', link: '/guide/authoring' }
      ] },
      { text: 'Solutions — spoilers', collapsed: true, items: weeks.map(w => ({ text: `Week ${w.n} answers`, link: `/solutions/${w.slug}` })) }
    ],
    outline: { level: [2, 3] },
    search: { provider: 'local' },
    docFooter: { prev: 'Previous lesson', next: 'Next lesson' },
    footer: { message: 'Read here. Predict, build, and test in your local checkout.' }
  },
  vite: { publicDir: path.join(out, 'public'), plugins: [{
    name: 'course-source-watch',
    configureServer(server) { server.watcher.add(['docs/content', 'tools/docs', ...files].map(p => path.join(root, p))) },
    handleHotUpdate(ctx) {
      const file = ctx.file.replaceAll('\\', '/')
      if (file.includes('/docs/.generated/') || file.includes('/docs/.vitepress/')) return
      const relative = path.relative(root, ctx.file).replaceAll('\\', '/')
      if (relative.startsWith('docs/content/') || relative.startsWith('tools/docs/') || files.includes(relative)) {
        prepare()
        ctx.server.ws.send({ type: 'full-reload' })
        return []
      }
    }
  }] }
})
