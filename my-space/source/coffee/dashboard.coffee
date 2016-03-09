_dashboard_is_loading = false
_dashboard_recommand_is_loading = false
_dashboard_limit = 28
_dashboard_start_b = 0
_dashboard_end_b = 0
_dashboard_step_b = _dashboard_limit
_dashboard_start_s = 0
_dashboard_end_s = 0
_dashboard_step_s = _dashboard_limit
_dashboard_show_big = true
_dashboard_show_new_hot = 'new'
_dashboard_show_product_collocation = 1
_dashboard_has_more = true
_dashboard_has_publish_btn_b = false
_dashboard_has_publish_btn_s = false
_user_mail_vrification = true
_dashboard_show_me = false
_dashboard_doing_like = false
_dashboard_ajax_process = null
_dashboard_recommand_ajax_process = null
_dashboard_publish_first_gen_b = false
_dashboard_publish_first_gen_s = false
_dashboard_list_by_search = false
_dashboard_list_by_sort = false
_dashboard_search_keyword = ''
_is_mobile = false
_dashboard_publish_alert_showed = 0

_dashboard_data = {}
_fav_p_data = {}
_fav_c_data = {}
_publish_p_data = {}
_publish_c_data = {}
_search_data = {}

_dashboard_data_count = 0
_fav_p_data_count = 0
_fav_c_data_count = 0
_publish_p_data_count = 0
_publish_c_data_count = 0
_search_data_count = 0

_dashboard_data_more = false
_fav_p_data_more = false
_fav_c_data_more = false
_publish_p_data_more = false
_publish_c_data_more = false
_search_data_more = false

_recommand_p_data = {}
_recommand_c_data = {}
_recommand_u_data = {}

_dashboard_cache_time = null
_fav_p_cache_time = null
_fav_c_cache_time = null
_publish_p_cache_time = null
_publish_c_cache_time = null
_dashboard_recommand_p_cache_time = null
_dashboard_recommand_c_cache_time = null
_dashboard_recommand_u_cache_time = null
#缓存时间,单位:分钟
_cache_times = 2
_recommand_cache_times = 5

#SITE_URL = 'http://192.168.0.230/'

init_dashboard = ->
  filter = $('#list-filter')

  if $(window).width() <= 680
    _is_mobile = true
    $('a').attr('target','')

  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  if _dashboard_show_me and state is 'talk'
    _dashboard_publish_first_gen_b = true
    _dashboard_publish_first_gen_s = true

  if window.pre_data_string isnt ''
    if parseInt(window.pre_p_count) > 0 then _fav_p_data_count = parseInt(window.pre_p_count) else _fav_p_data_count = 0
    if parseInt(window.pre_c_count) > 0 then _fav_c_data_count = parseInt(window.pre_c_count) else _fav_c_data_count = 0
    if state is 'fav'
      if _dashboard_show_product_collocation is 2
        _fav_c_data = $.parseJSON(window.pre_data_string)
        if _fav_c_data_count > _dashboard_limit then _fav_c_data_more = true
        _fav_c_cache_time = new Date
      else
        _fav_p_data = $.parseJSON(window.pre_data_string)
        if _fav_p_data_count > _dashboard_limit then _fav_p_data_more = true
        _fav_p_cache_time = new Date
    else if state is 'talk'
      if parseInt(window.pre_p_count) > 0 then _publish_p_data_count = parseInt(window.pre_p_count) else _publish_p_data_count = 0
      if parseInt(window.pre_c_count) > 0 then _publish_c_data_count = parseInt(window.pre_c_count) else _publish_c_data_count = 0
      if _dashboard_show_product_collocation is 2
        _publish_c_data = $.parseJSON(window.pre_data_string)
        if _publish_c_data_count > _dashboard_limit then _publish_c_data_more = true
        _publish_c_cache_time = new Date
      else
        _publish_p_data = $.parseJSON(window.pre_data_string)
        if _publish_p_data_count > _dashboard_limit then _publish_p_data_more = true
        _publish_p_cache_time = new Date
    else
      if parseInt(window.pre_d_count) > 0 then _dashboard_data_count = parseInt(window.pre_d_count) else _dashboard_data_count = 0
      _dashboard_data = $.parseJSON(window.pre_data_string)
      if _dashboard_data_count > _dashboard_limit then _dashboard_data_more = true
      _dashboard_cache_time = new Date

  if !parseInt($.cookie('publistAlertShow'))
    $.cookie('publistAlertShow',0,{expires:7})

  filter.html(filter_generater())
  gen_dashboard_item()
  init_dashboard_empty_message()

