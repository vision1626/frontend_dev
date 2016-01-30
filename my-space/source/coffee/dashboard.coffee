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
_dashboard_show_product_collocation = 1
_dashboard_has_more = true
_dashboard_has_publish_btn_b = false
_dashboard_has_publish_btn_s = false
_user_mail_vrification = true
_dashboard_show_me = false
_dashboard_doing_like = false
_dashboard_ajax_process = null
_dashboard_publish_first_gen_b = false
_dashboard_publish_first_gen_s = false
_dashboard_list_by_search = false
_dashboard_search_keyword = ''
_is_mobile = false

#SITE_URL = 'http://192.168.0.230/'

init_dashboard = ->
#  biglist = $('#big_img')
#  listempty = $('#list-empty')
#  listloading = $('#list-loading')
#  pagiation = $('#item-pagiation')
  if $(window).width() <= 680
    _is_mobile = true
    $('a').attr('target','')

  filter = $('#list-filter')

#  if window.dashboard_count is ''
#    window.dashboard_count = 0
  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  if _dashboard_show_me and state is 'talk'
    _dashboard_publish_first_gen_b = true
    _dashboard_publish_first_gen_s = true

  if window.dashboard_list_string isnt ''
    window.dashboard_list_data = $.parseJSON(window.dashboard_list_string)

  if window.product_count is ''
    window.product_count = '0'
  if window.collocation_count is ''
    window.collocation_count = '0'

  filter.html(filter_generater())
  gen_dashboard_item()
  init_dashboard_empty_message()
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
      init_dashboard_data(true)

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

$(document).on 'touchend','.mobile-view-change', (e) ->
  e.preventDefault()
  me = $(this)
  if _dashboard_show_big
    me.removeClass('icon-grid_view')
    me.addClass('icon-list_view')
    _dashboard_show_big = false
    gen_dashboard_item()
    $('dl#big_img').hide()
    $('dl#small_img').show()
  else
    me.addClass('icon-grid_view')
    me.removeClass('icon-list_view')
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
    $('.popup').show()
    $('.popup__loading').hide()
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
            page = Math.round((_dashboard_end_b/_dashboard_limit))+1
          else if _dashboard_end_s > _dashboard_end_b
            page = Math.round((_dashboard_end_s/_dashboard_limit))+1
          else
            page = Math.round((_dashboard_end_b/_dashboard_limit))+1
        else
          page = 1
      else
        page = 1
    else
      page = 1

    if state is 'fav' #喜欢
      action = 'get_fav_ajax'
      keyword = _dashboard_search_keyword
      sort = 'new'
      if _dashboard_show_product_collocation is 1
        count = window.product_count
      else
        count = window.collocation_count
    else if state is 'talk' #发布页
      action = 'get_publish_ajax'
      keyword = _dashboard_search_keyword
      sort = _dashboard_show_new_hot
      if _dashboard_show_product_collocation is 1
        count = window.product_count
      else
        count = window.collocation_count
    else #动态
      action = 'get_dashboard_ajax'
      keyword = ''
      sort = 'new'
      count = window.dashboard_count

    btn_ShowMore.html('正在努力加载中...').addClass('loading')
    _dashboard_ajax_process = $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {'m': 'u', 'a': action, ajax: 1, 'page': page, 'count': count, 'name': encodeURIComponent(keyword), 'type': _dashboard_show_product_collocation, 'sort': sort,'limit': _dashboard_limit, 'hid': window.uid}
      cache: false
      dataType: "json"
      success: (result,status,response)->
        window.dashboard_count = result.count
        window.product_count = result.share_count
        window.collocation_count = result.dapei_count
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
        if result.status isnt 0
#          $('#list-loading').html(result.responseText)
          alert('服务器君跑到外太空去了,刷新试试看!')
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
      if result.status isnt 0
        alert('服务器君跑到外太空去了,刷新试试看!')
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
  rocket = $('.scroll-to-top')
  mobile_vc = $('.mobile-view-change')

  step = 0
  if _dashboard_list_by_search
    list_count = parseInt(window.dashboard_count)
    if list_count > 0
      setTimeout ->
        show_search_result(_dashboard_search_keyword,list_count)
      , 300
  else
    hide_search_result()
    if state is 'dashboard'
      list_count = parseInt(window.dashboard_count)
    else
      if _dashboard_show_product_collocation is 1
        list_count = parseInt(window.product_count)
      else
        list_count = parseInt(window.collocation_count)

  if state is 'dashboard'
    filter.find('.nav-dashboard').find('span').html(window.dashboard_count)
  else
    filter.find('.nav-produce').find('span').html(window.product_count)
    filter.find('.nav-collocation').find('span').html(window.collocation_count)
    if _dashboard_search_keyword isnt ''
      $('.list-search-dashboard').val(_dashboard_search_keyword)
      $('.clear-dashboard-search').addClass('show')

  $('.main-nav').find('.icon-grid_view').show().css('display','')

  if window.dashboard_list_data
    if window.dashboard_list_data.length > 0
      if _dashboard_show_big
        step = _dashboard_step_b
        if state is 'talk' and _dashboard_show_me and !_is_mobile
          if !_dashboard_has_publish_btn_b
            biglist.append(publishItem_Generater(myid))
            _dashboard_has_publish_btn_b = true
          if _dashboard_publish_first_gen_b
            step -= 1
            _dashboard_publish_first_gen_b = false
        if _dashboard_end_b < window.dashboard_list_data.length
          if _dashboard_end_b is 0
            _dashboard_end_b = window.dashboard_list_data.length
          else
            _dashboard_end_b += step
          for ld,i in window.dashboard_list_data
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
        if _dashboard_end_s < window.dashboard_list_data.length
          if _dashboard_end_s is 0
            _dashboard_end_s = window.dashboard_list_data.length
          else
            _dashboard_end_s += step
          for ld,j in window.dashboard_list_data
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
    else
      pagiation.hide()
      listempty.show()
      rocket.hide()
      mobile_vc.hide()
