require 'json'

RE_IFRAME = /(?:\n<p>)?<iframe.*src=".*album\/([^"]+)".*<\/iframe>/

data = nil
File.open(ARGV[0]) do |data_file|
  data = JSON.load(data_file)
end

albums = []
data['posts'].each do |post|
  album = {}
  html = post['photo-caption']
  html.match(RE_IFRAME) do |md|
    album['spotify_id'] = md.captures[0]
    html = html[0...md.begin(0)]
  end

  album['html'] = html
  albums << album
end

puts JSON.generate(albums: albums)
    
    
