import json
import re
import sys

RE_IFRAME = re.compile(r'<iframe.*src=".*album/([^"]+)".*</iframe>')

with open(sys.argv[1]) as data_file:
  data = json.load(data_file)

output = []
for post in data['posts']:
  out = {}
  html = post['photo-caption']
  md = RE_IFRAME.search(html)
  if md:
    out['spotify_id'] = md.groups(1)
    html = html[:md.start(1)]

  out['html'] = html
  output.append(out)
    
    
