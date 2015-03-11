var albumTemplate = null;

function initWithAlbums(data) {
  for(var i=0; i<data.albums.length; i++) {
    $('#albums-cont').append(Mustache.render(albumTemplate, data.albums[i]))
  }
  $('#albums-cont').masonry({
    gutter: 10,
    itemSelector: '.album'
  });
  $('.album-small').click(function() {
    $(this).hide();
    $(this).next('.album-large').show();
    $('#albums-cont').masonry();
  });
}

$(function() {
  $.get('/tmpl/album.mst', function(template) {
    albumTemplate = template;
    Mustache.parse(template);
  });

  $.ajax('/albums.json', {
    dataType: 'json',
    success: initWithAlbums
  });
})
