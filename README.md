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

## Adding a new album to the list

First, create a file in _albums. It should be of the format `artist-name-then-album-name-like-this.md'. The file name will be the unique identifier for the album. Notice the '.md' file extension, this is a markdown file. In fact, it is very similar to Jekyll blog post files, in that it has YAML front matter and a Markdown payload.

To see some of the fields that are supported, simply look at an existing entry:

```
---
artist: Rancid
album: ...And Out Come the Wolves
link: http://www.amazon.com/gp/product/B000001IQH/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B000001IQH&linkCode=as2&tag=besalbintheun-20&linkId=JU5NSW55HEMEZ4ZM
spotify_id: 596cCa6FfamS1WvGbIyFGl
photo_url_sm: http://i.imgur.com/wqOmMu3s.jpg
photo_url_lg: http://i.imgur.com/wqOmMu3l.jpg
---
Synopsis goes here and [uses Markdown](http://daringfireball.net/projects/markdown/syntax)
```

Finally, run the "bester" script:

`$ ruby _ext/bester.rb albums.json _albums/rancid-and-out-come-the-wolves.md`

Warning, this will overwrite your current albums.json file. Additionally, if you run the script multiple times it will currently add duplicate entries.