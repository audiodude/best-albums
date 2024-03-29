SRC_MD_FILES != find _albums -name '*.md'
DST_GEM_FILES := $(SRC_MD_FILES:_albums/%.md=gemini/%/index.gmi)
PANDOC != command -v pandoc 2> /dev/null
RUBY != command -v ruby 2> /dev/null

best-albums.tgz: $(DST_GEM_FILES) gemini/index.gmi
	$(info creating tarball)
	@tar -czf best-albums.tgz gemini

clean:
	$(info deleting gemini directory)
	@rm -rf gemini
	$(info deleting output tarball)
	@rm -f best-albums.tgz

gemini/index.gmi: write_gemini_index.rb tmpl/index.gmi.erb
	$(info writing index)
	@$(RUBY) write_gemini_index.rb > gemini/index.gmi

gemini/%/index.gmi: _albums/%.md best-albums.lua text-gemini.tmpl
	$(info building $@)
	@mkdir -p $(dir $@)
	@$(PANDOC) \
		--to plain \
		--lua-filter best-albums.lua \
		--template text-gemini.tmpl \
		--columns 100000 \
		--output $@ \
		$<

upload: best-albums.tgz
	# Configure .ssh/config with username and IdentityFile before running this.
	$(info uploading to gem.bestalbumsintheuniverse.com)
	@scp best-albums.tgz tmoney@gem.bestalbumsintheuniverse.com:
	@ssh tmoney@gem.bestalbumsintheuniverse.com 'tar -xzf best-albums.tgz'

.PHONY: clean all upload