$(window).bind 'scroll', (e)->
  if !_menu_showed
    parallax($('.profile-container'))
    fixMainnav()
  e.stopPropagation()
#  if ($(this).scrollTop() + $(window).height() + 200 >= $(document).height() && $(this).scrollTop() > 200)
#    gen_dashboard_item()

$(document).on 'click','.item-nav', ->
  me = $(this)
  biglist = $('#big_img')
  smalllist = $('#small_img')
  if me.hasClass('nav-type')
    if !me.hasClass('current')
      $('.nav-type').removeClass('current')
      me.addClass('current')
      _dashboard_show_product_collocation = parseInt(me.attr('t'))
#      biglist.html('')
#      smalllist.html('')
#      query_dashboard_data()
      init_dashboard_data(false)
    else
      if _dashboard_list_by_search
        init_dashboard_data(false)

$(document).on 'click','.show-new_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-hot_list').removeClass('current')
    _dashboard_show_new_hot = 'new'
    _dashboard_list_by_sort = true
    init_dashboard_data()

$(document).on 'click','.show-hot_list', ->
  if !$(this).hasClass('current')
    $(this).addClass('current')
    $('.show-new_list').removeClass('current')
    _dashboard_show_new_hot = 'hot'
    _dashboard_list_by_sort = true
    init_dashboard_data()

$(document).on 'touchend','.mobile-view-change', (e) ->
  e.preventDefault()
  me = $(this)
  if _dashboard_show_big
    me.removeClass('icon-list_view')
    me.addClass('icon-one-col ')
    _dashboard_show_big = false
    gen_dashboard_item()
    $('dl#big_img').hide()
    $('dl#small_img').show()
  else
    me.addClass('icon-list_view')
    me.removeClass('icon-one-col ')
    _dashboard_show_big = true
    gen_dashboard_item()
    $('dl#big_img').show()
    $('dl#small_img').hide()

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
  if _dashboard_has_more
    query_dashboard_data()

$(document).on 'click','.btn_like', ->
  if !_dashboard_doing_like
    _dashboard_doing_like = true
    do_like(this)

$(document).on 'click','.publish_entrance', ->
  $('.popup__blackbox').fadeIn(300)
  $('.popup').show()
  $('.popup__loading').hide()
  askUserToGetValidated()

$(document).on 'click','div.return_home', ->
  location.href = SITE_URL

$(document).on 'touchend','div.close_alert', (e) ->
  e.preventDefault()
  $.cookie('publistAlertShow',1,{expires:7})
  $('.publish_alert').fadeOut(300)

