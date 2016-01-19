init_global_header = ->
  $search_wrap = $('.main-nav__search')
  $search = $search_wrap.find('input')
  $search_icon_font = $search_wrap.find('i')
  $nav_right = $('.main-nav--right')
  $nav_left = $('.main-nav')
  $nav_right_w = $nav_right.width()
  $nav_left_w = $nav_left.width()

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
          $('.fixed-nav__number').html(0)
          $('.check-all').find('a').html("没有新消息")
        else 
          $('.fixed-nav__number').html(result.sum)
          for d in data
            if d['type']=="1" && d['ge_sum']!="0"
              $('.get-likes').html("<i class='icon icon-heart'></icon>" + 
                "<a href='" + d['url'] + "'>" + "获得" + 
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "次喜欢" + "</a>")
            if d['type']=="2" && d['ge_sum']!="0"
              $('.get-comments').html("<i class='icon icon-comment'></icon>" + 
                "<a href='" + d['url'] + "'>" + "收到" + 
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "条留言" + "</a>")
            if d['type']=="3" && d['ge_sum']!="0"
              $('.get-fans').html("<i class='icon icon-fans'></icon>" + 
                "<a href='" + d['url'] + "'>" + "新增" + 
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                  "个粉丝" + "</a>")
            if d['type']==4 && d['ge_sum']!="0"
              $('.get-recomendded').html("<i class='icon icon-news'></icon>" + 
                "<a href='" + d['url'] + "'>" + "有" + 
                  "<span class='number'>" + d['ge_sum'] + "</span>" + 
                    "条系统消息" + "</a>")
            $('.check-all').find('a').html("知道了")
    })

  check_new_msg()

  setInterval ->
    check_new_msg()
  , 300000

  $('.check-all').on 'click', (e)->
    alert($(this).find('a').html() == "知道了")
    self = $(this)
    if $(this).find('a').html() == "知道了"
      $.ajax({
        url: SITE_URL + '/services/service.php?m=index&a=del_unread_message&_=1452061658478',
        type: 'get',
        dataType: 'json',
        success: (result)->
          if result.status == 1
            $('.check-all').prevAll().remove()
          else
            # alert('fuck')
      })
    else
      # self.parent().css({'left': '-999em'})


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

  $('.main-nav__publish').on 'click', ->
    $('.popup__blackbox').fadeIn(500)

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