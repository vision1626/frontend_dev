_dashboard_is_loading = false
_dashboard_limit = 24
_dashboard_start_b = 0
_dashboard_end_b = 0
_dashboard_step_b = _dashboard_limit/2
_dashboard_start_s = 0
_dashboard_end_s = 0
_dashboard_step_s = _dashboard_limit
_dashboard_count = dashboard_count
_dashboard_show_big = true

SITE_URL = 'http://192.168.0.230/'

init_dashboard = ->
  biglist = $('.big_img')
  listempty = $('.list-empty')
  listloading = $('.list-loading')
#  _dashboard_count = dashboard_count
  if list_data
    _dashboard_end_b = _dashboard_step_b
#    _dashboard_end_s = _dashboard_step_s
    _dashboard_is_loading = true
    for ld,i in list_data
      if _dashboard_start_b < _dashboard_end_b
        bigItemGenerater(ld,i)
        _dashboard_start_b++
    _dashboard_is_loading = false
    listloading.hide()
    biglist.show()
  else
    listloading.hide()
    listempty.show()

$(window).scroll ->
  if ($(this).scrollTop() + $(window).height() + 100 >= $(document).height() && $(this).scrollTop() > 100)
    loadDashboardItem()

$(document).on 'click','.show-big_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-small_list').removeClass('current')
    _dashboard_show_big = true
    loadDashboardItem()
    $('dl.big_img').show()
    $('dl.small_img').hide()

$(document).on 'click','.show-small_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-big_list').removeClass('current')
    _dashboard_show_big = false
    loadDashboardItem()
    $('dl.big_img').hide()
    $('dl.small_img').show()

$(document).on 'click','.show-more', ->
  btn_ShowMore = $(document).find('.show-more')
  if !_dashboard_is_loading
    _dashboard_is_loading = true

    if _dashboard_end_b > _dashboard_end_s
      page = (_dashboard_end_b/_dashboard_limit)+1
    else if _dashboard_end_s > _dashboard_end_b
      page = (_dashboard_end_s/_dashboard_limit)+1
    else
      page = (_dashboard_end_b/_dashboard_limit)+1

    btn_ShowMore.html('正在努力加载中...').addClass('loading')
    $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {m: 'u', a: 'get_dashboard_ajax', ajax: 1, page: page, count: _dashboard_count, sort: 'new',limit: _dashboard_limit}
      cache: false
      dataType: "json"
      success: (result)->
        for d in result.data
          list_data.push(d)
        loadDashboardItem()
        _dashboard_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
      error: (result)->
        alert('errr: ' + result)
        _dashboard_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
    }

loadDashboardItem = () ->
  _dashboard_is_loading = true
  if _dashboard_show_big
    if _dashboard_end_b < list_data.length
      #预加载仍有数据
      _dashboard_end_b += _dashboard_step_b
      for ld,i in list_data
        if _dashboard_start_b < _dashboard_end_b and i >= _dashboard_start_b
          bigItemGenerater(ld,i)
          _dashboard_start_b++
#      $('.item-pagiation').hide()
    else
#      $('.item-pagiation').show()
  else
    if _dashboard_end_s < list_data.length
      _dashboard_end_s += _dashboard_step_s
      for ld,j in list_data
        if _dashboard_start_s < _dashboard_end_s and j >= _dashboard_start_s
          smallItemGenerater(ld,j)
          _dashboard_start_s++
  _dashboard_is_loading = false

