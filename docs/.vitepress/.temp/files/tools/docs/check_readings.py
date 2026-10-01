"""Verify (and optionally fill) the companion-reading citations in readings.json.

Run from Linux/WSL, where pypdf is installed:

    python3 tools/docs/check_readings.py          # verify
    python3 tools/docs/check_readings.py --fill   # fill missing title/page fields from the PDFs, then verify

The four local PDFs are copyrighted and never committed (see .gitignore). A missing
PDF is reported as SKIP for that text, not as a failure, so the structural checks
still run for anyone without the books. Web texts (Beej, Dive Into Systems) are
checked structurally here; `audit-links.py` checks their URLs and fragments online.
"""
import argparse, json, logging, re, sys
from pathlib import Path

root = Path(__file__).resolve().parents[2]
data_path = root / 'tools/docs/readings.json'
catalogue = json.loads((root / 'tools/docs/catalogue.json').read_text(encoding='utf-8'))
errors, notes = [], []

def norm(s):
    """Compare titles across OCR quirks: ligatures, split letters, punctuation, case."""
    s = s.replace('ﬁ', 'fi').replace('ﬂ', 'fl').replace('ﬀ', 'ff').replace('’', "'")
    return re.sub(r'[^a-z0-9]', '', s.lower())

class Book:
    """Section table and page text for one local PDF."""
    def __init__(self, key, filename):
        self.key, self.path = key, root / filename
        self.available = self.path.exists()
        self.reader, self._text = None, {}
        if self.available:
            import pypdf
            logging.disable(logging.CRITICAL)
            self.reader = pypdf.PdfReader(str(self.path))
            self.labels = list(self.reader.page_labels)

    def text(self, pdf_page):
        if pdf_page not in self._text:
            try:
                self._text[pdf_page] = self.reader.pages[pdf_page - 1].extract_text() or ''
            except Exception:
                self._text[pdf_page] = ''
        return self._text[pdf_page]

    def outline(self):
        rows = []
        def walk(items, depth=0):
            for item in items:
                if isinstance(item, list):
                    walk(item, depth + 1)
                else:
                    page = self.reader.get_destination_page_number(item) + 1
                    rows.append((item.title.strip(), page, self.labels[page - 1]))
        walk(self.reader.outline)
        return rows

    def contents_table(self, first, last, pattern):
        """Numbered entries from the book's own printed contents pages."""
        table = {}
        text = '\n'.join(self.text(p) for p in range(first, last + 1))
        for m in re.finditer(pattern, text, re.M):
            number, title = m.group(1), re.sub(r'(?: ?\.)+$', '', m.group(2)).strip()
            table.setdefault(number, (title, m.group(3)))
        return table

def csapp_header_page(book, printed):
    """CS:APP (3rd global ed. PDF) has no page labels; the printed number is in each running header."""
    guess = int(printed) - 8
    for pdf in sorted(range(max(1, guess - 20), min(len(book.reader.pages), guess + 20) + 1), key=lambda p: abs(p - guess)):
        first = book.text(pdf).strip().split('\n', 1)[0]
        m = re.match(r'^(\d{1,4}) Chapter \d', first) or re.search(r'^(?:Section|Chapter) .* (\d{1,4})$', first)
        if m and m.group(1) == str(printed):
            return pdf
    return None