query_dashboard_data = (no_cache) ->
  btn_ShowMore = $(document).find('#dashboard-show-more')
  if _dashboard_is_loading
    _dashboard_ajax_process.abort()
  if _dashboard_recommand_is_loading
    _dashboard_recommand_ajax_process.abort()
  if !_dashboard_is_loading and _dashboard_has_more
    refresh_data = false

    if no_cache
      refresh_data = true

    if _dashboard_list_by_search
      refresh_data = true

    if _dashboard_list_by_sort
      _dashboard_list_by_sort = false
      refresh_data = true

    if state is 'fav' #喜欢
      action = 'get_fav_ajax'
      keyword = _dashboard_search_keyword
      sort = 'new'
      if _dashboard_show_product_collocation is 1
        count = _fav_p_data_count
        list_data = _fav_p_data
        if count > 0
          if !list_data
            refresh_data = true
          else
            if list_data.length > _dashboard_limit
              refresh_data = true
        if calculateTimes(_fav_p_cache_time) >= _cache_times
          refresh_data = true
      else
        count = _fav_c_data_count
        list_data = _fav_c_data
        if count > 0
          if !list_data
            refresh_data = true
          else
            if list_data.length > _dashboard_limit
              refresh_data = true
        if calculateTimes(_fav_c_cache_time) >= _cache_times
          refresh_data = true
    else if state is 'talk' #发布页
      action = 'get_publish_ajax'
      keyword = _dashboard_search_keyword
      sort = _dashboard_show_new_hot
      if _dashboard_show_product_collocation is 1
        count = _publish_p_data_count
        list_data = _publish_p_data
        if count > 0
          if !list_data
            refresh_data = true
          else
            if list_data.length > _dashboard_limit
              refresh_data = true
        if calculateTimes(_publish_p_cache_time) >= _cache_times
          refresh_data = true
      else
        count = _publish_c_data_count
        list_data = _publish_c_data
        if count > 0
          if !list_data
            refresh_data = true
          else
            if list_data.length > _dashboard_limit
              refresh_data = true
        if calculateTimes(_publish_c_cache_time) >= _cache_times
          refresh_data = true
    else #动态
      action = 'get_dashboard_ajax'
      keyword = ''
      sort = 'new'
      count = _dashboard_data_count
      list_data = _dashboard_data
      if count > 0
        if !list_data
          refresh_data = true
        else
          if list_data.length > _dashboard_limit
            refresh_data = true
      if calculateTimes(_dashboard_cache_time) >= _cache_times
        refresh_data = true

    if list_data
      if list_data isnt null
        if list_data.length > 0
          if _dashboard_end_s > _dashboard_end_b
            page = Math.round((_dashboard_end_s/_dashboard_limit))+1
          else
            page = Math.round((_dashboard_end_b/_dashboard_limit))+1
        else
          page = 1
      else
        page = 1
    else
      page = 1

    if refresh_data or page > 1
      _dashboard_is_loading = true
      btn_ShowMore.html('正在努力加载中...').addClass('loading')
      _dashboard_ajax_process = $.ajax {
        url: SITE_URL + 'services/service.php'
        type: "GET"
        data: {'m': 'u', 'a': action, ajax: 1, 'page': page, 'count': count, 'name': encodeURIComponent(keyword), 'type': _dashboard_show_product_collocation, 'sort': sort,'limit': _dashboard_limit, 'hid': window.uid}
        cache: true
        dataType: "json"
        success: (result,status,response)->
          if _dashboard_list_by_search
            _search_data_count = parseInt(result.count)
            if _search_data and _search_data.length > 0
              for d in result.data
                _search_data.push(d)
            else
              _search_data = result.data
            if result.more is 1
              _search_data_more = true
            else
              _search_data_more = false
          else
            if state is 'fav'
              _fav_c_data_count = parseInt(result.dapei_count)
              _fav_p_data_count = parseInt(result.share_count)
              if _dashboard_show_product_collocation is 2
                if _fav_c_data and _fav_c_data.length > 0 and page > 1
                  for d in result.data
                    _fav_c_data.push(d)
                else
                  _fav_c_data = result.data
                if result.more is 1
                  _fav_c_data_more = true
                else
                  _fav_c_data_more = false
                _fav_c_cache_time = new Date
              else
                if _fav_p_data and _fav_p_data.length > 0 and page > 1
                  for d in result.data
                    _fav_p_data.push(d)
                else
                  _fav_p_data = result.data
                if result.more is 1
                  _fav_p_data_more = true
                else
                  _fav_p_data_more = false
                _fav_p_cache_time = new Date
            else if state is 'talk'
              _publish_c_data_count = parseInt(result.dapei_count)
              _publish_p_data_count = parseInt(result.share_count)
              if _dashboard_show_product_collocation is 2
                if _publish_c_data and _publish_c_data.length > 0 and page > 1
                  for d in result.data
                    _publish_c_data.push(d)
                else
                  _publish_c_data = result.data
                if result.more is 1
                  _publish_c_data_more = true
                else
                  _publish_c_data_more = false
                _publish_c_cache_time = new Date
              else
                if _publish_p_data and _publish_p_data.length > 0 and page > 1
                  for d in result.data
                    _publish_p_data.push(d)
                else
                  _publish_p_data = result.data
                if result.more is 1
                  _publish_p_data_more = true
                else
                  _publish_p_data_more = false
                _publish_p_cache_time = new Date
            else
              _dashboard_data_count = parseInt(result.count)
              if _dashboard_data and _dashboard_data.length > 0 and page > 1
                for d in result.data
                  _dashboard_data.push(d)
              else
                _dashboard_data = result.data
              if result.more is 1
                _dashboard_data_more = true
              else
                _dashboard_data_more = false
              _dashboard_cache_time = new Date

          gen_dashboard_item()
          _dashboard_is_loading = false
        error: (xhr,status,error)->
          if status is 502
            alert('服务器君跑到外太空去了,刷新试试看!')
          _dashboard_is_loading = false
          btn_ShowMore.html('我要看更多').removeClass('loading')
      }
    else
      gen_dashboard_item()

