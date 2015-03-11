require 'json'

RE_ARTIST = /\A<p><strong>([^<]+)<\/strong><\/p>\n/
RE_ALBUM = /\A<p>(?:<em>)?(?:<a href="([^"]+)">)?(?:<em>)?([^<]+)(?:<\/em>)?(?:<\/a>)?(?:<\/em>)?<\/p>\n/
RE_IFRAME = /(?:\n<p>)?<iframe.*src=".*album\/([^"]+)".*<\/iframe>/

data = nil
File.open(ARGV[0]) do |data_file|
  data = JSON.load(data_file)
end

albums = []
data['posts'].each do |post|
  album = {
    slug: post['slug'],
    timestamp: post['unix-timestamp'],
    photo_url_lg: post['photo-url-400'],
    photo_url_sm: post['photo-url-100'],
  }
  html = post['photo-caption']
  html.match(RE_ARTIST) do |md|
    album['artist'] = md.captures[0]
    html = html[md.end(0)...html.size]
  end

  html.match(RE_ALBUM) do |md|
    # puts md.captures[1]
    album['link'] = md.captures[0]
    album['album'] = md.captures[1]
    html = html[md.end(0)...html.size]
  end

  html.match(RE_IFRAME) do |md|
    album['spotify_id'] = md.captures[0]
    html = html[0...md.begin(0)]
  end

  album['html'] = html
  albums << album
end

puts JSON.generate(albums: albums)
