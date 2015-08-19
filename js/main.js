var albumTemplate = null;
var spotifyTemplate = null;
var open_slugs = [];

function isEmpty(el){
  return !$.trim(el.html());
}

function showSpotifyEmbed(albumEl) {
  var spotifyEl = albumEl.find('.spotify');
  if (!isEmpty(spotifyEl)) {
    // Don't re-embed if there's already one there.
    return;
  }

  var spotifyId = spotifyEl.data('spotify-id');
  var spotifyHTML = Mustache.render(spotifyTemplate, {'spotify_id': spotifyId});
  spotifyEl.html(spotifyHTML);
}

function getHistoryHref() {
  var path = window.location.path || '';
  return (window.location.protocol + '//' + window.location.host + path + '#' +
          open_slugs.join('+'));
}

function expandAlbum(album, skip_history) {
  $('#collapse-all').show();
  $(album).hide();
  var albumLarge = $(album).next('.album-large')
  albumLarge.show();
  showSpotifyEmbed(albumLarge);

  if (!skip_history) {
    var slug = $(album).data('mini-slug');
    open_slugs.push(slug);
    history.pushState(
      {'open_slugs': open_slugs.slice(0)}, null, getHistoryHref());
  }

  $('#albums-cont').masonry();
}

function expandThisAlbum() {
  expandAlbum(this, false);
}

function collapseAlbum(album, skip_history) {
  $(this).parent('.album-large').hide();
  $(this).parent('.album-large').prev('.album-small').show();

  if ($('.album-large:visible').length <= 0) {
    $('#collapse-all').hide();
  }

  $('#albums-cont').masonry();
}

function collapseThisAlbum() {
  collapseAlbum(this, false);
}

function collapseAll(evt, skip_history) {
  $('.album-large:visible').each(function(i, album) {
    $(album).hide();
    $(album).prev('.album-small').show();
    $('#albums-cont').masonry();
  });
  $('#collapse-all').hide();
  if (!skip_history) {
    open_slugs = []
    history.pushState({'open_slugs': []}, null, getHistoryHref());
  }
}

window.addEventListener('popstate', function(event) {
  collapseAll(null, true);
  if (!event.state) {
    return;
  }
  open_slugs = event.state['open_slugs'];
  for(var i=0; i<open_slugs.length; i++) {
    var slug = open_slugs[i]
    var album = $('.album-small[data-mini-slug="' + slug + '"]').first();
    expandAlbum(album, true);
  }
});

function initWithAlbums(data) {
  for(var i=0; i<data.albums.length; i++) {
    $('#albums-cont').prepend(Mustache.render(albumTemplate, data.albums[i]))
  }

  $('#albums-cont').masonry({
    gutter: 10,
    itemSelector: '.album'
  });

  $('.album-small').click(expandThisAlbum);
  $('.album-large .fa-compress').click(collapseThisAlbum);
  $('#collapse-all span').click(collapseAll);
}

$(function() {
  // Load these serially to avoid a race condition/empty screen.
  $.get('/tmpl/album.mst', function(template) {
    albumTemplate = template;
    Mustache.parse(template);

    $.get('/tmpl/spotify.mst', function(template_1) {
      spotifyTemplate = template_1;
      Mustache.parse(template_1);

      $.ajax('/albums.json', {
        dataType: 'json',
        success: initWithAlbums
      });
    });
  });
})
