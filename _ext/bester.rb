require 'json'
require 'yaml'

require 'redcloth'

if ARGV.size < 2
  puts 'usage: bester.rb json-file file-or-directory'
  puts 'The file or directory given as the final argument is processed and'
  puts 'added to the JSON data. The JSON file is overwritten as a result'
  exit 1
end

data = nil
File.open(ARGV[0]) do |data_file|
  data = JSON.load(data_file)
end

def process_file(path)
  raise "Could not read file: #{path}" unless File.readable?(path)
  parts = []
  File.open(path) do |album_file|
    album_data = album_file.read
    parts = album_data.split("---\n")
    if parts.size != 3
      raise "No front matter detected in markdown file. This is required"
    end
  end

  album = YAML.load(parts[1])
  album['html'] = RedCloth.new(parts[2]).to_html
  return album
end

arg_path = ARGV[1]
if File.directory?(arg_path)
  # TODO:
  # Process each file in the top level of the directory. Does not work
  # recursively
else
  data['albums'].insert(0, process_file(arg_path))
end

JSON.dump(data, File.open(ARGV[0], 'w'))

