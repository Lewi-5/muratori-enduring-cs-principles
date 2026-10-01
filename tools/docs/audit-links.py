"""Check public resource reachability without treating it as citation validation."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import HTTPError
from urllib.parse import urldefrag, unquote
from html import unescape
import json, re
root=Path(__file__).resolve().parents[2]
catalogue=json.loads((root/'tools/docs/catalogue.json').read_text(encoding='utf-8'))
readings=json.loads((root/'tools/docs/readings.json').read_text(encoding='utf-8'))
# Companion-text sections (Beej, Dive Into Systems) and every Muratori item with a known URL, including draft weeks.
reading_urls={s['url'] for s in readings['sections'].values() if s.get('url')} | {m['url'] for m in readings['muratori'].values() if m.get('url')}
urls=sorted(set(re.findall(r'https?://[^\s)"<>]+',json.dumps(catalogue,ensure_ascii=False))) | reading_urls)
def check(url):
    try:
        with urlopen(Request(urldefrag(url)[0],headers={'User-Agent':'Mozilla/5.0 (course reference verification)'}),timeout=35) as r:
            content=r.read(3000000)
            html=content.decode('utf-8',errors='replace')
            title=re.search(r'<title[^>]*>(.*?)</title>',html,re.S)
            result={'url':url,'status':r.status,'finalUrl':r.url,'title':re.sub('<.*?>','',title[1]).strip() if title else None}
            fragment=unquote(urldefrag(url)[1])
            if fragment:
                result['fragment']=fragment
                result['fragmentFound']=fragment in re.findall(r'(?:id|name)=[\"\']([^\"\']+)',html)
            if url.startswith('https://beej.us/'):
                body=re.sub(r'<!--.*?-->|<style\b.*?</style>|<script\b.*?</script>','',html,flags=re.S)
                result['headings']=[unescape(re.sub('<.*?>','',h)).strip() for h in re.findall(r'<h[1-3]\b[^>]*>(.*?)</h[1-3]>',body,re.S)]
            if url.startswith('https://guide.handmadehero.org/'):
                # Retain public index timestamps and labels for manual review.
                result['indexedTimestamps']=sorted(set(re.findall(r'\b(?:\d{1,2}:)?\d{1,2}:\d{2}\b',re.sub('<[^>]+>',' ',html))))
            return result
    except Exception as e: return {'url':url,'status':getattr(e,'code',None),'error':str(e)}
with ThreadPoolExecutor(max_workers=8) as pool: results=list(pool.map(check,urls))
segments=[]
for week in catalogue:
    for reading in week['readings']:
        urls_in_reading=re.findall(r'https://guide.handmadehero.org/[^\s)]+',reading['resource'])
        for url in urls_in_reading:
            entry=next(r for r in results if r['url']==url)
            markers=re.findall(r'\b(?:\d{1,2}:)?\d{1,2}:\d{2}\b',reading['portion'])
            segments.append({'week':week['n'],'url':url,'portion':reading['portion'],'markersPresent':all(m in entry.get('indexedTimestamps',[]) for m in markers),'markers':markers})
report={'checkedAt':datetime.now(timezone.utc).isoformat(),'meaning':'Public page reachability, fragment existence, and assigned public index markers. No paid media accessed.','results':results,'assignedPublicSegments':segments}
(root/'tools/docs/link-audit.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
for r in results: print(r['status'],r['url'])
assert all(r['status']==200 and r.get('fragmentFound',True) for r in results), 'Unreachable resource or missing fragment'
assert all(s['markersPresent'] for s in segments), 'Assigned index marker missing'
