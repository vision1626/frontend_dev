_follow_is_loading = false
_follow_limit = 14
_follow_start = 0
_follow_end = 0
_follow_step = _follow_limit
_follow_has_more = true
_follow_show_me = false
_dashboard_doing_follow = false
_follow_ajax_process = null
_follow_list_by_search = false
_follow_search_keyword = ''

_follow_data = {}
_fans_data = {}
_follow_recommand_data = {}

_follow_data_count = 0
_fans_data_count = 0

_follow_data_more = false
_fans_data_more = false

_follow_cache_time = null
_fans_cache_time = null
_follow_recommand_cache_time = null

init_follow = ->
  if $(window).width() <= 680
    _is_mobile = true
    $('a').attr('target','')

  filter = $('#list-filter')

  if myid is uid
    _follow_show_me = true
  else
    _follow_show_me = false

  if window.follow_list_string isnt ''
    window.follow_list_data = $.parseJSON(window.follow_list_string)

  if window.follow_recommand_string isnt ''
    window.follow_recommand_data = $.parseJSON(window.follow_recommand_string)

  init_follow_empty_message()
  if state is 'follow'
    filter.html(filter_generater())
  else
    filter.hide()
  gen_follow_Item()

$(document).on 'click','#folloe-show-more', ->
  query_follow_Data()

$(document).on 'click','div.return_home', ->
  location.href = SITE_URL

$(window).bind 'scroll', (e)->
  parallax($('.profile-container'))
  e.stopPropagation()

$(document).on 'click','.fans-concemed_fans', ->
  uid = $(this).attr('uid')
  url = ['u/fans-',uid,'.html'].join('')
  window.open(SITE_URL + url)

$(document).on 'click','.fans-concemed_follow', ->
  uid = $(this).attr('uid')
  url = ['u/follow-',uid,'.html'].join('')
  window.open(SITE_URL + url)

query_follow_Data = () ->
  btn_ShowMore = $(document).find('#folloe-show-more')

  if !_follow_is_loading and _follow_has_more

    _follow_is_loading = true

    if window.follow_list_data
      if window.follow_list_data isnt null
        if window.follow_list_data.length > 0
          page = (_follow_end/_follow_limit)+1
        else
          page = 1
      else
        page = 1
    else
      page = 1

    if window.location.pathname.indexOf('fans') > 0
      action = 'get_fans_ajax'
      keyword = ''
    else
      action = 'get_follow_ajax'
      keyword = _follow_search_keyword

    url = 'services/service.php'

    btn_ShowMore.html('正在努力加载中...').addClass('loading')
    method = 'GET'
    _follow_ajax_process = $.ajax {
      url: SITE_URL + url
      type: method
      data: {'m': 'u', 'a': action, ajax: 1, 'count': follow_count, 'name': encodeURIComponent(keyword) ,'page': page ,'limit': _follow_limit , 'hid': window.uid}
      cache: true
      dataType: "json"
      success: (result)->
        window.follow_count = result.count

        if result.count > 0
          if result.data
            if window.follow_list_data
              for d in result.data
                window.follow_list_data.push(d)
            else
              window.follow_list_data = result.data
        else
          if !_follow_list_by_search
            window.follow_recommand_data = result.data
        gen_follow_Item()

        _follow_is_loading = false
        if result.more is 1
          btn_ShowMore.html('我要看更多').removeClass('loading')
          _follow_has_more = true
        else
          btn_ShowMore.html('已经全部看完了').removeClass('loading')
          _follow_has_more = false
      error: (xhr,status,error)->
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
        _follow_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
    }

query_follow_recommand_data = () ->
  gen_follow_recommand_item(window.follow_recommand_data)

gen_follow_recommand_item = (data) ->
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  if state is 'follow'
    for ld,i in data
      recommandList.append(followItem_Generater(ld,i))
      recommandList.removeClass('big_img').addClass('follow-list')
      recommandTitle.find('.item-nav.first').find('a').html('热门潮人')
  recommandTitle.show()
  recommandList.show()

