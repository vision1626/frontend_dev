toggleGoods = (show)->
  if show
    $('.item-list-filter').fadeIn(500)
    $('.item-list-container').fadeIn(500)
    $('.item-pagiation').fadeIn(500)
    $('.show-more').fadeIn(500)
    $('.form__container').hide()
  else
    $('.item-list-filter').fadeOut(500)
    $('.item-list-container').fadeOut(500)
    $('.item-pagiation').fadeOut(500)
    $('.show-more').fadeOut(500)
    $('.form__container').fadeIn(500)

followItem_Generater = (data,current_index) ->
  dd = $('<dd class="follow-list_item" i="' + current_index + '">'+
    '<div class="fans-container">' +
      '<div class="fans-face">' +
        '<a href="' + data.user_href + '" target="_blank">' +
          '<img src="' + data.img_thumb + '" alt="' + data.user_name + '"/>' +
        '</a>' +
      '</div>' +
      '<div class="fans-content">' +
        '<div class="fans-text">' +
          '<div class="fans-name">' +
            '<span>' + data.user_name + '</span>' +
          '</div>' +
          '<div class="fans-intro">' +
            '<span>' + (if data.introduce isnt '' and data.introduce isnt null then decodeURIComponent(data.introduce) else '这个人太潮了，不屑于填写简介') + '</span>' +
          '</div>' +
        '</div>' +
        '<div class="fans-action">' +
          '<div class="fans-published">' +
            '<dl>' +
            (
              goods = []
              for g,j in data.newest_publish
                goods.push(
                  '<dd i="' + j + '">' +
                    '<a href="' + g.url + '" target="_blank">' +
                      '<img src="' + g.img_56 + '" alt=""/>' +
                    '</a>' +
                  '</dd>')
              goods.join ''
            ) +
            '</dl>' +
          '</div>' +
          '<div class="fans-concemed">' +
            '<div class="fans-concemed_fans" uid="' + data.uid + '">' +
                '<span class="icon icon-fans"></span>' +
                '<label>' + data.fans + ' 粉丝</label>' +
            '</div>' +
            '<div class="fans-concemed_follow" uid="' + data.uid + '">' +
                '<span class="icon icon-following"></span>' +
                '<label>' + data.follows + ' 关注</label>' +
            '</div>' +
          '</div>' +
            (
              status_class = ''
              status_text = ''
              status_icon = ''
              status_btn = ''
              if data.is_follow is 1
                status_class = 'follow_ed'
                status_btn = 'slider--on'
                if data.is_gz is 0
                  status_icon = 'icon-followed'
                  status_text = '已关注'
                else
                  status_icon = 'icon-friends'
                  status_text = '互相关注'
              else
                status_class = 'follow_nt'
                status_text = '关注Ta'
                status_icon = 'icon-follow'

              "<div class='fans__follow-btn #{status_btn}'>" +
                "<div class='slider'>" +
                  "<i class='icon #{status_icon}'></i>" +
                  "<a class='status_text'>#{status_text}</a>" +
                "</div>" +
                "<div class='slider-btn'></div>" +
              "</div>"
            ) +
        '</div>' +
      '</div>' +
    '</div>' +
  '</dd>')

