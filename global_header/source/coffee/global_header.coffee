init_global_header = ->
  $search = $('.main-nav__search').find('input');
  $search_icon_font = $('.main-nav__search').find('i');  

  # Event registers
  $search.on 'focus', ->
    $search_icon_font.css({'color': 'black'})
  $search.on 'blur', ->
    $search_icon_font.css({'color': '#b4b4b4'})
  
