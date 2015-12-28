init_u_header = ->
  $slider = $('.slider')
  $i_follow = if $('.icon-follow').length > 0 then $('.icon-follow') else $('.icon-unfollow') 
  $success_fo = $('.success-fo')
  $success_unfo = $('.success-unfo')
  $status_text = $('.status_text')
  $follow_btn = $('.profile__follow-btn')
  $introduction = $('profile__introduction')

  if (window.myid != window.uid)
    $('.content__actions').find('li').css({"width": "50%"})

  # if $.trim($introduction.text()) == ""


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

  $follow_btn.on 'click', ->
    $.ajax({
      url: '/services/service.php?m=user&a=follow',
      type: 'post',
      dataType: 'json',
      data: { uid: window.uid },
      success: (result)->
        if result.status == 1 
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
