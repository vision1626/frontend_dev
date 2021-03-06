renew_captcha = ->
  $('i.captcha').css("background-image",'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')')
  $('.input-row.captcha input').val('')

mobileBind = ()->
  self = this
  errMsg = ''
  if ! /^1[35874][0-9]{9}$/.test($('.mobile-input').val())
    errMsg = '请输入正确的手机号码'
  captcha = $('.email-input').val()
  if errMsg
    $('span.warning').html(errMsg)
    return false;
  else
    $('span.warning').html('')
    $.ajax({
      url: SITE_URL + 'services/service.php?m=user&a=get_mobile_verify',
      dataType:'json',
      method: 'get',
      data: {
        ajax: 1,
        code: $('.mobile-captcha').val(),
        mobile: $('.mobile-input').val(),
        type: 'reg'
      },
      success: (result)->
        renew_captcha()
        $('span.warning').html(result.msg)
        if +result.status == 1
          $('span.textcode-countdown').css({
                                         'border-bottom': 'none',
                                         'cursor': 'default'
                                       }).show()
          $(self).text('绑定手机')
          sec = 60
          timeId = setInterval ->
            if sec == 0
              $('span.textcode-countdown').text('重新发送')
                                          .css({
                                            'border-bottom': '2px solid #b4b4b4',
                                            'cursor': 'pointer'
                                          })
              $('span.textcode-countdown').on 'click', ->
                $(this).hide()
                $(this).off()
                $('span.warning').text('')
                $('tr.textcode').hide()
                $('tr.captcha').show()
                $(self).text('重新发送手机验证码')
                $(self).off()
                $(self).on 'click', ->
                  $('span.warning').text('')
                  $('span.warning').off()
                  mobileBind.call(this)
              clearInterval timeId
            else
              $('span.textcode-countdown').text(sec-- +'秒后重新发送验证码')
          , 1000 
          $('tr.textcode').show()
          $('tr.captcha').hide()
          $(self).off()
          $(self).on 'click', ->
            $.ajax({
              url: SITE_URL + 'services/service.php?m=user&a=bind_user_mobile',
              method: 'get',
              dataType: 'json',
              data: {
                ajax: 1,
                mobile: $('.mobile-input').val(),
                code: $('.textcode-input').val()
              },
              success: (result)->
                if +result.status == 1
                  $('.validator').remove()
                  $('.validator-separator').html('<i class="icon icon-tick" style="color:green"/> 认证成功!' + 
                    '赶紧发布商品让别人观摩一下吧')
                  clearInterval timeId
                else
                  $('span.warning').html(result.msg)
            })
    })

askUserToGetValidated = ->
  if user_mobile == ''
    if +email_status <= 0
      $('.validator-separator').show()
      $('i.captcha').css("background-image",'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')')
      $('.validator-separator').find('span').on 'click', (e)->
        if user_email
          $(this).text('验证邮箱后，您分享的商品将会获得优先审核哦')
                 .css({
                    'border-bottom': 'none',
                    'cursor': 'default'
                  })
          $('.email-validator').show()
          $('.email-bind').on 'click', ->
            self = this
            captcha = $('.email-captcha').val()
            $.ajax({
              url: SITE_URL + 'services/service.php?m=user&a=sendemail',
              dataType: 'json',
              method: 'get',
              data: {captcha: captcha}
              success: (result)->
                renew_captcha()
                $('.user-email').html(result.msg)
                if +result.status == 1
                  $(self).text('没有收到邮件？重新发送')
            })
        else
          $(this).text('验证手机后，您分享的商品将会获得优先审核哦')
                 .css({
                    'border-bottom': 'none',
                    'cursor': 'default'
                  })
          $('.phone-validator').show()
          $('.mobile-bind').on 'click', ->
            mobileBind.call(this)
refreshForm = ->
    # refresh everything
    $form_publish = $('form.form__body')
    $form_imgs_wrapper = $form_publish.find('.imgs-wrapper')
    $form_tags = $form_publish.find('.mytags')
    $form_recommendation = $form_publish.find('textarea')
    $preview = $form_publish.find('dl.big_img.static')
    $preview_title = $preview.find('.item-b_title')
    $preview_price = $preview.find('.item-b_price')
    $draggable_bg = $preview.find('.item-b_image.preview')
    $blackbox = $('.popup__blackbox')
    $popup_url = $blackbox.find('input[name=url]')
    $form_publish.find('input').each ->
      $(this).val('')
    $form_publish.find('select').each ->
      $(this).find('option').remove()
    $form_imgs_wrapper.find('.url-img').remove()
    $('.item-tags').find('span').remove()
    $form_tags.find('li').not('.tag-title').remove()
    $form_recommendation.val('')

    $preview_title.html('商品标题')
    $preview_price.html('¥0.00')
    $draggable_bg.find('img').remove()

    $popup_url.val('')
    $('.urlwarning').html('')
    $('.fwarning').html('')

