var albumTemplate = null;

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
    $(this).next('.album-large').show();
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
  $.get('/tmpl/album.mst', function(template) {
    albumTemplate = template;
    Mustache.parse(template);
  });

  $.ajax('/albums.json', {
    dataType: 'json',
    success: initWithAlbums
  });
})