gen_follow_Item = () ->
  _follow_is_loading = true
  followlist = $('#follow-list')
  listloading = $('#list-loading')
  listempty = $('#list-empty')
  pagiation = $('#pagiation')
  filter = $('#list-filter')
  rocket = $('.scroll-to-top')
  mobile_vc = $('.mobile-view-change')

  if state is 'follow' and _follow_list_by_search
    if _follow_search_keyword isnt ''
      $('.list-search-follow').val(_follow_search_keyword)
      $('.clear-follow-search').addClass('show')
    if window.follow_count > 0
      show_search_result(_follow_search_keyword,window.follow_count)

  $('.main-nav').find('.icon-grid_view').hide()

  if window.follow_list_data
    if window.follow_count > 0
      if _follow_end < window.follow_count
        _follow_end += _follow_step
        for ld,i in window.follow_list_data
          if _follow_start < _follow_end and i >= _follow_start
            followlist.append(followItem_Generater(ld,i))
            _follow_start++
      followlist.show()
      if parseInt(window.follow_count) > _follow_limit
        pagiation.show()
      else
        pagiation.hide()
      listempty.hide()
      rocket.show()
    else
      pagiation.hide()
      listempty.show()
      rocket.hide()
      if _follow_show_me and !_follow_list_by_search
        if state is 'follow'
          query_follow_recommand_data()
  else
    pagiation.hide()
    listempty.show()
    rocket.hide()
    if _follow_show_me and !_follow_list_by_search
      if state is 'follow'
        query_follow_recommand_data()

  listloading.hide()
  if state is 'follow' and !_is_mobile
    filter.show()
  else
    filter.hide()
  _follow_is_loading = false

init_follow_data = (soft) ->
  _follow_is_loading = false
  followlist = $('#follow-list')
  listloading = $('#list-loading')
  pagiation = $('#pagiation')
  listempty = $('#list-empty')
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  btn_ShowMore = $(document).find('#folloe-show-more')
  filter = $('#list-filter')
  rocket = $('.scroll-to-top')

  _follow_is_loading = false
  _follow_start = 0
  _follow_end = 0
  _follow_has_more = true

  if window.follow_list_data
    window.follow_list_data.length = 0

  if soft

  else
    _follow_search_keyword = ''
    _follow_list_by_search = false

  window.follow_count = ''
  listloading.show()
  followlist.html('')
  followlist.hide()
  pagiation.hide()
  listempty.hide()
  rocket.show()
  recommandList.html('')
  recommandTitle.hide()
  recommandList.hide()
  filter.hide()
  btn_ShowMore.html('我要看更多').removeClass('loading')

  init_follow_empty_message()
  if state is 'follow'
    filter.html(filter_generater())
  else
    filter.hide()
  query_follow_Data()

init_follow_empty_message = () ->
  txtEmptytitle = $(document).find('span.empty-title')
  txtEmptycontent = $(document).find('label.empty-content')
  btnReturnhome = $(document).find('div.return_home')
  btnPublish = $(document).find('div#btnPublish')
  btnFollow = $(document).find('div#btnFollow')
  btnClearsearch = $(document).find('div.clear_search')

  if _follow_show_me
    who = '你'
    if state is 'fans'
      content_text = "发布潮品越多 粉丝越多哦！"
    else
      content_text = "关注潮人能看到他们的最新动态哦！"
  else
    who = 'Ta'
    if state is 'fans'
      content_text = "赶紧关注他，成为他的第一个粉丝吧！"
    else
      content_text = "你可以先去别的地方逛逛！"

  if _follow_list_by_search
#    txtEmptytitle.html(['没有找到任何用户'].join(''))
#    txtEmptytitle.html(['找到0个 ', _follow_search_keyword,' 相关用户'].join(''))
    txtEmptytitle.html(['没有找到 ', _follow_search_keyword,' 相关用户'].join(''))
    txtEmptycontent.html(content_text)
    btnReturnhome.hide()
    btnPublish.hide()
    btnClearsearch.show()
  else
    if state is 'fans'
      txtEmptytitle.html([who,'还没有粉丝'].join(''))
      txtEmptycontent.html(content_text)
      if _follow_show_me
        btnReturnhome.hide()
        btnPublish.show()
        btnFollow.hide()
        btnClearsearch.hide()
      else
        btnReturnhome.hide()
        btnPublish.hide()
        btnClearsearch.hide()
        btnFollow.show().attr('uid',uid)
    else
      txtEmptytitle.html([who,'还没有关注任何人'].join(''))
      txtEmptycontent.html(content_text)
      btnReturnhome.show()
      btnPublish.hide()
      btnFollow.hide()
      btnClearsearch.hide()