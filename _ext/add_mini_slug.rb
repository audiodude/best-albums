require 'json'
require 'optparse'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: add_mini_slug.rb [options] file-or-directory"

  opts.on('-d', '--data PATH',
          'Read and output to PATH, which will be overwritten. If not ' +
          'specified, this defaults to stdout and empty input data') do |path|
    options[:out_path] = path
  end
end
opt_parser.parse!(ARGV)
if ARGV.size != 0
  puts opt_parser.help
  exit 1
end

data = {}
File.open(options[:out_path]) do |data_file|
  data = JSON.load(data_file)
end

data['albums'].each do |album|
  album['mini-slug'] = album['slug'].split('-')[0..3].join('-')
end

JSON.dump(data, File.open(options[:out_path], 'w'))
