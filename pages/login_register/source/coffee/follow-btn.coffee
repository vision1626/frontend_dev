# 关注按钮 ---------------------------------------

_is_following = false
initFollowBtn = ()->

  # ---------------------------------------------
  # 初始化 u_header 的关注按钮
  setFollowStatus = (status, $this_follow_btn)->
    $this_follow_btn.attr {"follow-status": status}
    $slider = $this_follow_btn.find '.slider'
    $slider_icon = $slider.find '.icon'
    $slider_text = $slider.find '.status_text'
    $slider.css 'opacity',1
    $slider.removeClass 'to-unfollow'
    switch status
      when "0"
        $this_follow_btn.removeClass 'slider--on'
        $slider_icon.removeClass 'icon-followed'
        $slider_icon.removeClass 'icon-friends'
        $slider_icon.addClass 'icon-follow'
        $slider_text.html '关注Ta'
      when "1"
        $this_follow_btn.addClass 'slider--on'
        $slider_icon.removeClass 'icon-follow'
        $slider_icon.removeClass 'icon-friends'
        $slider_icon.addClass 'icon-followed'
        $slider_text.html '已关注'
      when "2"
        $this_follow_btn.addClass 'slider--on'
        $slider_icon.removeClass 'icon-follow'
        $slider_icon.removeClass 'icon-followed'
        $slider_icon.addClass 'icon-friends'
        $slider_text.html '互相关注'

  # ---------------------------------------------


  $(document).on 'mouseenter', '.follow-btn', ->
    $btn = $(this)
    is_follow = $btn.attr "follow-status"
    $slider = $btn.find('.slider')
    $slider_text = $slider.find 'a.status_text'
    if is_follow is "1" or is_follow is "2"
      $slider.addClass 'to-unfollow'
      $slider_text.html "取消关注"

  $(document).on 'mouseleave', '.follow-btn', ->
    $btn = $(this)
    $slider = $btn.find('.slider')
    $slider_text = $slider.find 'a.status_text'
    $slider.removeClass 'to-unfollow'
    switch $btn.attr "follow-status"
      when "1"
        $slider_text.html "已关注"
      when "2"
        $slider_text.html "互相关注"


  sliderToRight = ($btn, status)->
    $slider_btn = $btn.find '.slider-btn'
    $slider_btn.addClass('slide-to-right').removeClass('slide-to-left')
    $slider = $btn.find ('.slider')
    $slider.css 'opacity',0
    $btn.attr "follow-status", status
    setTimeout ->
      setFollowStatus(status, $btn)
    ,500

  sliderToLeft = ($btn)->
    $slider_btn = $btn.find '.slider-btn'
    $slider_btn.removeClass('slide-to-right').addClass('slide-to-left')
    $slider = $btn.find ('.slider')
    $slider.css 'opacity',0
    $btn.attr "follow-status", 0
    setTimeout ->
      setFollowStatus("0", $btn)
    ,500

  submitFollow = (uid,$btn)->
    if uid
      _is_following = true
      $.ajax({
        url: '/services/service.php?m=user&a=follow',
        type: 'post',
        dataType: 'json',
        data: { uid: uid, bulk: 0},
        success: (result)->
          if result.status is 1 or result.status is 2
            sliderToRight($btn, "#{result.status}")
          else
            sliderToLeft($btn)
          _is_following = false
        error: (result)->
          showSmallErrorTip('关注失败',0)
          _is_following = false
      })

  submitFollowAll = (all_uid,$all_btn)->
    if all_uid
      _is_following = true
      $.ajax({
        url: '/services/service.php?m=user&a=follow',
        type: 'post',
        dataType: 'json',
        data: { uid: all_uid, bulk: 1},
        success: (result)->
          if result.is_error is 0
            for $btn in $all_btn
              sliderToRight($btn, '1')
          else
            showSmallErrorTip('关注失败',0)
          _is_following = false
        error: (result)->
          showSmallErrorTip('关注失败',0)
          _is_following = false
      })

  $('.follow-all').click ->
    if !_is_following
      $current_u_list = $('.push-users.current')
#      $current_u_list.find('.slider-btn').show()
      all_uid = ''
      $all_btn = $('')
      t_all_uid = []
      $current_u_list.find('li').each ->
        $user = $(this)
        $btn = $user.find('.follow-btn')
        follow_status = parseInt($btn.attr('follow-status'))
        uid = $user.attr 'uid'
  #      if follow_status isnt 1 and follow_status isnt 2
        if follow_status is 0
          $user.find('.slider-btn').show()
          t_all_uid.push(uid)
          $all_btn.push($btn)
          $all_btn.push($('.tab__content').find("li[uid='#{uid}'] .follow-btn"))

      if t_all_uid.length >0
        all_uid = t_all_uid.join(',')
      else
        all_uid = ''

      if all_uid isnt ''
        submitFollowAll(all_uid, $all_btn, 1)

  $(document).on 'click', '.follow-btn', ->
    if !_is_following
      $button = $(this)
      $button.find('.slider-btn').show()
      uid = $button.parent().attr 'uid'
      $all_follow_users_btn = $('.tab__content').find("li[uid='#{uid}'] .follow-btn")
      submitFollow(uid,$all_follow_users_btn)