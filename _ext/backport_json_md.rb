require 'json'
require 'pandoc-ruby'

data = nil
File.open(ARGV[0]) do |data_file|
  data = JSON.load(data_file)
end

albums = []
data['albums'].each do |album|
  converter = PandocRuby.new(album['html'], :from => :html, :to => :markdown)
  album['markdown'] = converter.convert

  File.open("_albums/#{album['slug']}.md", 'w') do |outfile|
    outfile.write(album['markdown'])
  end
end
