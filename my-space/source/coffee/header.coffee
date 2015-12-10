init = ->
  $search = $('.main-nav__search').find('input');
  $search_icon_font = $('.main-nav__search').find('i');
  $main_nav_right = $('.main-nav--right')
  

  # Event registers
  $search.on 'focus', ->
    $search_icon_font.css({'color': 'black'})
  $search.on 'blur', ->
    $search_icon_font.css({'color': '#b4b4b4'})
  