bigItemGenerater = (data,current_index) ->
  biglist = $('.big_img')

  dd = $('<dd class="item">' +
    '<div>' +
      (if data.dynamic_type is 1
        '<div class="item-l_image">' +
          '<a href="' + data.url + '">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
          '<dl class="collocation">' +
            (
              for g in data.goods
                '<dd class="collocation_item">' +
                  '<div class="goods_item">' +
                    '<a href="' + g.url + '">' +
                      '<img src="' + g.img + '" alt=""/>' +
                    '</a>' +
                  '</div>' +
                '</dd>'
            ) +
          '</dl>' +
        '</div>' +
        '<div class="item-b_description">' +
        '<div class="item-b_isnew">' +
          (
            if data.is_dapei_like is 1 or data.like_user_list
              (
                for lu in data.like_user_list
                  '<span>'+
                    '<a href="' + lu.user_href + '">' +
                    lu.user_name +
                    '</a>' +
                    '</span>'
              )+
                '<span> 喜欢此搭配</span>'
            else
              '<span class="item_tag">NEW</span>' +
                '<span>新发布</span>'
          ) +
          '</div>' +
        '</div>'
      else
        '<div class="item-b_image">' +
          '<a href="' + data.url + '">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
        '</div>' +
        '<div class="item-b_description">' +
          '<div class="item-b_isnew">' +
            (
              if data.is_share_fav is 1 or data.like_user_list
                (
                  for lu in data.like_user_list
                    '<span>'+
                      '<a href="' + lu.user_href + '">' +
                        lu.user_name +
                      '</a>' +
                    '</span>'
                )+
                '<span> 喜欢此单品</span>'
              else
                '<span class="item_tag">NEW</span>' +
                '<span>新发布</span>'
            ) +
          '</div>' +
          '<div class="item-b_title">' +
            '<span>' + data.title + '</span>' +
          '</div>' +
          '<div class="item-b_price">' +
            '<span>¥' + data.goods_price + '</span>' +
          '</div>' +
        '</div>'
      ) +

      '<div class="item-b_additional">' +
        '<a href="' + data.user_href + '">' +
          '<img src="' + data.img_thumb + '"/>' +
        '</a>' +
        '<div class="item-value">' +
          '<span class="icon icon-viewed"></span>' +
          '<span>' + data.view_count + '</span>' +
          '<span class="icon icon-comment"></span>' +
          '<span>' + data.comment_count + '</span>' +
        '</div>' +
      '</div>' +
      '<div class="item-b_add_like">' +
        '<a>' +
          '<span class="icon icon-heart"></span>' +
          '<br/>' +
          '<span class="like_count">' +
            data.like_total +
          '</span>' +
        '</a>' +
      '</div>' +
      '</div>' +
    '</dd>')

  biglist.append(dd)

smallItemGenerater = (data,current_index) ->
  smalllist = $('.small_img')

  dd = $('<dd class="item">' +
      '<div>' +
        '<div class="item-s_image">' +
          '<img src="' + data.img_small + '" alt="' + data.title + '"/>' +
        '</div>' +
        '<div class="item-s_description">' +
          '<div class="item-s_owner">' +
            '<a href="' + data.user_href + '">' +
              '<img src="' + data.img_thumb + '"/>' +
            '</a>' +
          '</div>' +
          '<div class="item-s_action">' +
            '<a class="action-add_special">' +
              '<span class="icon icon-album"></span>' +
            '</a>' +
            '<a class="action-add_like">' +
              '<span class="icon icon-heart"></span>' +
            '</a>' +
          '</div>' +
          (
            if data.dynamic_type is 1
              '<div class="item-s_isnew">' +
                (
                  if data.is_dapei_like is 1 or data.like_user_list
                    (
                      for lu in data.like_user_list
                        '<span>'+
                          '<a href="' + lu.user_href + '">' +
                          lu.user_name +
                          '</a>' +
                          '</span>'
                    )+
                      '<span> 喜欢了</span>'
                  else
                    '<span>NEW</span>'
                ) +
              '</div>' +
              '<dl class="collocation">' +
                (
                  for g in data.goods
                    '<dd class="collocation_item">' +
                      '<div class="goods_item">' +
                      '<a href="' + g.url + '">' +
                      '<img src="' + g.img + '" alt=""/>' +
                      '</a>' +
                      '</div>' +
                      '</dd>'
                ) +
                '</dl>'
            else
              '<div class="item-s_isnew">' +
                (
                  if data.is_share_fav is 1 or data.like_user_list
                    (
                      for lu in data.like_user_list
                        '<span>'+
                          '<a href="' + lu.user_href + '">' +
                          lu.user_name +
                          '</a>' +
                          '</span>'
                    )+
                      '<span> 喜欢了</span>'
                  else
                    '<span>NEW</span>'
                ) +
              '</div>' +
              '<div class="item-s_title">' +
                '<a href="' + data.url + '">' +
                  '<span>' + data.title + '</span>' +
                '</a>' +
              '</div>' +
              '<div class="item-s_price">' +
                '<span>¥' + data.goods_price + '</span>' +
              '</div>'
          ) +
          '<div class="item-s_additional">' +
            '<span class="icon icon-viewed"></span>' +
            '<span>' + data.view_count + '</span>' +
            '<span class="icon icon-hearted"></span>' +
            '<span>' + data.like_total + '</span>' +
            '<span class="icon icon-comment"></span>' +
            '<span>' + data.comment_count + '</span>' +
          '</div>' +
        '</div>' +
      '</div>')
  smalllist.append(dd)