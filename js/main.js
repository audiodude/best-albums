var albumTemplate = null;
var spotifyTemplate = null;

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

function initWithAlbums(data) {
  for(var i=0; i<data.albums.length; i++) {
    $('#albums-cont').prepend(Mustache.render(albumTemplate, data.albums[i]))
  }

  $('#albums-cont').masonry({
    gutter: 10,
    itemSelector: '.album'
  });

  $('.album-small').click(function() {
    $('#collapse-all').show();
    $(this).hide();
    var albumLarge = $(this).next('.album-large')
    albumLarge.show();
    showSpotifyEmbed(albumLarge);

    $('#albums-cont').masonry();
  });

  $('.album-large .fa-compress').click(function() {
    $(this).parent('.album-large').hide();
    $(this).parent('.album-large').prev('.album-small').show();

    if ($('.album-large:visible').length <= 0) {
      $('#collapse-all').hide();
    }

    $('#albums-cont').masonry();
  });

  $('#collapse-all span').click(function() {
    $('.album-large:visible').each(function(i, album) {
      $(album).hide();
      $(album).prev('.album-small').show();
      $('#collapse-all').hide();
      $('#albums-cont').masonry();
    });
  });
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
