require 'erb'
require 'json'

begin
  json = File.open('_site/albums.json')
rescue
  puts "Could not open _site/albums.json. Did you run `jekyll build`?"
  exit 1
end

albums = JSON.load(json)['albums']
albums = albums.sort {|a, b| b['timestamp'] <=> a['timestamp']}

template_str = File.open('tmpl/index.gmi.erb').read
template = ERB.new(template_str, :trim_mode => '-')
puts template.result
