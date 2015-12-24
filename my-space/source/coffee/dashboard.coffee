_dashboard_is_loading = false
_dashboard_limit = 24
_dashboard_start_b = 0
_dashboard_end_b = 0
_dashboard_step_b = _dashboard_limit/2
_dashboard_start_s = 0
_dashboard_end_s = 0
_dashboard_step_s = _dashboard_limit
_dashboard_show_big = true
_dashboard_show_new_hot = 'new'
_dashboard_has_more = true

#SITE_URL = 'http://192.168.0.230/'

init_dashboard = ->
  biglist = $('#big_img')
  listempty = $('#list-empty')
  listloading = $('#list-loading')
  pagiation = $('#item-pagiation')

  listloading.show()
  if dashboard_list_data
    _dashboard_end_b = _dashboard_step_b
    _dashboard_is_loading = true
    for ld,i in dashboard_list_data
      if _dashboard_start_b < _dashboard_end_b
        big_Item_Generater(ld,i)
        _dashboard_start_b++
    _dashboard_is_loading = false
    listloading.hide()
    biglist.show()
    pagiation.show()
  else
    listloading.hide()
    listempty.show()

$(window).scroll ->
  if ($(this).scrollTop() + $(window).height() + 100 >= $(document).height() && $(this).scrollTop() > 100)
    gen_Dashboard_Item()

$(document).on 'click','.show-new_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-hot_list').removeClass('current')
    _dashboard_show_new_hot = 'new'
    init_dashboard_data()

$(document).on 'click','.show-hot_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-new_list').removeClass('current')
    _dashboard_show_new_hot = 'hot'
    init_dashboard_data()

$(document).on 'click','.show-big_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-small_list').removeClass('current')
    _dashboard_show_big = true
    gen_Dashboard_Item()
    $('dl.big_img').show()
    $('dl.small_img').hide()

$(document).on 'click','.show-small_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-big_list').removeClass('current')
    _dashboard_show_big = false
    gen_Dashboard_Item()
    $('dl.big_img').hide()
    $('dl.small_img').show()

$(document).on 'click','.show-more', ->
  query_Dashboard_Data()

$(document).on 'click','.btn_like', ->
  do_like(this)

query_Dashboard_Data = () ->
  btn_ShowMore = $(document).find('.show-more')

  if !_dashboard_is_loading and _dashboard_has_more
    _dashboard_is_loading = true

    if dashboard_list_data.length > 0
      if _dashboard_end_b > _dashboard_end_s
        page = (_dashboard_end_b/_dashboard_limit)+1
      else if _dashboard_end_s > _dashboard_end_b
        page = (_dashboard_end_s/_dashboard_limit)+1
      else
        page = (_dashboard_end_b/_dashboard_limit)+1
    else
      page = 1

    btn_ShowMore.html('正在努力加载中...').addClass('loading')
    $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {'m': 'u', 'a': 'get_dashboard_ajax', ajax: 1, 'page': page, 'count': window.dashboard_count, 'sort': _dashboard_show_new_hot,'limit': _dashboard_limit}
      cache: false
      dataType: "json"
      success: (result)->
        for d in result.data
          dashboard_list_data.push(d)
        gen_Dashboard_Item()
        _dashboard_is_loading = false
        if result.more is 1
          btn_ShowMore.html('我要看更多').removeClass('loading')
          _dashboard_has_more = true
        else
          btn_ShowMore.html('已经全部看完了').removeClass('loading')
          _dashboard_has_more = false
      error: (result)->
        alert('errr: ' + result)
        _dashboard_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
    }

gen_Dashboard_Item = () ->
  _dashboard_is_loading = true
  biglist = $('#big_img')
  smalllist = $('#small_img')
  listloading = $('#list-loading')

  if _dashboard_show_big
    if _dashboard_end_b < dashboard_list_data.length
      _dashboard_end_b += _dashboard_step_b
      for ld,i in dashboard_list_data
        if _dashboard_start_b < _dashboard_end_b and i >= _dashboard_start_b
          big_Item_Generater(ld,i)
          _dashboard_start_b++
    biglist.show()
    listloading.hide()
  else
    if _dashboard_end_s < dashboard_list_data.length
      _dashboard_end_s += _dashboard_step_s
      for ld,j in dashboard_list_data
        if _dashboard_start_s < _dashboard_end_s and j >= _dashboard_start_s
          small_Item_Generater(ld,j)
          _dashboard_start_s++
    smalllist.show()
    listloading.hide()
  _dashboard_is_loading = false

init_dashboard_data = () ->
  biglist = $('#big_img')
  smalllist = $('#small_img')
  listloading = $('#list-loading')
  pagiation = $('#item-pagiation')
  btn_ShowMore = $(document).find('.show-more')

  _dashboard_start_b = 0
  _dashboard_end_b = 0
  _dashboard_start_s = 0
  _dashboard_end_s = 0
  dashboard_list_data.length = 0
  listloading.show()
  biglist.html('')
  biglist.hide()
  smalllist.html('')
  smalllist.hide()
  btn_ShowMore.html('我要看更多').removeClass('loading')
  _dashboard_has_more = true

  query_Dashboard_Data()

do_like = (obj) ->
  sid = $(obj).attr('sid')
  dtype = $(obj).attr('dtype')
  ed = $(obj).attr('ed')
#
#  if dtype is 1
#
#  else if dtype is 2
#
#  else

big_Item_Generater = (data,current_index) ->
  biglist = $('#big_img')

  dd = $('<dd class="item ' + data.share_id + '">' +
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
      '<div class="item-b_add_like btn_like" sid="' + data.share_id + '" dtype="' + data.dynamic_type + '"  ed="' + data.dynamic_type + '">' +
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

small_Item_Generater = (data,current_index) ->
  smalllist = $('#small_img')

  dd = $('<dd class="item ' + data.share_id + '">' +
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
            '<a class="action-add_like btn_like" sid="' + data.share_id + '" dtype="' + data.dynamic_type + '" ed="' + data.dynamic_type + '">' +
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
            '<span class="count">' + data.view_count + '</span>' +
            '<span class="icon icon-hearted"></span>' +
            '<span class="count">' + data.like_total + '</span>' +
            '<span class="icon icon-comment"></span>' +
            '<span class="count">' + data.comment_count + '</span>' +
          '</div>' +
        '</div>' +
      '</div>')
  smalllist.append(dd)