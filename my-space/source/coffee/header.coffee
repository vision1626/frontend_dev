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

  #部分用户,php端不能正常提供其UID,所以通过页面链接获取,相对应的粉丝或关注数为空时,显示0
  if window.uid is ''
    window.uid = location.pathname.substring(location.pathname.indexOf('-')+1,location.pathname.indexOf('.html'))
  if window.fans_count is ''
    window.fans_count = '0'
  if window.follow_count is ''
    window.follow_count = '0'
  $fans.find('b').html(window.fans_count)
  $fans_m.find('b').html(window.fans_count)
  $fans_m_t.find('span').html(window.fans_count + '粉丝')
  $follow.find('b').html(window.follow_count)
  $follow_m.find('b').html(window.follow_count)
  $follow_m_t.find('span').html(window.follow_count + '关注')

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
    if _is_mobile
      slideToCurrent.apply($fans_m)
    else
      slideToCurrent.apply($fans,[36])
    $fans_m.addClass('current')
  else if isInCurrentAction('follow')
    changeState('follow')
    if _is_mobile
      slideToCurrent.apply($follow_m)
    else
      slideToCurrent.apply($follow,[36])
    $follow_m.addClass('current')
  parallax($profile)

  #  ----------------------------------------

  $fav.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('fav')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $db.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('dashboard')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $pub.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this)
      user_action_async('talk')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $fans.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this,[36])
      user_relation_async('fans')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $follow.on 'click', ->
    if giveupEditing()
      slideToCurrent.apply(this,[36])
      user_relation_async('follow')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $fans_m.on 'click', ->
    if giveupEditing()
      $(this).addClass('current')
      slideToCurrent.apply(this)
      user_relation_async('fans')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
  $follow_m.on 'click', ->
    if giveupEditing()
      $(this).addClass('current')
      slideToCurrent.apply(this)
      user_relation_async('follow')
      if _is_mobile
        $('html, body').animate({scrollTop:0}, 200);
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
      if _is_mobile
        slideToCurrent.apply($fans_m)
        $fans_m.addClass('current')
      else
        slideToCurrent.apply($fans,[36])
    else if isInCurrentAction('follow')
      changeState('follow')
      if _is_mobile
        slideToCurrent.apply($follow_m)
        $follow_m.addClass('current')
      else
        slideToCurrent.apply($follow,[36])

    setTabWidth()

  if $(window).width() <= 680 and myid isnt uid
    $('.content__actions').find('label').show()
    $('.content__relationship').find('label').show()
  else
    $('.content__actions').find('label').hide()
    $('.content__relationship').find('label').hide()