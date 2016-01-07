_dashboard_is_loading = false
_dashboard_limit = 28
_dashboard_start_b = 0
_dashboard_end_b = 0
_dashboard_step_b = _dashboard_limit
_dashboard_start_s = 0
_dashboard_end_s = 0
_dashboard_step_s = _dashboard_limit
_dashboard_show_big = true
_dashboard_show_new_hot = 'new'
_dashboard_has_more = true
_dashboard_has_publish_btn_b = false
_dashboard_has_publish_btn_s = false
_user_mail_vrification = true
_dashboard_show_me = false
_dashboard_doing_like = false

#SITE_URL = 'http://192.168.0.230/'

init_dashboard = ->
#  biglist = $('#big_img')
#  listempty = $('#list-empty')
#  listloading = $('#list-loading')
#  pagiation = $('#item-pagiation')
#  filter = $('#list-filter')

#  if window.dashboard_count is ''
#    window.dashboard_count = 0
  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  if window.dashboard_list_string isnt ''
    window.dashboard_list_data = $.parseJSON(window.dashboard_list_string)

  init_dashboard_empty_message()
  gen_dashboard_item()
#  listloading.show()
#  if window.dashboard_list_data
##    _dashboard_end_b = _dashboard_step_b
#    _dashboard_is_loading = true
##    for ld,i in window.dashboard_list_data
##      if _dashboard_start_b < _dashboard_end_b
##        biglist.append(big_DashboardItem_Generater(ld,i))
##        _dashboard_start_b++
#    gen_dashboard_item()
#    _dashboard_is_loading = false
#    listloading.hide()
#    biglist.show()
#
#    if parseInt(window.dashboard_count) > _dashboard_limit
#      pagiation.show()
#      _dashboard_has_more = true
#    else
#      pagiation.hide()
#      _dashboard_has_more = false
#  else
#    listloading.hide()
#    listempty.show()
#    pagiation.hide()
#    filter.hide()
#    _dashboard_has_more = false

$(window).bind 'scroll', (e)->
  parallax($('.profile-container'))
  e.stopPropagation()

#  if ($(this).scrollTop() + $(window).height() + 200 >= $(document).height() && $(this).scrollTop() > 200)
#    gen_dashboard_item()

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
    gen_dashboard_item()
    $('dl#big_img').show()
    $('dl#small_img').hide()

$(document).on 'click','.show-small_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-big_list').removeClass('current')
    _dashboard_show_big = false
    gen_dashboard_item()
    $('dl#big_img').hide()
    $('dl#small_img').show()

$(document).on 'click','#dashboard-show-more', ->
  query_dashboard_data()

$(document).on 'click','.btn_like', ->
  if !_dashboard_doing_like
    _dashboard_doing_like = true
    do_like(this)

$(document).on 'click','.publish_entrance', ->
  if _user_mail_vrification
#    url = ['u/addshare-',myid,'.html'].join('')
#    location.href = SITE_URL + url
    $('.popup__blackbox').fadeIn(300)
  else
    alert('老板,您还未验证E-Mail')


$(document).on 'click','div.return_home', ->
  location.href = SITE_URL

query_dashboard_data = () ->
  btn_ShowMore = $(document).find('#dashboard-show-more')

  if !_dashboard_is_loading and _dashboard_has_more

    _dashboard_is_loading = true

    if window.dashboard_list_data
      if window.dashboard_list_data isnt null
        if window.dashboard_list_data.length > 0
          if _dashboard_end_b > _dashboard_end_s
            page = (_dashboard_end_b/_dashboard_limit)+1
          else if _dashboard_end_s > _dashboard_end_b
            page = (_dashboard_end_s/_dashboard_limit)+1
          else
            page = (_dashboard_end_b/_dashboard_limit)+1
        else
          page = 1
      else
        page = 1
    else
      page = 1

    if state is 'fav'
      action = 'get_fav_ajax'
    else if state is 'talk'
      action = 'get_publish_ajax'
    else
      action = 'get_dashboard_ajax'

    btn_ShowMore.html('正在努力加载中...').addClass('loading')
    $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {'m': 'u', 'a': action, ajax: 1, 'page': page, 'count': window.dashboard_count, 'sort': _dashboard_show_new_hot,'limit': _dashboard_limit, 'hid': window.uid}
      cache: false
      dataType: "json"
      success: (result)->
        window.dashboard_count = result.count
        if result.data
          if window.dashboard_list_data and window.dashboard_list_data.length > 0
            for d in result.data
              window.dashboard_list_data.push(d)
          else
            window.dashboard_list_data = result.data
        gen_dashboard_item()

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

