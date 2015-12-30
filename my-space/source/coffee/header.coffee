init_u_header = ->
  $profile = $('.profile-container')
  $slider = $('.slider')
  $i_follow = if $('.icon-follow').length > 0 then $('.icon-follow') else $('.icon-unfollow') 
  $success_fo = $('.success-fo')
  $success_unfo = $('.success-unfo')
  $status_text = $('.status_text')
  $follow_btn = $('.profile__follow-btn')
  $fav = $('.actions-fav')
  $db = $('.actions-db')
  $pub = $('.actions-pub')
  $slide_tab_bg = $('.js-slide-bg')

  if (window.myid != window.uid)
    $('.content__actions').find('li').css({"width": "50%"})

  tab_width = $('.content__actions').find('li').css("width")
  $slide_tab_bg.css({"width": tab_width})

  user_action_async = (action)->
    # $.ajax({
    #   url: SITE_URL + 'services/service.php?m=u&a=get_' + action + '_ajax',
    #   type: 'post',
    #   dataType: 'json',
    #   data: {hid: uid, page: 1, count: count, sort: 'new', limit: 12, type: ''},
    #   success: (result)->
    #     data = result.data
    #     more = result.more
    #     $item_list = $('.item-list-container')
    #     $big_list = $('<dl id="big_img" class="big_img" style="display: block;"></dl>')
    #     $item_list.empty()
    #     if data != null
    #       for d, i in data
    #         $big_list.append(big_DashboardItem_Generater(d, i))
    #       $item_list.append($big_list)
    # })
    if (window.location.pathname.indexOf(action) < 0)
      history.pushState('', '', action + '-' + uid + '.html')
      init_dashboard_data()

  if window.isfollow == 0
    $status_text.on 'mouseover', ->
      $(this).css('left': '34px').text("关注Ta")
    $status_text.on 'mouseout', ->
      $(this).css('left': '34px').text("关注Ta")
  else
    $status_text.on 'mouseover', ->
      $(this).css('left': '7px').text("取消关注")
    $status_text.on 'mouseout', ->
      $(this).css('left': '21px').text("已关注")

  parallax($profile)

  $follow_btn.on 'click', ->
    $.ajax({
      url: '/services/service.php?m=user&a=follow',
      type: 'post',
      dataType: 'json',
      data: { uid: window.uid },
      success: (result)->
        if result.status == 1 
          $slider.removeClass('slideleft').addClass('slideright')
          $i_follow.removeClass('slideleft').addClass('slideright')
          setTimeout ->
            $i_follow.addClass('icon-unfollow').removeClass('icon-follow')
          ,500
          $status_text.html("已关注").css({'left': '21px'})
          $status_text.on 'mouseover', ->
            $(this).css('left': '7px').text("取消关注")
          $status_text.on 'mouseout', ->
            $(this).css('left': '21px').text("已关注")
        else
          $slider.removeClass('slideright').addClass('slideleft')
          $i_follow.removeClass('slideright').addClass('slideleft')
          setTimeout ->
            $i_follow.removeClass('icon-unfollow').addClass('icon-follow')
          ,500
          $status_text.on 'mouseover', ->
            $(this).css('left': '34px').text("关注Ta")
          $status_text.on 'mouseout', ->
            $(this).css('left': '34px').text("关注Ta")
          $status_text.html("关注Ta").css({'left': '34px'})
    })
  $fav.on 'click', ->
    self = $(this)
    user_action_async('fav')
    $slide_tab_bg.css({"left": self.offset().left})
  $db.on 'click', ->
    self = $(this)
    user_action_async('dashboard')
    $slide_tab_bg.css({"left": self.offset().left})
  $pub.on 'click', ->
    self = $(this)
    user_action_async('talk')
    $slide_tab_bg.css({"left": self.offset().left})