changeState = (action)->
  if window.history.pushState
    history.pushState(null, null, action + '-' + uid + '.html')
  window.state = action

slideToCurrent = (padding)->
  padding = padding or 60
  tab_width = Math.ceil($(this).width()) + padding
  cnt_wrap_w = $('.content .center-wrap').width()
  win_w = $(window).width()
  wrap_offset = (win_w - cnt_wrap_w) / 2
  $('.js-slide-bg').width tab_width
  $('.js-slide-bg').css({'left': $(this).offset().left - wrap_offset})
  $(this).parent().parent().find('li').removeClass('current')
  $(this).addClass('current')

toggleGoods = (show)->
  if show
    $('.item-list-filter').fadeIn(500)
    $('.item-list-container').fadeIn(500)
    $('.item-pagiation').fadeIn(500)
    $('.show-more').fadeIn(500)
    $('.form__container').hide()
  else
    changeState('talk')
    slideToCurrent.apply($('.actions-pub'))
    $('.item-list-filter').fadeOut(500)
    $('.item-list-container').fadeOut(500)
    $('.item-pagiation').fadeOut(500)
    $('.show-more').fadeOut(500)
    $('.form__container').fadeIn(500)

isInActions = ->
  if (location.pathname.indexOf('dashboard') > 0) or 
     (location.pathname.indexOf('fav') > 0) or 
     (location.pathname.indexOf('talk') > 0)
    return true
  else
    return false

isEditingGood = ->
  return $('.form__container').is(':visible')

giveupEditing = ->
  if isEditingGood()
    if confirm('是否放弃编辑单品？') 
      refreshForm()
      if isInActions()
        toggleGoods(true)
      return true
    else
      return false
  else
    return true

