require 'json'
require 'optparse'
require 'yaml'

require 'redcloth'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: bester.rb [options] file-or-directory"

  opts.on('-f', '--force',
          'Force the update of an existing item in the data. If not set, ' +
          'existing items (with the same slug) will be skipped') do |force|
    options[:force] = true
  end

  opts.on('-d', '--data PATH',
          'Read and output to PATH, which will be overwritten. If not ' +
          'specified, this defaults to stdout and empty input data') do |path|
    options[:out_path] = path
  end
end
opt_parser.parse!(ARGV)
if ARGV.size == 0
  puts opt_parser.help
  exit 1
end

data = {'albums' => []}
if options[:out_path]
  File.open(options[:out_path]) do |data_file|
    data = JSON.load(data_file)
  end
end

def process_file(path)
  raise "Could not read file: #{path}" unless File.readable?(path)
  parts = []
  File.open(path) do |album_file|
    album_data = album_file.read
    parts = album_data.split("---\n")
    if parts.size != 3
      raise "No front matter detected in #{path}. This is required"
    end
  end

  album = YAML.load(parts[1])
  album['timestamp'] = File.new(path).mtime.to_i
  album['slug'] = File.basename(path).split('.')[0]
  album['mini-slug'] = album['slug'].split('-')[0..3].join('-')
  album['html'] = RedCloth.new(parts[2]).to_html
  return album
end

arg_path = ARGV[0]
if File.directory?(arg_path)
  # TODO:
  # Process each file in the top level of the directory. Does not work
  # recursively
else
  new_album = process_file(arg_path)

  found_idx = -1
  data['albums'].each_with_index do |album, i|
    found_idx = i if album['slug'] == new_album['slug']
    break if found_idx != -1
  end

  if found_idx != -1
    if options[:force]
      data['albums'][found_idx] = new_album
    end
  else
    data['albums'].insert(0, new_album)
  end
end

if options[:out_path]
  JSON.dump(data, File.open(options[:out_path], 'w'))
else
  puts JSON.dumps(data)
end