query_dashboard_recommand_data = () ->
  refresh_data = false
  if state is 'fav'
    action = 'get_approve_fav_ajax'
    recommand_limit = 5
    if _dashboard_show_product_collocation is 2
      type = 2
      if _dashboard_recommand_c_cache_time is null
        refresh_data = true
      else
        if calculateTimes(_dashboard_recommand_c_cache_time) >= _recommand_cache_times
          refresh_data = true
    else
      type = 1
      if _dashboard_recommand_p_cache_time is null
        refresh_data = true
      else
        if calculateTimes(_dashboard_recommand_p_cache_time) >= _recommand_cache_times
          refresh_data = true
    data = {'m': 'u', 'a': action, ajax: 1, 'page': 1, 'count': '', 'limit': recommand_limit, 'type':type}
  else
    action = 'get_approve_user_ajax'
    recommand_limit = 7
    if _dashboard_recommand_u_cache_time is null
      refresh_data = true
    else
      if calculateTimes(_dashboard_recommand_u_cache_time) >= _recommand_cache_times
        refresh_data = true
    data = {'m': 'u', 'a': action, ajax: 1, 'page': 1, 'count': '', 'limit': recommand_limit, 'follow':0 }

  if refresh_data
    _dashboard_recommand_is_loading = true
    _dashboard_recommand_ajax_process = $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: data
      cache: true
      dataType: "json"
      success: (result)->
        if result.data
          if state is 'fav'
            if _dashboard_show_product_collocation is 2
              _recommand_c_data = result.data
              _dashboard_recommand_c_cache_time = new Date
            else
              _recommand_p_data = result.data
              _dashboard_recommand_p_cache_time = new Date
          else if state is 'dashboard'
            _recommand_u_data = result.data
            _dashboard_recommand_u_cache_time = new Date

          _dashboard_recommand_is_loading = false
          gen_dashboard_recommand_item()
      error: (xhr,status,error)->
        _dashboard_recommand_is_loading = false
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
    }
  else
    gen_dashboard_recommand_item()

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
  nav_d_count = filter.find('.nav-dashboard').find('span')
  nav_p_count = filter.find('.nav-produce').find('span')
  nav_c_count = filter.find('.nav-collocation').find('span')
  rocket = $('.scroll-to-top')
  mobile_vc = $('.mobile-view-change')
  publish_alert = $('.publish_alert')
  btn_ShowMore = $(document).find('#dashboard-show-more')

  step = 0
  if _dashboard_list_by_search
    list_count = _search_data_count
    list_data = _search_data

    if _dashboard_search_keyword isnt ''
      $('.list-search-dashboard').val(_dashboard_search_keyword)
      $('.clear-dashboard-search').addClass('show')

    if list_count > 0
      setTimeout ->
        show_search_result(_dashboard_search_keyword,list_count)
      , 300
  else
    hide_search_result()
    if state is 'fav'
      if _dashboard_show_product_collocation is 2
        list_count = _fav_c_data_count
        list_data = _fav_c_data
        list_data_more = _fav_c_data_more
      else
        list_count = _fav_p_data_count
        list_data = _fav_p_data
        list_data_more = _fav_p_data_more

    else if state is 'talk'
      if _dashboard_show_product_collocation is 2
        list_count = _publish_c_data_count
        list_data = _publish_c_data
        list_data_more = _publish_c_data_more
      else
        list_count = _publish_p_data_count
        list_data = _publish_p_data
        list_data_more = _publish_p_data_more
    else
      list_count = _dashboard_data_count
      list_data = _dashboard_data
      list_data_more = _dashboard_data_more

  if state is 'fav'
    nav_c_count.html(_fav_c_data_count)
    nav_p_count.html(_fav_p_data_count)
  else if state is 'talk'
    nav_c_count.html(_publish_c_data_count)
    nav_p_count.html(_publish_p_data_count)
  else
    nav_d_count.html(_dashboard_data_count)

  if _is_mobile and state is 'talk' and _dashboard_show_me and parseInt($.cookie('publistAlertShow')) is 0
    publish_alert.fadeIn(300)

  $('.main-nav').find('.icon-grid_view').show().css('display','')

  if list_data
    if list_data.length > 0
      if _dashboard_show_big
        step = _dashboard_step_b
        if state is 'talk' and _dashboard_show_me and !_is_mobile
          if !_dashboard_has_publish_btn_b
            biglist.append(publishItem_Generater(myid))
            _dashboard_has_publish_btn_b = true
          if _dashboard_publish_first_gen_b
            step -= 1
            _dashboard_publish_first_gen_b = false
        if _dashboard_end_b < list_data.length
          if _dashboard_end_b is 0
            _dashboard_end_b = list_data.length
          else
            _dashboard_end_b += step
          for ld,i in list_data
            if _dashboard_start_b < _dashboard_end_b and i >= _dashboard_start_b
              biglist.append(big_DashboardItem_Generater(ld,i))
              _dashboard_start_b++
        biglist.show()
      else
        step = _dashboard_step_s
        if state is 'talk' and _dashboard_show_me and !_is_mobile
          if !_dashboard_has_publish_btn_s
            smalllist.append(publishItem_Generater(myid))
            _dashboard_has_publish_btn_s = true
          if _dashboard_publish_first_gen_s
            step -= 1
            _dashboard_publish_first_gen_s = false
        if _dashboard_end_s < list_data.length
          if _dashboard_end_s is 0
            _dashboard_end_s = list_data.length
          else
            _dashboard_end_s += step
          for ld,j in list_data
            if _dashboard_start_s < _dashboard_end_s and j >= _dashboard_start_s
              smalllist.append(small_DashboardItem_Generater(ld,j))
              _dashboard_start_s++
        smalllist.show()
      if list_count > _dashboard_limit
        pagiation.show()
      else
        pagiation.hide()

      listempty.hide()
      rocket.show()
      mobile_vc.show()
      recommandTitle.hide()
      recommandList.hide()

      if list_data_more
        btn_ShowMore.html('我要看更多').removeClass('loading')
        _dashboard_has_more = true
      else
        btn_ShowMore.html('已经全部看完了').removeClass('loading')
        _dashboard_has_more = false

    else
      pagiation.hide()
      listempty.show()
      rocket.hide()
      mobile_vc.hide()
      if _dashboard_show_me and !_dashboard_list_by_search
        if state is 'fav' or state is 'dashboard'
          query_dashboard_recommand_data()
  else
    pagiation.hide()
    listempty.show()
    rocket.hide()
    mobile_vc.hide()
    if _dashboard_show_me and !_dashboard_list_by_search
      if state is 'fav' or state is 'dashboard'
        query_dashboard_recommand_data()
  if _dashboard_show_me
    publish = init_form_publish()
    publish.clean()
    publish.ajaxEditAndDelete()
    publish.formEventsBinding()
  listloading.hide()
  filter.show()
  _dashboard_is_loading = false

