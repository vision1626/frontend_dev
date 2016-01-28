# 关注按钮 ---------------------------------------

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
    $.ajax({
      url: '/services/service.php?m=user&a=follow',
      type: 'post',
      dataType: 'json',
      data: { uid: uid },
      success: (result)->
        if result.status is 1 or result.status is 2
          sliderToRight($btn, "#{result.status}")
        else
          sliderToLeft($btn)
      error: (result)->
        alert('fb-errr: ' + result)
    })

  $('.follow-all').click ->
    $current_u_list = $('.push-users.current')
    $current_u_list.find('.slider-btn').show()
    $current_u_list.find('li').each ->
      $user = $(this)
      uid = $user.attr 'uid'
      $btn = $user.find '.follow-btn'
      follow_status = parseInt($btn.attr('follow-status'))
      if follow_status isnt 1 and follow_status isnt 2
        submitFollow(uid, $btn)


  $(document).on 'click', '.follow-btn', ->
    $button = $(this)
    $button.find('.slider-btn').show()
    uid = $button.parent().attr 'uid'
    submitFollow(uid,$button)

  changeFollowCount = (change, btn_type, $obj)->
    $following_count_text = $('')
    following_count = 0

    changeCount = ->
      following_count = parseInt($following_count_text.text())
      if change is 'up'
        following_count++
      else
        following_count--
      $following_count_text.text following_count

    if btn_type is 'u_header' #点击u_header的关注按钮

      if _follow_show_me #在我自己的关注/粉丝列表,改变「关注」数
        $following_count_text = $('.content__relationship').find('.relation-follow b')
      else #在別人的关注/粉丝列表,改变「粉丝」数
        $following_count_text = $('.content__relationship').find('.relation-fans b')
      changeCount()

    else if btn_type is 'follow_list'
      $following_count_text = $obj.parent().find('.fans-concemed_fans b') #改变点击那个人的「粉丝」数
      changeCount()
      if _follow_show_me #在我自己的关注/粉丝列表,改变「关注」数
        $following_count_text = $('.content__relationship').find('.relation-follow b')
        changeCount()

