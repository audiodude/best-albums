module Jekyll
  module MyFilters
    def mtime(input)
      File.new(input).mtime.to_i
    end

    def slug(input)
      File.basename(input).split('.')[0]
    end

    def mini_slug(input)
      input.split('-')[0..3].join('-')
    end

    def xstrip(input)
      input.strip
    end
  end
end

Liquid::Template.register_filter(Jekyll::MyFilters)