followItem_Generater = (data,current_index) ->
  if _is_mobile
    fans_count = format_count(data.fans)
    follow_count = format_count(data.follows)
  else
    if parseInt(data.fans) > 0
      fans_count = data.fans
    else
      fans_count = 0
    if parseInt(data.follows) > 0
      follow_count = data.follows
    else
      follow_count = 0
  dd = $('<dd class="follow-list_item" i="' + current_index + '" t-uid=' + data.uid + '>'+
    '<div class="fans-container">' +
      '<div class="fans-face">' +
        '<a href="' + data.user_href + '" target="_blank">' +
          '<img src="' + data.img_thumb + '" alt="' + data.user_name + '"/>' +
        '</a>' +
      '</div>' +
      '<div class="fans-content">' +
        '<div class="fans-text">' +
          '<div class="fans-name" title=' + data.user_name + '>' +
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
                '<i class="icon icon-fans"></i>' +
                '<span><b>' + fans_count + '</b>粉丝</span>' +
            '</div>' +
            '<div class="fans-concemed_follow" uid="' + data.uid + '">' +
                '<i class="icon icon-following"></i>' +
                '<span><b>' + follow_count + '</b>关注</span>' +
            '</div>' +
          '</div>' +
            (
              if parseInt(data.uid) isnt parseInt(window.myid)
                status_class = ''
                status_text = ''
                status_icon = ''
                status_btn = ''
                status_code = ''
                if data.is_follow is 1
                  status_class = 'follow_ed'
                  status_btn = 'slider--on'
                  if data.is_gz is 0
                    status_icon = 'icon-followed'
                    status_text = '已关注'
                    status_code = '1'
                  else
                    status_icon = 'icon-friends'
                    status_text = '互相关注'
                    status_code = '2'
                else
                  status_class = 'follow_nt'
                  status_text = '关注Ta'
                  status_icon = 'icon-follow'
                  status_code = '0'

                "<div class='fans__follow-btn follow-btn #{status_btn}' follow-status='#{status_code}'>" +
                  "<div class='slider'>" +
                    "<i class='icon #{status_icon}'></i>" +
                    "<a class='status_text'>#{status_text}</a>" +
                  "</div>" +
                  "<div class='slider-btn'></div>" +
                "</div>"
              else
                ''
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
            '<img src="' + data.img + '" alt="' + decodeURIComponent(data.title) + '"/>' +
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
                    if data.like_total > 2
                      '<span> 等' + data.like_total + '人喜欢此搭配</span>'
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
            '<img src="' + data.img + '" alt="' + decodeURIComponent(data.title) + '"/>' +
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
#                if data.is_share_fav is 1 or data.like_user_list
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
                      if data.like_total > 2
                        '<span> 等' + data.like_total + '人喜欢此单品</span>'
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
          '<img src="' + data.img_thumb.replace('_small','_middle') + '"/>' +
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

  if _is_mobile
    view_count = format_count(data.view_count)
    like_count = format_count(data.like_count)
    comment_count = format_count(data.comment_count)
  else
    view_count = data.view_count
    like_count = data.like_count
    comment_count = data.comment_count

  dd = $('<dd class="item ' + sid + '" i="' + current_index + '" dtype="' + dtype + '">' +
      '<div>' +
        '<div class="item-s_image">' +
        '<img src="' + data.img + '" alt="' + decodeURIComponent(data.title) + '"/>' +
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
            '<span class="like_count">' + data.like_count + '</span>' +
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
#                if data.is_share_fav is 1 or data.like_user_list
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
          '<span class="count">' + view_count + '</span>' +
          '<span class="icon icon_like icon-hearted"></span>' +
          '<span class="count like_count">' + like_count + '</span>' +
          '<span class="icon icon-comment"></span>' +
          '<span class="count comment_count">' + comment_count + '</span>' +
        '</div>' +
      '</div>' +
    '</dd>')

filter_generater = () ->
  if state is 'fav'
    search_type = '喜欢'
  else if state is 'talk'
    search_type = '发布'
  else if state is 'follow'
    search_type = '关注'

  if state is 'follow'
    search_input_class = 'follow'
    search_keyword = _follow_search_keyword
  else
    search_input_class = 'dashboard'
    search_keyword = _dashboard_search_keyword

  content = $(
    '<div class="item-nav-container">' +
      (if state is 'dashboard'
        '<div class="item-nav nav-dashboard first current">' +
          '<a>热门单品</a>' +
          '<span></span>' +
        '</div>'
      else if state is 'fav' or state is 'talk'
        '<div class="item-nav nav-type nav-produce first' + (if _dashboard_show_product_collocation is 1 then ' current' else '') + '" t="1">' +
          '<a>潮品</a>' +
          '<span></span>' +
        '</div>' +
        '<div class="item-nav nav-type nav-collocation' + (if _dashboard_show_product_collocation is 1 then '' else ' current') + '" t="2">' +
          '<a>搭配</a>' +
          '<span></span>' +
        '</div>'
      else
        ''
      ) +
    '</div>' +
    '<div class="item-filter-container">' +
      (if _dashboard_show_me or _follow_show_me
        if state is 'follow' or state is 'fav' or state is 'talk'
          '<div class="item-filter search">' +
            '<div class="search_form">' +
              '<i class="icon icon-search"></i>' +
              '<input type="text" class="list-search" placeholder="搜索' + search_type + '" value="' + search_keyword + '"/>' +
              '<i class="icon icon-closepop clear-list-search' + (if search_keyword isnt '' then ' show' else '') + '"></i>' +
            '</div>' +
          '</div>'
        else
          ''
      else
        ''
      ) +
      (if _dashboard_show_me and !_dashboard_list_by_search
        if state is 'talk'
          '<div class="item-filter sort">'+
            '<a class="show-new_list' + (if _dashboard_show_new_hot is 'new' then ' current' else '') + '">' +
              '<i class="icon icon-decendent"></i>' +
              '<span>综合</span>' +
            '</a>' +
            '<a class="show-hot_list' + (if _dashboard_show_new_hot is 'new' then '' else ' current') + '">' +
              '<i class="icon icon-decendent"></i>' +
              '<span>人气</span>' +
            '</a>' +
          '</div>'
        else
          ''
      else
        ''
      ) +
      (if state is 'dashboard' or state is 'fav' or state is 'talk'
        '<div class="item-filter mode">'+
          '<a class="show-big_list' + (if _dashboard_show_big then ' current' else '') + '">' +
            '<i class="icon icon-list_view"></i>' +
          '</a>' +
          '<a class="show-small_list' + (if _dashboard_show_big then '' else ' current') + '">' +
            '<i class="icon icon-grid_view"></i>' +
          '</a>' +
        '</div>'
      else
        ''
      ) +
    '</div>' +
    '<div class="item-search-result">' +
      '<span></span>' +
    '</div>'
  )

show_search_result = (keyword,count) ->
  search_result = $('.item-search-result')
  if state is 'follow'
    type = '用户'
    show_class = 'show_follow'
  else
    type = '结果'
    show_class = 'show'
  result_text = ['找到',count,'个 ',keyword,' 相关',type].join ''
  search_result.find('span').html(result_text)
  search_result.addClass(show_class)

hide_search_result = () ->
  $('.item-search-result').removeClass('show')

publishItem_Generater = (type) ->
  content = ''
  if type == 1
    content = '潮品'
  else
    content = '搭配'
  dd = $(
    '<dd class="item publish_entrance" d-type="' + type + '">' +
      '<div>' +
#        '<i class="icon icon-publish"></i><br/>' +icon-publish_solid
        '<i class="icon icon-publish_solid"></i><br/>' +
        '<span class="clear">发布' + content + '</span>' +
      '</div>' +
    '</dd>'
  )

parallax = (obj)->
  y = $('body').scrollTop()
  obj.css({'background-position-y': -(y / 5) + 'px'})

set_search_w = ->
  if !_is_mobile
    win_w = $(window).width()
    $('.main-nav__search').width win_w -
      $('.main-nav--right').width() -
      $('.main-nav').width() - 40

fixMainnav = ->
  if _is_mobile
    ucantseeme_point = 100
    fixed_point = 120
    footer_height = 100
  else
    ucantseeme_point = 250
    fixed_point = 400
    footer_height = 388
  $icon_hand = $('.main-nav__me').find('.icon')

  if $('body').scrollTop() >= ucantseeme_point
    $('.main-nav-container').addClass('ucantseeme')
    $('.fixed-nav-container').addClass('ucantseeme')
    $icon_hand.hide()
  else
    $('.main-nav-container').removeClass('ucantseeme')
    $('.fixed-nav-container').removeClass('ucantseeme')
    $icon_hand.show()

  if $('body').scrollTop() >= fixed_point
    $('.main-nav-container,.main-nav').addClass('fixed')

    if !_is_mobile
      $('.scroll-to-top').addClass('fixed')
    else
      if state is 'fans' or state is 'follow'
        $('.mobile-view-change').hide()

  else
    $('.main-nav-container,.main-nav').removeClass('fixed')
    if !_is_mobile
      $('.scroll-to-top').removeClass('fixed')

  footer_height = footer_height - 70
  bottom_distance = $(document).height() - ($(this).scrollTop() + $(window).height())
  bottom_distance_out_range = footer_height - bottom_distance
  if bottom_distance <= footer_height
    $('.scroll-to-top').css('bottom',(bottom_distance_out_range + 70) + 'px')
  else
    $('.scroll-to-top').css('bottom','70px')

  set_search_w()

excite_Anim = (obj,animName) ->
  $(obj).addClass(animName + ' animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
    obj.removeClass(animName).removeClass('animated')
  );

$(document).on 'blur','.list-search', ->
  set_clean_list_search($(this))
$(document).on 'keyup','.list-search', ->
  set_clean_list_search($(this))

set_clean_list_search = (me) ->
  clear_icon = me.parent().find('i.icon-closepop')
  if state is 'fav' or state is 'talk'
    list_by_search = _dashboard_list_by_search
  else if state is 'follow'
    list_by_search = _follow_list_by_search
  else
    list_by_search = false

  if me.val() isnt '' or list_by_search
    clear_icon.addClass('show')
  else
    clear_icon.removeClass('show')

$(document).on 'click','.search_form .icon-search', ->
  me = $(this)
  keyword =  me.parent().find('.list-search').val()
  do_list_search(keyword)

$(document).on 'keypress','.list-search', (e)->
  me = $(this)
  if(e.which == 13)
    if me.val() isnt ''
      do_list_search(me.val())

do_list_search = (keyword) ->
  if keyword isnt ''
    if state is 'fav' or state is 'talk'
      _dashboard_search_keyword = keyword
      _dashboard_list_by_search = true
      init_dashboard_data(true)
    else if state is 'follow'
      _follow_search_keyword = keyword
      _follow_list_by_search = true
      init_follow_data(true)

$(document).on 'click','#btnInitList', ->
  clean_list_search()

$(document).on 'click','.clear-list-search', ->
  clean_list_search()

clean_list_search = () ->
  search_text = $('.list-search')
  if search_text isnt ''
    search_text.val('')
    $('.clear-list-search').removeClass('show')
    if state is 'fav' or state is 'talk'
      _dashboard_search_keyword = ''
      if _dashboard_list_by_search
        init_dashboard_data()
    else if state is 'follow'
      _follow_search_keyword = ''
      if _follow_list_by_search
        init_follow_data()

format_count = (count) ->
  if parseInt(count) > 0
    if parseInt(count) >= 10000
      [Math.round(count/1000),'k'].join ''
    else if parseInt(count) >= 1000
      [(count/1000).toFixed(1),'k'].join ''
    else
      count
  else
    0

calculateTimes = (in_time) ->
  ((new Date) - in_time) / (1000 * 60)
