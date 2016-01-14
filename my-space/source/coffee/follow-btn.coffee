# 关注按钮 ---------------------------------------

initFollowBtn = ()->

  $slider = $('.slider')
  $follow_btn = $('.profile__follow-btn')
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

  $follow_btn.on 'click', ->
    if parseInt(myid) > 0
      $.ajax({
        url: '/services/service.php?m=user&a=follow',
        type: 'post',
        dataType: 'json',
        data: { uid: window.uid },
        success: (result)->
          fans_count = parseInt($fans.text())
          if result.status is 1 or result.status is 2
            sliderToRight("#{result.status}")
            fans_count++
          else
            sliderToLeft()
            fans_count--
          $fans.html "<i class='icon icon-fans'></i>#{fans_count}粉丝"
      })
    else
      location.href = SITE_URL + 'user/login.html'