gen_dashboard_recommand_item = () ->
  if state is 'fav'
    if _dashboard_show_product_collocation is 2
      data = _recommand_c_data
    else
      data = _recommand_p_data
  else if state is 'dashboard'
    data = _recommand_u_data

  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  if state is 'fav'
    for ld,i in data
      recommandList.append(big_DashboardItem_Generater(ld,i))
      recommandList.removeClass('follow-list').addClass('big_img')
    if _dashboard_show_product_collocation is 2
      recommandTitle.find('.item-nav.first').find('a').html('热门搭配')
    else
      recommandTitle.find('.item-nav.first').find('a').html('热门单品')
  else if state is 'dashboard'
    for ld,i in data
      recommandList.append(followItem_Generater(ld,i))
      recommandList.removeClass('big_img').addClass('follow-list')
      recommandTitle.find('.item-nav.first').find('a').html('热门潮人')

  recommandTitle.show()
  recommandList.show()

init_dashboard_data = (soft,no_cache) ->
  _dashboard_is_loading = false
  biglist = $('#big_img')
  smalllist = $('#small_img')
  listloading = $('#list-loading')
  pagiation = $('#item-pagiation')
  listempty = $('#list-empty')
  btn_ShowMore = $(document).find('#dashboard-show-more')
  filter = $('#list-filter')
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  rocket = $('.scroll-to-top')
  mobile_vc = $('.mobile-view-change')
  publish_alert = $('.publish_alert')

  _dashboard_start_b = 0
  _dashboard_end_b = 0
  _dashboard_start_s = 0
  _dashboard_end_s = 0

  _dashboard_has_publish_btn_b = false
  _dashboard_has_publish_btn_s = false
  _dashboard_publish_first_gen_b = false
  _dashboard_publish_first_gen_s = false
  listloading.show()
  biglist.html('')
  biglist.hide()
  filter.hide()
  smalllist.html('')
  smalllist.hide()
  pagiation.hide()
  listempty.hide()
  rocket.show()
  mobile_vc.show()
  recommandList.html('')
  recommandTitle.hide()
  recommandList.hide()
  btn_ShowMore.html('我要看更多').removeClass('loading')
  publish_alert.hide()
  _dashboard_has_more = true
  _search_data = {}
  if soft

  else
    _dashboard_search_keyword = ''
    _dashboard_list_by_search = false
