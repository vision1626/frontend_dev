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

  isInCurrentAction = (action) ->
    window.location.pathname.indexOf(action) > 0 or window.state == action

  changeState = (action)->
    if window.history.pushState
      history.pushState(null, null, action + '-' + uid + '.html')
    window.state = action

#  if (window.myid != window.uid)
#    $('.content__actions').find('li').css({'width': '50%'})

  # Set Tab Width
  setTabWidth = ()->
    $cnt_tab_ul = $('.content__actions')
    $cnt_tab = $cnt_tab_ul.find('li')
    $cnt_tab_ul_w = 0
    $cnt_tab.each ->
      this_w = Math.ceil($(this).width()) + 65
      $cnt_tab_ul_w += this_w
    $cnt_tab_ul.width $cnt_tab_ul_w

  setTabWidth()

  user_action_async = (action)->
    if isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        changeState(action)
        init_dashboard_data()
    else
      window.location.pathname = '/u/' + action + '-' + uid + '.html'

  user_relation_async = (action)->
    if !isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        changeState(action)
        init_follow_data()
    else
      window.location.pathname = '/u/' + action + '-' + uid + '.html'

  slideToCurrent = (padding)->
    padding = padding or 60
    tab_width = Math.ceil($(this).width()) + padding
    cnt_wrap_w = $('.content .center-wrap').width()
    win_w = $(window).width()
    wrap_offset = (win_w - cnt_wrap_w) / 2
    $slide_tab_bg.width tab_width
    $slide_tab_bg.css({'left': $(this).offset().left - wrap_offset})
    $(this).parent().parent().find('li').removeClass('current')
    $(this).addClass('current')

  if isInCurrentAction('fav')
    changeState('fav')
    slideToCurrent.apply($fav)
  else if isInCurrentAction('dashboard')
    changeState('dashboard')
    slideToCurrent.apply($db)
  else if isInCurrentAction('talk')
    changeState('talk')
    slideToCurrent.apply($pub)
  else if isInCurrentAction('fans')
    changeState('fans')
    slideToCurrent.apply($fans,[36])
  else if isInCurrentAction('follow')
    changeState('follow')
    slideToCurrent.apply($follow,[36])



  # 关注按钮
  $slider_icon = $slider.find '.icon'
  $slider_text = $slider.find 'a.status_text'
  $slider_btn = $follow_btn.find '.slider-btn'

  setFollowStatus = (status)->
    $slider.css 'opacity',1
    $slider.removeClass 'to-unfollow'
    $follow_btn.attr "follow-status", status
    switch status
      when "0"
        $follow_btn.removeClass 'slider--on'
        $slider_icon.removeClass 'icon-followed'
        $slider_icon.removeClass 'icon-friends'
        $slider_icon.addClass 'icon-follow'
        $slider_text.html '关注Ta'
      when "1"
        $follow_btn.addClass 'slider--on'
        $slider_icon.removeClass 'icon-follow'
        $slider_icon.removeClass 'icon-friends'
        $slider_icon.addClass 'icon-followed'
        $slider_text.html '已关注'
      when "2"
        $follow_btn.addClass 'slider--on'
        $slider_icon.removeClass 'icon-follow'
        $slider_icon.removeClass 'icon-followed'
        $slider_icon.addClass 'icon-friends'
        $slider_text.html '互相关注'

  initFollowStatus = ()->
    is_follow = window.isfollow
    setFollowStatus(is_follow)

  initFollowStatus()

  $follow_btn.mouseenter ->
    is_follow = $follow_btn.attr "follow-status"
    if is_follow is "1" or is_follow is "2"
      $slider.addClass 'to-unfollow'
      $slider_text.html "取消关注"

  $follow_btn.mouseleave ->
    $slider.removeClass 'to-unfollow'
    switch $follow_btn.attr "follow-status"
      when "1"
        $slider_text.html "已关注"
      when "2"
        $slider_text.html "互相关注"


  sliderToRight = (status)->
    $slider_btn.addClass('slide-to-right').removeClass('slide-to-left')
    $slider.css 'opacity',0
    $follow_btn.attr "follow-status", status
    setTimeout ->
      setFollowStatus(status)
    ,500

  sliderToLeft = ->
    $slider_btn.removeClass('slide-to-right').addClass('slide-to-left')
    $slider.css 'opacity',0
    $follow_btn.attr "follow-status", 0
    setTimeout ->
      setFollowStatus("0")
    ,500

#  if window.isfollow == "0"
#    $status_text.on 'mouseover', ->
#      $(this).css('left': '34px').text("关注Ta")
#    $status_text.on 'mouseout', ->
#      $(this).css('left': '34px').text("关注Ta")
#  else
#    $status_text.on 'mouseover', ->
#      $(this).css('left': '7px').text("取消关注")
#    $status_text.on 'mouseout', ->
#      $(this).css('left': '21px').text("已关注")

  parallax($profile)

  $follow_btn.on 'click', ->
    if parseInt(myid) > 0
      $.ajax({
        url: '/services/service.php?m=user&a=follow',
        type: 'post',
        dataType: 'json',
        data: { uid: window.uid },
        success: (result)->
          if result.status is 1 or result.status is 2
            sliderToRight("#{result.status}")
          else
            sliderToLeft()
      })
    else
      location.href = SITE_URL + 'user/login.html'
  
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
    slideToCurrent.apply(this,[36])
    user_relation_async('fans')
  $follow.on 'click', ->
    slideToCurrent.apply(this,[36])
    user_relation_async('follow')

  $(window).on 'resize', ->
    if isInCurrentAction('fav')
      changeState('fav')
      slideToCurrent.apply($fav)
    else if isInCurrentAction('dashboard')
      changeState('dashboard')
      slideToCurrent.apply($db)
    else if isInCurrentAction('talk')
      changeState('talk')
      slideToCurrent.apply($pub)
    else if isInCurrentAction('fans')
      changeState('fans')
      slideToCurrent.apply($fans,[36])
    else if isInCurrentAction('follow')
      changeState('follow')
      slideToCurrent.apply($follow,[36])