big_DashboardItem_Generater = (data,current_index) ->
  if data.dynamic_type is 1
    sid = data.dapei_id
    dtype = 'd'
  else
    sid = data.share_id
    dtype = 's'

  if data.is_fav is 0
    isfav = 'icon-heart'
  else
    isfav = 'icon-hearted'

  if state is 'dashboard' and _dashboard_show_me
    boxsize = ' longer'
  else
    boxsize = ''

  dd = $(
    '<dd class="item' + boxsize + ' ' + sid + '" i="' + current_index + '" dtype="' + dtype + '">' +
      '<div>' +
      (if data.dynamic_type is 1
        '<div class="item-l_image">' +
          '<a href="' + data.url + '" target="_blank">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
          '<dl class="collocation">' +
          (
            goods = []
            for g in data.goods
              goods.push ('<dd class="collocation_item">' +
                  '<div class="goods_item">' +
                    '<a href="' + g.url + '" target="_blank">' +
                      '<img src="' + g.img + '" alt=""/>' +
                    '</a>' +
                  '</div>' +
                '</dd>')
            goods.join ''
          ) +
          '</dl>' +
        '</div>' +
        '<div class="item-b_description">' +
          (
            if state is 'dashboard' and _dashboard_show_me
              '<div class="item-b_isnew">' +
              (
#                if data.is_dapei_like is 1 and data.like_user_list
                if data.like_user_list
                  (
                    likeusers = []
                    for lu in data.like_user_list
                      likeusers.push('<span>'+
                        '<a href="' + lu.user_href + '" target="_blank">' +
                          lu.user_name +
                        '</a>' +
                      '</span>')
                    likeusers.join(',')
                  )+
                  (
                    if data.like_count > 2
                      '<span> 等' + data.like_count + '人喜欢此搭配</span>'
                    else
                      '<span> 喜欢此搭配</span>'
                  )
                else
                  '<span class="item_tag">NEW</span>' +
                  '<span>新发布</span>'
              ) +
              '</div>'
            else
              ''
          ) +
        '</div>'
      else
        '<div class="item-b_image">' +
          '<a href="' + data.url + '" target="_blank">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
          (
            if state is 'talk' and _dashboard_show_me
              '<div class="actions"><span><i class="icon icon-edit"></i></span><span><i class="icon icon-garbage"></i></span></div>'
            else
              ''
          ) +
        '</div>' +
        '<div class="item-b_description">' +
          (
            if state is 'dashboard' and _dashboard_show_me
              '<div class="item-b_isnew">' +
              (
                if data.is_share_fav is 1 or data.like_user_list
                  (
                    likeusers = []
                    for lu in data.like_user_list
                      likeusers.push('<span>'+
                          '<a href="' + lu.user_href + '" target="_blank">' +
                            lu.user_name +
                          '</a>' +
                        '</span>')
                    likeusers.join(',')
                  )+
                    (
                      if data.like_count > 2
                        '<span> 等' + data.like_count + '人喜欢此单品</span>'
                      else
                        '<span> 喜欢此单品</span>'
                    )
                else
                  '<span class="item_tag">NEW</span>' +
                  '<span>新发布</span>'
              ) +
              '</div>'
            else
              ''
          ) +
          '<div class="item-b_title">' +
            '<a href="' + data.url + '" target="_blank">' +
              decodeURIComponent(data.title) +
            '</a>' +
          '</div>' +
          '<div class="item-b_price' + boxsize + '">' +
            '<span>¥' + data.goods_price + '</span>' +
          '</div>' +
        '</div>'
      ) +
      '<div class="item-b_additional">' +
        '<a href="' + data.user_href + '" title="' + data.user_name + '">' +
          '<img src="' + data.img_thumb + '"/>' +
        '</a>' +
        '<div class="item-value">' +
          '<span class="icon icon-viewed"></span>' +
          '<span>' + data.view_count + '</span>' +
          '<span class="icon icon-comment--s"></span>' +
          '<span>' + data.comment_count + '</span>' +
        '</div>' +
        '</div>' +
        '<div class="item-b_add_like btn_like" l="b" sid="' + sid + '" dtype="' + dtype + '"  ed="' + data.is_fav + '">' +
          '<img src="" alt="" class="harting"/>' +
          '<i class="icon ' + isfav + '"></i>' +
          '<span class="like_count">' +
            data.like_count +
          '</span>' +
        '</div>' +
      '</div>' +
    '</dd>')