#      filter.hide()
      if _dashboard_show_me and !_dashboard_list_by_search
        if state is 'fav' or state is 'dashboard'
          query_dashboard_recommand_data()
  else
    pagiation.hide()
    listempty.show()
    rocket.hide()
    mobile_vc.hide()
#    filter.hide()
    if _dashboard_show_me and !_dashboard_list_by_search
      if state is 'fav' or state is 'dashboard'
        query_dashboard_recommand_data()

  if _dashboard_show_me
    publish = init_form_publish()
    publish.clean()
    publish.form_publish_binding()
  listloading.hide()
  filter.show()
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

init_dashboard_data = (soft) ->
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

  _dashboard_start_b = 0
  _dashboard_end_b = 0
  _dashboard_start_s = 0
  _dashboard_end_s = 0
  if window.dashboard_list_data
    window.dashboard_list_data.length = 0

  window.dashboard_count = ''
  window.product_count = ''
  window.collocation_count = ''
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
  _dashboard_has_more = true
  if soft

  else
    _dashboard_search_keyword = ''
    _dashboard_list_by_search = false
    _dashboard_show_product_collocation = 1

  if myid is uid
    _dashboard_show_me = true
  else
    _dashboard_show_me = false

  filter.html(filter_generater())
  query_dashboard_data()
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
      content_text = '先看看其他人喜欢了什么吧!'
    else if state is 'talk'
      content_text = '赶快发布一个,让别人膜拜你的品位吧!'
    else
      if parseInt(window.user_follow_count) > 0
        content_text = '关注以下地球人，看看他们的动态吧！'
      else
        content_text = '不如从下面这堆潮流达人开始吧!'
  else
    who = 'Ta'

  if _dashboard_show_product_collocation is 1
    type = '单品'
  else
    type = '搭配'
#    if state is 'fav'
#      content_text = ''
#    else if state is 'talk'
#      content_text = ''
#    else
  content_text = '你可以先去别的地方逛逛！'

  if _dashboard_list_by_search
#    txtEmptytitle.html(['没有找到任何',type].join(''))
#    txtEmptytitle.html(['找到0个 ',_dashboard_search_keyword,' 相关',type].join(''))
    txtEmptytitle.html(['没有找到 ',_dashboard_search_keyword,' 相关',type].join(''))
    txtEmptycontent.html(content_text)
    btnReturnhome.hide()
    btnPublish.hide()
    btnClearsearch.show()
#找到0个 秋冬 相关单品
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
        btnPublish.show()
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
    error: (result)->
      _dashboard_doing_like = false
      if result.status isnt 0
        alert('服务器君跑到外太空去了,刷新试试看!')

  }

after_like = (me,dtype,result,job) ->
  count = 0
  ed = 0
  my_id = me.attr('sid')
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
    refresh_like(my_id,ed,count)
  else
    alert('自恋是不对滴,不可以哟! 凸（≧∇≦）凸')
    _dashboard_doing_like = false

refresh_like = (sid,ed,count) ->
  for ld in window.dashboard_list_data
    if parseInt(ld.did) is parseInt(sid)
      ld.is_fav = ed
      ld.like_count += count

  top_count = $('.content__actions').find('.actions-fav b')
  harting_img_url = SITE_URL + window.image_path + 'icon-heart-ing.gif'

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

  if _dashboard_show_me
    top_count.html(parseInt(top_count.html()) + count)
  if ed is 1
    if _is_mobile
      timer = 10
    else
      timer = 1500

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
    big_icon.removeClass('icon-hearted').addClass('icon-heart')
    small_icon.removeClass('icon-hearted').addClass('icon-heart')
    _dashboard_doing_like = false

