init_global_header = ->
  $search_wrap = $('.main-nav__search')
  $search = $search_wrap.find('input')
  $search_icon_font = $search_wrap.find('i')
  $nav_right = $('.main-nav--right')
  $nav_left = $('.main-nav')
  $nav_right_w = $nav_right.width()
  $nav_left_w = $nav_left.width()

  set_search_w = ->
    win_w = $(window).width()
    $search_wrap.width win_w - $nav_right_w - $nav_left_w - 40

  set_search_w()
  $(window).on "resize", ->
    set_search_w()


  if /dashboard/i.test(window.location.pathname)
    $('.main-nav__me').find('a').addClass('current-page')

  # Event registers
  $search.on 'focus', ->
    $search_icon_font.css({'color': 'black'})
  $search.on 'blur', ->
    $search_icon_font.css({'color': '#b4b4b4'})
  $search.on 'click', ->
    get_search_kws(0, 'user')
  $search.on 'keyup', ->
    get_search_kws(0, 'user')
  $search.on 'keydown', (e)->
    if e.which == 13
     check_search2()


