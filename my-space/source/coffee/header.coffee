init_u_header = ->
  $slider = $('.slider')
  $i_follow = $('.icon-follow')
  $success_fo = $('.success-fo')
  $success_unfo = $('.success-unfo')
  $follow_btn = $('.profile__follow-btn')

  if (window.myid != window.uid)
    $('.content__actions').find('li').css({"width": "50%"})

  $follow_btn.on 'click', ->
    $.ajax({
      url: '/services/service.php?m=user&a=follow',
      type: 'post',
      dataType: 'json',
      data: { uid: window.uid },
      success: (result)->
        if result.status == 1 
          $slider.addClass('slideleft')
          $i_follow.addClass('slideleft')
          $success_fo.fadeIn() 
    })
