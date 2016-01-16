# 关注按钮 ---------------------------------------

initFollowBtn = ()->


  # ---------------------------------------------
  # 初始化 u_header 的关注按钮
  setFollowStatus = (status, $this_follow_btn)->
    $this_follow_btn.attr {"follow-status": status, 'uid':window.uid}
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

  initProfileFollowStatus = ()->
    is_follow = window.isfollow
    setFollowStatus(is_follow, $('.profile__follow-btn'))

  initProfileFollowStatus()
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

  $(document).on 'click', '.follow-btn', ->
    $button = $(this)
    if parseInt(window.myid) > 0
      btn_type = ''
      if $button.hasClass('profile__follow-btn') or $button.hasClass('empty-action')
        uid = parseInt($button.attr('uid'))
        btn_type = 'u_header'
      else
        uid = parseInt($button.parent().parent().parent().parent().attr('t-uid'))
        btn_type = 'follow_list'
      if uid is window.myid
        alert '你不能关注自己哦！'
      else
        $.ajax({
          url: '/services/service.php?m=user&a=follow',
          type: 'post',
          dataType: 'json',
          data: { uid: uid },
          success: (result)->
            if result.status is 1 or result.status is 2
              sliderToRight($button, "#{result.status}")
              changeFollowCount('up',btn_type, $button)
              if $button.hasClass('empty-action') and !_follow_show_me
                sliderToRight($('.profile__follow-btn'), "#{result.status}")
            else
              sliderToLeft($button)
              changeFollowCount('down',btn_type, $button)
          error: (result)->
            alert('errr: ' + result)
        })
    else
      location.href = SITE_URL + 'user/login.html'


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

