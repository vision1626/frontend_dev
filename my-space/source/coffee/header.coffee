init_u_header = ->
  $profile = $('.profile-container')
  $i_follow = if $('.icon-follow').length > 0 then $('.icon-follow') else $('.icon-unfollow')
  $success_fo = $('.success-fo')
  $success_unfo = $('.success-unfo')
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
        if _dashboard_is_loading
          _dashboard_ajax_process.abort()
        init_dashboard_data()
    else
      window.location.pathname = '/u/' + action + '-' + uid + '.html'

  user_relation_async = (action)->
    if !isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        changeState(action)
        if _follow_is_loading
          _follow_ajax_process.abort()
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

  parallax($profile)

  #  ----------------------------------------

  $fav.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('fav')
  $db.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('dashboard')
  $pub.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('talk')
      init_form_publish()
  $fans.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this,[36])
      user_relation_async('fans')
  $follow.on 'click', ->
    if giveupEditing()
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
