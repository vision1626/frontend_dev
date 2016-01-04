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
  $follow = $('.relation-follow')
  $fans = $('.relation-fans')
  $slide_tab_bg = $('.js-slide-bg')

  isInActions = ->
    if (location.pathname.indexOf('dashboard') > 0) or 
    (location.pathname.indexOf('fav') > 0) or 
    (location.pathname.indexOf('talk') > 0)
      return true
    else
      return false

  if (window.myid != window.uid)
    $('.content__actions').find('li').css({'width': '50%'})

  user_action_async = (action)->
    if isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        history.pushState('', '', action + '-' + uid + '.html')
        init_dashboard_data()
    else
      window.location.pathname = '/u/' + action + '-' + uid + '.html'

  user_relation_async = (action)->
    if !isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        history.pushState('', '', action + '-' + uid + '.html')
        init_follow_data()
    else
      window.location.pathname = '/u/' + action + '-' + uid + '.html'

  slideToCurrent = ()->
    tab_width = $(this).css('width')
    $slide_tab_bg.css({"width": tab_width})
    $slide_tab_bg.css({'left': $(this).offset().left})
    $(this).parent().parent().find('li').removeClass('current')
    $(this).addClass('current')

  if window.location.pathname.indexOf('fav') > 0
    slideToCurrent.apply($fav)
  else if window.location.pathname.indexOf('dashboard') > 0
    slideToCurrent.apply($db)
  else if window.location.pathname.indexOf('talk') > 0
    slideToCurrent.apply($pub)
  else if window.location.pathname.indexOf('fans') > 0
    slideToCurrent.apply($fans)
  else if window.location.pathname.indexOf('follow') > 0
    slideToCurrent.apply($follow)

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
        if result.status == 1 or result.status == 2
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
    slideToCurrent.apply(this)
    user_action_async('fav')
  $db.on 'click', ->
    slideToCurrent.apply(this)
    user_action_async('dashboard')
  $pub.on 'click', ->
    slideToCurrent.apply(this)
    user_action_async('talk')
  $fans.on 'click', ->
    slideToCurrent.apply(this)
    user_relation_async('fans')
  $follow.on 'click', ->
    slideToCurrent.apply(this)
    user_relation_async('follow')

  $(window).on 'resize', ->
    if window.location.pathname.indexOf('fav') > 0
      slideToCurrent.apply($fav)
    else if window.location.pathname.indexOf('dashboard') > 0
      slideToCurrent.apply($db)
    else if window.location.pathname.indexOf('talk') > 0
      slideToCurrent.apply($pub)