query_dashboard_recommand_data = () ->
  if state is 'fav'
    action = 'get_approve_fav_ajax'
    recommand_limit = 5
  else
    action = 'get_approve_user_ajax'
    recommand_limit = 7

  $.ajax {
    url: SITE_URL + 'services/service.php'
    type: "GET"
    data: {'m': 'u', 'a': action, ajax: 1, 'page': 1, 'count': '', 'limit': recommand_limit, 'follow',0}
    cache: false
    dataType: "json"
    success: (result)->
      if result.data
        gen_dashboard_recommand_item(result.data)
    error: (result)->
      alert('errr: ' + result)
  }

gen_dashboard_item = () ->
  _dashboard_is_loading = true
  biglist = $('#big_img')
  smalllist = $('#small_img')
  listloading = $('#list-loading')
  listempty = $('#list-empty')
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  pagiation = $('#item-pagiation')
  filter = $('#list-filter')

  if window.dashboard_list_data
    if window.dashboard_list_data.length > 0
      if _dashboard_show_big
        if window.location.pathname.indexOf('talk') > 0
          if _dashboard_show_me
            if !_dashboard_has_publish_btn_b
              biglist.append(publishItem_Generater(myid))
              _dashboard_has_publish_btn_b = true
        if _dashboard_end_b < window.dashboard_list_data.length
          _dashboard_end_b += _dashboard_step_b
          for ld,i in window.dashboard_list_data
            if _dashboard_start_b < _dashboard_end_b and i >= _dashboard_start_b
              biglist.append(big_DashboardItem_Generater(ld,i))
              _dashboard_start_b++
        biglist.show()
      else
        if window.location.pathname.indexOf('talk') > 0
          if _dashboard_show_me
            if !_dashboard_has_publish_btn_s
              smalllist.append(publishItem_Generater(myid))
              _dashboard_has_publish_btn_s = true
        if _dashboard_end_s < window.dashboard_list_data.length
          _dashboard_end_s += _dashboard_step_s
          for ld,j in window.dashboard_list_data
            if _dashboard_start_s < _dashboard_end_s and j >= _dashboard_start_s
              smalllist.append(small_DashboardItem_Generater(ld,j))
              _dashboard_start_s++
        smalllist.show()
      if parseInt(window.dashboard_count) > _dashboard_limit
        pagiation.show()
      else
        pagiation.hide()

      filter.show()
      listempty.hide()
      recommandTitle.hide()
      recommandList.hide()
    else
      pagiation.hide()
      listempty.show()
      filter.hide()
      if _dashboard_show_me
        if state is 'fav' or state is 'dashboard'
          query_dashboard_recommand_data()
  else
    pagiation.hide()
    listempty.show()
    filter.hide()
    if _dashboard_show_me
      if state is 'fav' or state is 'dashboard'
        query_dashboard_recommand_data()

  listloading.hide()
  _dashboard_is_loading = false

gen_dashboard_recommand_item = (data) ->
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  if state is 'fav'
    for ld,i in data
      recommandList.append(big_DashboardItem_Generater(ld,i))
      recommandList.removeClass('follow-list').addClass('big_img')
      recommandTitle.find('.item-nav.first').find('a').html('热门单品')
  else
    for ld,i in data
      recommandList.append(followItem_Generater(ld,i))
      recommandList.removeClass('big_img').addClass('follow-list')
      recommandTitle.find('.item-nav.first').find('a').html('热门潮人')

  recommandTitle.show()
  recommandList.show()

