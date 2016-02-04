init_u_header = ->
  $profile = $('.profile-container')
  $i_follow = if $('.icon-follow').length > 0 then $('.icon-follow') else $('.icon-unfollow')
  $success_fo = $('.success-fo')
  $success_unfo = $('.success-unfo')
  $fav = $('.actions-fav')
  $db = $('.actions-db')
  $pub = $('.actions-pub')
  $follow = $('.relation-follow')
  $follow_m = $('.relation-follow-m')
  $follow_m_t = $('.profile__relation-follow')
  $fans = $('.relation-fans')
  $fans_m = $('.relation-fans-m')
  $fans_m_t = $('.profile__relation-fans')
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

#  if (window.myid != window.uid)
#    $('.content__actions').find('li').css({'width': '50%'})

  # Set Tab Width
  setTabWidth = ()->
    $cnt_tab_ul = $('.content__actions')
    $cnt_tab = $cnt_tab_ul.find('li')
    if $(window).width() > 680
      $cnt_tab_ul_w = 0
      $cnt_tab.each ->
        if !$(this).is(':hidden')
          this_w = Math.ceil($(this).width()) + 65
          $cnt_tab_ul_w += this_w
      $cnt_tab_ul.width $cnt_tab_ul_w
    else
      if $cnt_tab.length is 4
        $cnt_tab_ul.addClass('col2')
      else
        $cnt_tab_ul.addClass('col3')
      $cnt_tab_ul.width '100%'

  setTabWidth()

  user_action_async = (action)->
    if isInActions()
      if (window.location.pathname.indexOf(action) < 0)
        changeState(action)
        if _dashboard_is_loading
          _dashboard_ajax_process.abort()
        if _dashboard_recommand_is_loading
          _dashboard_recommand_ajax_process.abort()
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
    $fans_m.addClass('current')
  else if isInCurrentAction('follow')
    changeState('follow')
    slideToCurrent.apply($follow,[36])
    $follow_m.addClass('current')

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
  $fans.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this,[36])
      user_relation_async('fans')
  $follow.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this,[36])
      user_relation_async('follow')
  $fans_m.on 'click', ->
    if giveupEditing()
      $(this).addClass('current')
      slideToCurrent.apply(this)
      user_relation_async('fans')
  $follow_m.on 'click', ->
    if giveupEditing()
      $(this).addClass('current')
      slideToCurrent.apply(this)
      user_relation_async('follow')
  $fans_m_t.on 'click', ->
    if giveupEditing()
      $fans_m.parent().parent().find('li').removeClass('current')
      $fans_m.addClass('current')
      user_relation_async('fans')
  $follow_m_t.on 'click', ->
    if giveupEditing()
      $follow_m.parent().parent().find('li').removeClass('current')
      $follow_m.addClass('current')
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

    setTabWidth()
