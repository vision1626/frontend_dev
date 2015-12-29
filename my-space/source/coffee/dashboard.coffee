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
        biglist.append(big_DashboardItem_Generater(ld,i))
        _dashboard_start_b++
    _dashboard_is_loading = false
    listloading.hide()
    biglist.show()
    if parseInt(dashboard_count) > _dashboard_limit
      pagiation.show()
      _dashboard_has_more = true
    else
      pagiation.hide()
      _dashboard_has_more = false
  else
    listloading.hide()
    listempty.show()

$(window).bind 'scroll', (e)->
  parallax($('.profile-container'))
  e.stopPropagation()

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

$(document).on 'click','#dashboard-show-more', ->
  query_Dashboard_Data()

$(document).on 'click','.btn_like', ->
  do_like(this)

query_Dashboard_Data = () ->
  if dashboard_list_data isnt undefined
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
          biglist.append(big_DashboardItem_Generater(ld,i))
          _dashboard_start_b++
    biglist.show()
    listloading.hide()
  else
    if _dashboard_end_s < dashboard_list_data.length
      _dashboard_end_s += _dashboard_step_s
      for ld,j in dashboard_list_data
        if _dashboard_start_s < _dashboard_end_s and j >= _dashboard_start_s
          smalllist.append(small_DashboardItem_Generater(ld,j))
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
  me = $(obj)
  sid = me.attr('sid')
  dtype = me.attr('dtype')
  ed = me.attr('ed')
  liststyle = me.attr('l')
  method = "GET"

  job = 0

  if dtype is 'd'
    url = 'dapei.php?action=dp_fav'
    method = "POST"
  else if dtype is 's'
    if ed is '0'
      url = 'services/service.php?m=share&a=fav'
      job = 1
    else
      url = 'services/service.php?m=share&a=removefav'
      job = 2

  $.ajax {
    url: SITE_URL + url
    type: method
    data: {ajax: 1, 'id': sid}
    cache: false
    dataType: "json"
    success: (result)->
      after_like(me,dtype,result,job,liststyle)
    error: (result)->
      alert('errr: ' + result)
  }

after_like = (me,dtype,result,job,liststyle) ->
  ed = 0
  if dtype is 'd'
    if result.status is 1
      ed = 1
  else if dtype is 's'
    if job is 1
      if result.status is 1
        ed = 1
    else if job is 2
      if result.status is 1
        ed = 0
  if liststyle is 'b'
    refresh_like_big(me,ed,result.count)
  else if liststyle is 's'
    refresh_like_small(me,ed,result.count)

refresh_like_big = (me,ed,count) ->
  my_icon = me.find('.icon')
  my_count = me.find('.like_count')
  if ed is 1
    my_icon.removeClass('icon-heart').addClass('icon-hearted')
  else
    my_icon.removeClass('icon-hearted').addClass('icon-heart')
  my_count.html(count)
  me.attr('ed',ed)

refresh_like_small = (me,ed,count) ->
  my_icon = me.find('.icon')
  my_count = me.parent().parent().find('.like_count')
  if ed is 1
    my_icon.removeClass('icon-heart').addClass('icon-hearted')
  else
    my_icon.removeClass('icon-hearted').addClass('icon-heart')
  my_count.html(count)
  me.attr('ed',ed)