init_dashboard_data = () ->
  biglist = $('#big_img')
  smalllist = $('#small_img')
  listloading = $('#list-loading')
  pagiation = $('#item-pagiation')
  listempty = $('#list-empty')
  btn_ShowMore = $(document).find('#dashboard-show-more')
  filter = $('#list-filter')
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')

  _dashboard_start_b = 0
  _dashboard_end_b = 0
  _dashboard_start_s = 0
  _dashboard_end_s = 0
  if window.dashboard_list_data
    window.dashboard_list_data.length = 0

  window.dashboard_count = ''
  _dashboard_has_publish_btn_b = false
  _dashboard_has_publish_btn_s = false
  listloading.show()
  biglist.html('')
  biglist.hide()
  filter.hide()
  smalllist.html('')
  smalllist.hide()
  pagiation.hide()
  listempty.hide()
  recommandList.html('')
  recommandTitle.hide()
  recommandList.hide()
  btn_ShowMore.html('我要看更多').removeClass('loading')
  _dashboard_has_more = true

  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  init_dashboard_empty_message()
  query_dashboard_data()

init_dashboard_empty_message = () ->
  txtEmptytitle = $(document).find('span.empty-title')
  txtEmptycontent = $(document).find('label.empty-content')
  btnReturnhome = $(document).find('div.return_home')
  btnPublish = $(document).find('div#btnPublish')

  if _dashboard_show_me
    who = '你'
  else
    who = 'Ta'

  if state is 'fav'
    txtEmptytitle.html([who,'还没有喜欢任何单品'].join(''))
    txtEmptycontent.html('先看看其他人喜欢了什么吧!')
    btnReturnhome.show()
    btnPublish.hide()
  else if state is 'talk'
    txtEmptytitle.html([who,'还没有发布任何单品'].join(''))
    txtEmptycontent.html('赶快发布一个,让别人膜拜你的品位吧!')
    if _dashboard_show_me
      btnReturnhome.hide()
      btnPublish.show()
    else
      btnReturnhome.show()
      btnPublish.hide()
  else
    txtEmptytitle.html([who,'还没有关注任何人'].join(''))
    txtEmptycontent.html('不如从下面这堆潮流达人开始吧!')
    btnReturnhome.show()
    btnPublish.hide()

  if parseInt(window.user_photos_count) is 0 and parseInt(window.user_mail_status) is 0 and window.user_mobile is ''
    _user_mail_vrification = false

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
  smalllist = $('#big_img')
  my_icon = me.find('.icon')
  my_count = me.find('.like_count')
  harting = me.find('.harting')
  harting_img_url = SITE_URL + window.image_path + 'icon-heart-ing.gif'
  if ed is 1
    harting.attr('src',harting_img_url)
    harting.show()
    setTimeout ->
      my_icon.removeClass('icon-heart').addClass('icon-hearted')
      harting.attr('src','')
      harting.hide()
    , 1500
  else
    my_icon.removeClass('icon-hearted').addClass('icon-heart')
  my_count.html(count)
  me.attr('ed',ed)
  _dashboard_doing_like = false

refresh_like_small = (me,ed,count) ->
  my_icon = me.find('.icon')
  my_count = me.parent().parent().find('.like_count')
  harting = me.find('.harting')
  harting_img_url = SITE_URL + window.image_path + 'icon-heart-ing.gif'
  if ed is 1
    harting.attr('src',harting_img_url)
    harting.show()
    setTimeout ->
      my_icon.removeClass('icon-heart').addClass('icon-hearted')
      harting.attr('src','')
      harting.hide()
    , 1500
  else
    my_icon.removeClass('icon-hearted').addClass('icon-heart')
  my_count.html(count)
  me.attr('ed',ed)
  _dashboard_doing_like = false