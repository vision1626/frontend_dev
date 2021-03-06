_menu_showed = false
_top_search_showed = false

init_global_header = ->
  $search_wrap = $('.main-nav__search')
  $search = $search_wrap.find('input')
  $search_icon_font = $search_wrap.find('i')
  $nav_right = $('.main-nav--right')
  $nav_left = $('.main-nav')
  $nav_right_w = $nav_right.width()
  $nav_left_w = $nav_left.width()

  set_search_w = ->
    if $(window).width() > 680
      win_w = $(window).width()
      $search_wrap.width win_w - $nav_right_w - $nav_left_w - 40

  set_search_w()
  $(window).on "resize", ->
    set_search_w()

  check_new_msg = ->
    $.ajax({
      url: SITE_URL + '/services/service.php?m=index&a=check_new_message',
      dataType: 'json'
      success: (result)->
        data = result.data
        if result.status == 0
          $('.fixed-nav_messages').html(0)
          $('.check-all').find('a').html("没有新消息")
        else 
          $('.fixed-nav_messages').html(result.sum)

          for d in data
            if d['type']=="1" && d['ge_sum']!="0"
              $('.get-likes').html("<i class='icon icon-heart'></icon>" + 
                "<a href='/home/msg_like' target='_blank'>" + "收到" +
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "条喜欢" + "</a>")
            if d['type']=="2" && d['ge_sum']!="0"
              $('.get-comments').html("<i class='icon icon-comment'></icon>" + 
                "<a href='/home/msg_comment' target='_blank'>" + "收到" +
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "条评论" + "</a>")
            if d['type']=="3" && d['ge_sum']!="0"
              $('.get-fans').html("<i class='icon icon-fans'></icon>" + 
                "<a href='/home/msg_follow' target='_blank'>" + "收到" +
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                  "个关注" + "</a>")
            if d['type']==4 && d['ge_sum']!="0"
              $('.get-recomendded').html("<i class='icon icon-news'></icon>" + 
                "<a href='/home/msg_system' target='_blank'>" + "收到" +
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "条系统消息" + "</a>")
            $('.check-all').find('a').html("知道了")
    })

  check_new_msg()

  setInterval ->
    check_new_msg()
  , 300000

  $('.check-all').on 'click', (e)->
    self = $(this)
    if $(this).find('a').html() == "知道了"
      $.ajax({
        url: SITE_URL + '/services/service.php?m=index&a=del_unread_message&_=1452061658478',
        type: 'get',
        dataType: 'json',
        success: (result)->
          if result.status == 1
            $('.check-all').prevAll().remove()
            $('.fixed-nav_messages.').text('0')
            $('.check-all').find('a').html("没有新消息")
      })

  if /dashboard/i.test(window.location.pathname)
    $('.main-nav__me').find('a').addClass('current-page')

  # Event registers
  $search.on 'focus', ->
    if !_is_mobile
      $search_icon_font.css({'color': 'black'})
  $search.on 'blur', ->
    if !_is_mobile
      $search_icon_font.css({'color': '#b4b4b4'})
    else
      closeNavSearch()
  $search.on 'click', ->
    if !_is_mobile
      get_search_kws(0, 'user')
  $search.on 'keyup', ->
    get_search_kws(0, 'user')
  $search.on 'keydown', (e)->
    if e.which == 13
     check_search2()

  $('.main-nav__publish').on 'click', ->
    if giveupEditing()
      $('.popup__blackbox').fadeIn(500)
      $('.popup').show()
      askUserToGetValidated()
      $('.popup__loading').hide()
    else
      return false

  switch MODULE_NAME
    when 'Index'
      $nav_left.find('.main-nav__home a').addClass('current-page')
    when 'Zixun'
      $nav_left.find('.main-nav__zixun a').addClass('current-page')
    when 'Dapei'
      $nav_left.find('.main-nav__c1 a').addClass('current-page')
    when 'Master'
      $nav_left.find('.main-nav__master a').addClass('current-page')


$(document).on 'mouseover','li.fixed-nav__flash-buy', ->
  $(this).find('.cart-link').addClass('cart-link_show')
  $(this).find('.order-link').addClass('order-link_show')
  $(document).find('li.fixed-nav__msg').find('ul.drop-down-list').removeClass('right').addClass('left')

$(document).on 'mouseleave','div.fixed-nav-container', ->
  $(this).find('.cart-link').removeClass('cart-link_show')
  $(this).find('.order-link').removeClass('order-link_show')
  $(document).find('li.fixed-nav__msg').find('ul.drop-down-list').removeClass('left').addClass('right')

$(document).on 'click','div.scroll-to-top', ->
  $('html, body').animate({scrollTop:0}, 500);

#$(document).on 'touchstart','a.menu-logout', (e) ->
#  e.preventDefault()
#  location.href = _logout_link

$(document).on 'touchend','.close-mobile-menu', (e) ->
  e.preventDefault()
  closeMenu()

$(document).on 'touchend','.top_hamburger', (e) ->
  e.preventDefault()
  if ACTION_NAME isnt 'login' and ACTION_NAME isnt 'register' and ACTION_NAME isnt 'forgetpassword'
    openMenu()
$(document).on 'touchstart','.main-nav__hamburger', (e) ->
  e.preventDefault()
  if ACTION_NAME isnt 'login' and ACTION_NAME isnt 'register' and ACTION_NAME isnt 'forgetpassword'
    openMenu()

openMenu = () ->
  if !_menu_showed
    $('.main-nav').hide()
    $('.profile-container').find('.content').hide()
    $('body, .wapper, .content_container, .fixed_menu').addClass('show-menu')
    afterMenuOpen()

afterMenuOpen = () ->
  $(document).on 'touchstart','div.content_container', (e) ->
    e.preventDefault()
    closeMenu()
  setTimeout ->
#    alert($(".menu-flashbuy-value").contents().find("body").html())
    _menu_showed = true
    $('.profile-container .content').addClass('absolute')
  , 200

closeMenu = () ->
  if _menu_showed
    $('.main-nav').show()
    $('.profile-container').find('.content').show()
    $('body, .wapper, .content_container, .fixed_menu').removeClass('show-menu')
    $(document).off 'touchstart','div.content_container'
    setTimeout ->
      _menu_showed = false
      $('.profile-container .content').removeClass('absolute')
      fixMainnav()
    , 500

$(document).click (e)->
  if !_menu_showed
#  if e.target isnt $('.main-nav__search') and e.target isnt $('.tips-menu')
    $('.tips-menu').hide()
    $('.main-nav__search').find('input').val('')
  else
    e.stopPropagation()
$('.main-nav__search').click (e)->
  if !_menu_showed
    e.stopPropagation()

$(document).on 'touchend','.top_search_button', (e) ->
  e.preventDefault()
  if _is_mobile
    if !_top_search_showed
      openNavSearch()
    else
      closeNavSearch()

openNavSearch = () ->
  top_search = $('.main-nav__search')
  top_search.addClass('shout_out')
  $('.top_search_button').removeClass('icon-search').addClass('icon-cross')
  $('#jquery-search2').focus()
  _top_search_showed = true

closeNavSearch = () ->
  top_search = $('.main-nav__search')
  top_search.removeClass('shout_out')
  $('.top_search_button').removeClass('icon-cross').addClass('icon-search')
#  $('#jquery-search2').val('')
  $('.tips-menu').hide()
  _top_search_showed = false

$(document).on 'touchend','.top_search_submit', (e) ->
  e.preventDefault()
  if _is_mobile
    if $('#jquery-search2').val() isnt ''
      check_search2()