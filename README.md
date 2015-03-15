# Website for bestalbumsintheuniverse.com

The site is completely static, with all features being implemented in 
Javascript. The albums are read from the JSON file albums.json which can be
updated to add more albums to the site. There is no inherent ordering to the
albums.

## Re-generating the initial list of albums

To generate the intial list of albums, run the following command from the root
of the project:

`$ ruby _ext/process_tumblr_dump.rb _ext/best-albums-src.json > albums.json`

Note, the albums.json file is necessarily checked in, as it is part of the static site. So this step should not generally be necessary.