def resolve(book, section):
    """Return (title, printed_page, pdf_page) for a section number or title key, or None."""
    k = book.key
    if k == 'csapp':
        table = book.__dict__.setdefault('_toc', book.contents_table(3, 14, r'^(\d{1,2}\.\d{1,2}(?:\.\d{1,2})?) (.+?) (\d{1,4})$'))
        if section not in table:
            return None
        title, printed = table[section]
        return title, printed, csapp_header_page(book, printed)
    if k == 'cs341':
        table = book.__dict__.setdefault('_toc', book.contents_table(2, 14, r'^(\d{1,2}(?:\.\d{1,2}){0,2}) (.+?)[ .]*?(\d{1,3})$'))
        if section not in table:
            return None
        title, printed = table[section]
        return title, printed, book.labels.index(printed) + 1 if printed in book.labels else None
    if k == 'hp':
        for title, page, label in book.outline():
            m = re.match(r'^(?:Chapter|Appendix) ([0-9A-Z]+):', title) or re.match(r'^([0-9A-Z]+\.[0-9]+)\. ', title)
            if m and m.group(1) == section:
                return title, label, page
        return None
    if k == 'bhdik':
        for title, page, label in book.outline():
            if norm(title) == norm(section):
                return title, None, page
        return None
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--fill', action='store_true', help='fill missing title/printed_page/pdf_page from the PDFs')
    args = parser.parse_args()
    data = json.loads(data_path.read_text(encoding='utf-8'))
    texts, sections, muratori = data['texts'], data['sections'], data['muratori']
    books = {k: Book(k, t['file']) for k, t in texts.items() if t.get('file')}
    for k, b in books.items():
        if not b.available:
            notes.append(f'SKIP {k}: {texts[k]["file"]} is not present; its page citations were not checked')

    # 1. Section entries: well formed, and (for local PDFs) matching the book itself.
    checked = 0
    for sid, s in sections.items():
        text_key, _, locator = sid.partition(':')
        if text_key not in texts:
            errors.append(f'{sid}: unknown text'); continue
        if s.get('level') not in {'gentle', 'bridge', 'core', 'deep', 'reference'}:
            errors.append(f'{sid}: bad level {s.get("level")}')
        if texts[text_key].get('url_base'):
            if not str(s.get('url', '')).startswith(texts[text_key]['url_base']):
                errors.append(f'{sid}: url must start with {texts[text_key]["url_base"]}')
            continue
        book = books[text_key]
        if not book.available:
            continue
        found = resolve(book, locator)
        if not found:
            errors.append(f'{sid}: section {locator!r} not found in {texts[text_key]["file"]}'); continue
        title, printed, pdf = found
        title = re.sub(r'^(?:Chapter|Appendix) [0-9A-Z]+: |^[0-9A-Z]+\.[0-9]+\. ', '', title)
        title = re.sub(r'\b([A-Z]) (?=[a-z])', r'\1', title.replace('ﬁ', 'fi').replace('ﬂ', 'fl'))  # OCR: "T opics"
        if args.fill:
            s.setdefault('title', title)
            if printed is not None:
                s.setdefault('printed_page', str(printed))
            s.setdefault('pdf_page', pdf)
        if norm(s.get('title', '')) != norm(title):
            errors.append(f'{sid}: title {s.get("title")!r} differs from the book {title!r}')
        if printed is not None and str(s.get('printed_page')) != str(printed):
            errors.append(f'{sid}: printed page {s.get("printed_page")} differs from the contents ({printed})')
        if s.get('pdf_page') != pdf:
            errors.append(f'{sid}: PDF page {s.get("pdf_page")} differs from the book ({pdf})')
        elif norm(s['title'])[:40] not in norm(book.text(pdf)):
            errors.append(f'{sid}: title text not found on PDF page {pdf}')
        checked += 1

    # 2. Week cross-references: every id resolves; every Muratori reading of a built week is covered.
    for n, week in data['weeks'].items():
        for row in week.get('crossref', []):
            if row['muratori'] not in muratori:
                errors.append(f'week {n}: unknown Muratori id {row["muratori"]}')
            for ref in row.get('sections', []):
                if ref['id'] not in sections:
                    errors.append(f'week {n}: unknown section {ref["id"]}')
        for ref in week.get('extra', []):
            if ref['id'] not in sections:
                errors.append(f'week {n}: unknown section {ref["id"]}')
    for w in catalogue:
        week = data['weeks'].get(str(w['n']))
        if not week or week.get('status') != 'complete':
            errors.append(f'week {w["n"]} has a lesson but no complete cross-reference'); continue
        covered = {muratori[r['muratori']]['url'] for r in week['crossref'] if r['muratori'] in muratori}
        for r in w['readings']:
            for url in re.findall(r'\]\((https://(?:www\.computerenhance\.com|guide\.handmadehero\.org)/[^)]+)\)', r['resource']):
                if 'table-of-contents' not in url and url not in covered:
                    errors.append(f'week {w["n"]}: reading {url} has no cross-reference row')
    for mid, m in muratori.items():
        if not set(map(str, m.get('weeks', []))) <= set(data['weeks']):
            errors.append(f'{mid}: cites a week with no entry')

    if args.fill:
        data_path.write_text(json.dumps(data, indent=1, ensure_ascii=False) + '\n', encoding='utf-8')
    for line in notes:
        print(line)
    if errors:
        print('\n'.join('FAIL ' + e for e in errors))
        sys.exit(1)
    rows = sum(len(w.get('crossref', [])) for w in data['weeks'].values())
    print(f'PASS: {len(sections)} sections ({checked} checked against local PDFs), {len(muratori)} Muratori items, '
          f'{rows} cross-reference rows across {len(data["weeks"])} weeks.')

if __name__ == '__main__':
    main()