small_DashboardItem_Generater = (data,current_index) ->
  if data.dynamic_type is 1
    sid = data.dapei_id
    dtype = 'd'
  else
    sid = data.share_id
    dtype = 's'

  if data.is_fav is 0
    isfav = 'icon-heart'
  else
    isfav = 'icon-hearted'

  dd = $('<dd class="item ' + sid + '" i="' + current_index + '" dtype="' + dtype + '">' +
      '<div>' +
        '<div class="item-s_image">' +
        '<img src="' + data.img + '" alt="' + data.title + '"/>' +
      '</div>' +
      '<div class="item-s_description">' +
        '<div class="item-s_owner">' +
          '<a href="' + data.user_href + '" target="_blank" title="' + data.user_name + '">' +
            '<img src="' + data.img_thumb + '"/>' +
          '</a>' +
        '</div>' +
        '<div class="item-s_action">' +
#          '<div class="action-add_special">' +
#            '<span class="icon icon-album"></span>' +
#          '</div>' +
          (
            if state is 'talk' and _dashboard_show_me
              '<div class="action-edit"><i class="icon icon-edit"></i></div>' +
              '<div class="action-delete"><i class="icon icon-garbage"></i></div>'
            else
              ''
          ) +
          '<div class="action-add_like btn_like" l="s" sid="' + sid + '" dtype="' + dtype + '" ed="' + data.is_fav + '">' +
            '<img src="" alt="" class="harting"/>' +
            '<i class="icon ' + isfav + '"></i>' +
          '</div>' +
        '</div>' + '<div class="item-s_info">' +
        (
          if data.dynamic_type is 1
            '<div class="item-s_isnew">' +
              (
#                if data.is_dapei_like is 1 or data.like_user_list
                if data.like_user_list
                  (
                    likeusers = []
                    for lu in data.like_user_list
                      likeusers.push('<span>'+
                          '<a href="' + lu.user_href + '" target="_blank">' +
                            lu.user_name +
                          '</a>' +
                        '</span>')
                    likeusers.join(',')
                  )+
                    '<span> 喜欢了</span>'
                else
                  '<span>NEW</span>'
              ) +
              '</div>' +
              '<dl class="collocation">' +
              (
                goods = []
                for g in data.goods
                  goods.push('<dd class="collocation_item">' +
                      '<div class="goods_item">' +
                        '<a href="' + g.url + '" target="_blank">' +
                          '<img src="' + g.img + '" alt=""/>' +
                        '</a>' +
                      '</div>' +
                    '</dd>')
                goods.join ''
              ) +
              '</dl>'
          else
            '<div class="item-s_isnew">' +
              (
                if data.is_share_fav is 1 or data.like_user_list
                  (
                    likeusers = []
                    for lu in data.like_user_list
                      likeusers.push('<span>'+
                          '<a href="' + lu.user_href + '" target="_blank">' +
                            lu.user_name +
                          '</a>' +
                        '</span>')
                    likeusers.join(',')
                  )+
                  '<span> 喜欢了</span>'
                else
                  '<span>NEW</span>'
              ) +
              '</div>' +
              '<div class="item-s_title">' +
                '<a href="' + data.url + '" target="_blank">' +
                  decodeURIComponent(data.title) +
                '</a>' +
              '</div>' +
              '<div class="item-s_price">' +
                '<span>¥' + data.goods_price + '</span>' +
              '</div>'
        ) + '</div>' +
        '<div class="item-s_additional">' +
          '<span class="icon icon-viewed"></span>' +
          '<span class="count">' + data.view_count + '</span>' +
          '<span class="icon icon-hearted"></span>' +
          '<span class="count like_count">' + data.like_count + '</span>' +
          '<span class="icon icon-comment"></span>' +
          '<span class="count">' + data.comment_count + '</span>' +
        '</div>' +
      '</div>' +
    '</dd>')

publishItem_Generater = () ->
  dd = $(
    '<dd class="item publish_entrance">' +
      '<div>' +
#        '<i class="icon icon-publish"></i><br/>' +icon-publish_solid
        '<i class="icon icon-publish_solid"></i><br/>' +
        '<span class="clear">发布潮品</span>' +
      '</div>' +
    '</dd>'
  )

parallax = (obj)->
  y = $('body').scrollTop()
  obj.css({'background-position-y': -(y / 5) + 'px'})

set_search_w = ->
  win_w = $(window).width()
  $('.main-nav__search').width win_w - 
    $('.main-nav--right').width() - 
    $('.main-nav').width() - 40

fixMainnav = ->
  $icon_hand = $('.main-nav__me').find('.icon')
  if $('body').scrollTop() >= 250
    $('.main-nav-container').addClass('ucantseeme')
    $('.fixed-nav-container').addClass('ucantseeme')
    $icon_hand.hide()
  else
    $('.main-nav-container').removeClass('ucantseeme')
    $('.fixed-nav-container').removeClass('ucantseeme')
    $icon_hand.show()

  if $('body').scrollTop() >= 400
    $('.main-nav-container').addClass('fixed')
  else 
    $('.main-nav-container').removeClass('fixed')
  set_search_w()

excite_Anim = (obj,animName) ->
  $(obj).addClass(animName + ' animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
    obj.removeClass(animName).removeClass('animated')
  );


