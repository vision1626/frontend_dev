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
      if $button.hasClass 'profile__follow-btn' or $button.hasClass 'empty-action'
        uid = parseInt($button.attr('uid'))
      else
        uid = parseInt($button.parent().parent().parent().parent().attr('t-uid'))
      if uid is window.myid
        alert '你不能关注自己哦！'
      else
        $.ajax({
          url: '/services/service.php?m=user&a=follow',
          type: 'post',
          dataType: 'json',
          data: { uid: uid },
          success: (result)->
            fans_count = 0
            if $button.hasClass 'profile__follow-btn'
              fans_count = parseInt($('.relation-fans').text())
            else
              fans_count = parseInt($button.parent().find('.fans-concemed_fans label').text())

            if result.status is 1 or result.status is 2
              sliderToRight($button, "#{result.status}")
              fans_count++
            else
              sliderToLeft($button)
              fans_count--

            if $button.hasClass 'profile__follow-btn'
              $('.relation-fans').html "<i class='icon icon-fans'></i>#{fans_count}粉丝"
            else
              $button.parent().find('.fans-concemed_fans label').text("#{fans_count}粉丝")

          error: (result)->
            alert('errr: ' + result)
        })
    else
      location.href = SITE_URL + 'user/login.html'


#  after_follow = (me,result)->
#    if state is 'fans'
#      init_follow_data()
#    else
#      if result is 1
#        me.removeClass('follow_nt').addClass('follow_ed')
#        me.find('.icon').removeClass('icon-follow').addClass('icon-unfollow')
#        me.find('label.sl1').html('已关注')
#      else if result is 2
#        me.removeClass('follow_nt').addClass('follow_ed')
#        me.find('.icon').removeClass('icon-follow').addClass('icon-unfollow')
#        me.find('label.sl1').html('互相关注')
#      else
#        me.removeClass('follow_ed').addClass('follow_nt')
#        me.find('label.sl1').html('关注Ta')
#        me.find('.icon').removeClass('icon-unfollow').addClass('icon-follow')
##      _dashboard_doing_follow = false