#    _dashboard_show_product_collocation = 1

  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  filter.html(filter_generater())

  query_dashboard_data(no_cache)
  init_dashboard_empty_message()

init_dashboard_empty_message = () ->
  txtEmptytitle = $(document).find('span.empty-title')
  txtEmptycontent = $(document).find('label.empty-content')
  btnReturnhome = $(document).find('div.return_home')
  btnClearsearch = $(document).find('div.clear_search')
  btnPublish = $(document).find('div#btnPublish')
  totalFollow = parseInt(window.user_follow_count)

  if _dashboard_show_me
    who = '你'
    if state is 'fav'
#      content_text = '先看看其他人喜欢了什么吧!'
      content_text = '你可以先去别的地方逛逛！'
    else if state is 'talk'
      content_text = '赶快发布一个,让别人膜拜你的品位吧!'
    else
      if parseInt(window.user_follow_count) > 0
#        content_text = '关注以下地球人，看看他们的动态吧！'
        content_text = '你可以先去别的地方逛逛！'
      else
#        content_text = '不如从下面这堆潮流达人开始吧!'
        content_text = '你可以先去别的地方逛逛！'
  else
    who = 'Ta'
    content_text = '你可以先去别的地方逛逛！'

  if _dashboard_show_product_collocation is 1
    type = '潮品'
  else
    type = '搭配'

  if _dashboard_list_by_search
    txtEmptytitle.html(['没有找到 ',_dashboard_search_keyword,' 相关',type].join(''))
    txtEmptycontent.html(content_text)
    btnReturnhome.hide()
    btnPublish.hide()
    btnClearsearch.show()
  else
    if state is 'fav'
      txtEmptytitle.html([who,'还没有喜欢任何',type].join(''))
      txtEmptycontent.html(content_text)
      btnReturnhome.show()
      btnPublish.hide()
      btnClearsearch.hide()
    else if state is 'talk'
      txtEmptytitle.html([who,'还没有发布任何',type].join(''))
      txtEmptycontent.html(content_text)
      if _dashboard_show_me
        btnReturnhome.hide()
        if _is_mobile
          btnPublish.hide()
        else
          btnPublish.show()
        if type == '搭配'
          btnPublish.off()
          btnPublish.on 'click', ->
            window.location.href = 'http://www.1626.com/dapei/c1.html'
        btnClearsearch.hide()
      else
        btnReturnhome.show()
        btnPublish.hide()
        btnClearsearch.hide()
    else
      if parseInt(window.user_follow_count) > 0
        txtEmptytitle.html([who,'关注的人去外太空了'].join(''))
        txtEmptycontent.html(content_text)
      else
        txtEmptytitle.html([who,'还没有关注任何人'].join(''))
        txtEmptycontent.html(content_text)
      btnReturnhome.show()
      btnPublish.hide()
      btnClearsearch.hide()

  if parseInt(window.user_photos_count) is 0 and parseInt(window.user_mail_status) is 0 and window.user_mobile is ''
    _user_mail_vrification = false

do_like = (obj) ->
  me = $(obj)
  sid = me.attr('sid')
  dtype = me.attr('dtype')
  ed = me.attr('ed')
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
      after_like(me,dtype,result,job)
    error: (xhr,status,error)->
      _dashboard_doing_like = false
      if status isnt 0
        alert('服务器君跑到外太空去了,刷新试试看!')
      else
        alert(error)

  }

after_like = (me,dtype,result,job) ->
  if result.status isnt 3
    if dtype is 'd'
      if result.status is 1
        ed = 1
        count = 1
      else
        ed = 0
        count = -1
    else if dtype is 's'
      if job is 1
        if result.status is 1
          ed = 1
          count = 1
      else if job is 2
        if result.status is 1
          ed = 0
          count = -1
    refresh_like(me.attr('sid'),ed,count)
  else
    alert('不可以喜欢自己发布的单品哦!')
    _dashboard_doing_like = false

refresh_like = (sid,ed,count) ->
  top_count = $('.content__actions').find('.actions-fav b')
  harting_img_url = SITE_URL + window.image_path + 'icon-heart-ing.gif'
  lm = false

  if state is 'fav'
    if _dashboard_show_product_collocation is 2
      if _fav_c_data_count > 0
        lm = true
    else
      if _fav_p_data_count > 0
        lm = true
  else if state is 'talk'
    if _dashboard_show_product_collocation is 2
      if _publish_c_data_count > 0
        lm = true
    else
      if _publish_p_data_count > 0
        lm = true
  else
    if _dashboard_data_count > 0
      lm = true

  if _fav_c_data_count > 0
    fav_c_foundcount = 0
    for ld in _fav_c_data
      if parseInt(ld.share_id) is parseInt(sid)
        ld.is_fav = ed
        ld.like_count += count
        fav_c_foundcount += 1
    if fav_c_foundcount is 0 or _fav_c_data is null then _fav_c_cache_time = null
  else
    if count > 0 then _fav_c_cache_time = null

  if _fav_p_data_count > 0
    fav_p_foundcount = 0
    for ld in _fav_p_data
      if parseInt(ld.share_id) is parseInt(sid)
        ld.is_fav = ed
        ld.like_count += count
        fav_p_foundcount += 1
    if fav_p_foundcount is 0 or _fav_p_data is null then _fav_p_cache_time = null
  else
    if count > 0 then _fav_p_cache_time = null

  if _publish_c_data_count > 0
    for ld in _publish_c_data
      if parseInt(ld.share_id) is parseInt(sid)
        ld.is_fav = ed
        ld.like_count += count

  if _publish_p_data_count > 0
    for ld in _publish_p_data
      if parseInt(ld.share_id) is parseInt(sid)
        ld.is_fav = ed
        ld.like_count += count

  if _dashboard_data_count > 0
    for ld in _dashboard_data
      if parseInt(ld.share_id) is parseInt(sid)
        ld.is_fav = ed
        ld.like_count += count

  if _dashboard_list_by_search
    if _search_data_count > 0
      lm = true
      for ld in _search_data
        if parseInt(ld.share_id) is parseInt(sid)
          ld.is_fav = ed
          ld.like_count += count

  if lm
    big_list = $('#big_img')
    small_list = $('#small_img')

    big_button = big_list.find('div.btn_like[sid=' + sid + ']')
    small_button = small_list.find('div.btn_like[sid=' + sid + ']')

    big_icon = big_button.find('.icon')
    small_icon = small_button.find('.icon')

    big_count = big_button.find('.like_count')
    small_count = small_button.parent().parent().find('.like_count')

    big_harting = big_button.find('.harting')
    small_harting = small_button.find('.harting')

    big_count.html(parseInt(big_count.html()) + count)
    small_count.html(parseInt(small_count.html()) + count)

    big_button.attr('ed',ed)
    small_button.attr('ed',ed)
  else
    recommand = $('#recommand')
    big_button = recommand.find('div.btn_like[sid=' + sid + ']')
    big_icon = big_button.find('.icon')
    big_count = big_button.find('.like_count')
    big_harting = big_button.find('.harting')
    big_count.html(parseInt(big_count.html()) + count)
    big_button.attr('ed',ed)

  if _dashboard_show_me
    top_count.html(parseInt(top_count.html()) + count)
  if ed is 1
    if _is_mobile
      timer = 10
    else
      timer = 1500

    if lm
      if _dashboard_show_big
        big_harting.attr('src',harting_img_url)
        big_harting.show()
      else
        if !_is_mobile
          small_harting.attr('src',harting_img_url)
          small_harting.show()

      setTimeout ->
        big_harting.attr('src','')
        big_harting.hide()
        small_harting.attr('src','')
        small_harting.hide()
        big_icon.removeClass('icon-heart').addClass('icon-hearted')
        small_icon.removeClass('icon-heart').addClass('icon-hearted')
        _dashboard_doing_like = false
      , timer
    else
      big_harting.attr('src',harting_img_url)
      big_harting.show()
      setTimeout ->
        big_harting.attr('src','')
        big_harting.hide()
        big_icon.removeClass('icon-heart').addClass('icon-hearted')
        _dashboard_doing_like = false
      , timer
  else
    big_icon.removeClass('icon-hearted').addClass('icon-heart')
    if lm
      small_icon.removeClass('icon-hearted').addClass('icon-heart')
    _dashboard_doing_like = false

