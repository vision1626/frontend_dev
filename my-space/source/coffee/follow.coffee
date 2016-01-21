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

init_follow = ->
#  followlist = $('#follow-list')
#  listempty = $('#list-empty')
#  listloading = $('#list-loading')
#  pagiation = $('#pagiation')
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

#  listloading.show()
#  if window.follow_list_data
##    if window.follow_list_data.length > _follow_limit
##      _follow_end = _follow_step
##    else
##      _follow_end = window.follow_list_data.length
#    _follow_is_loading = true
##    for ld,i in window.follow_list_data
##      if _follow_start < _follow_end
##        followlist.append(followItem_Generater(ld,i))
##        _follow_start++
#    gen_follow_Item()
#    _follow_is_loading = false
#    listloading.hide()
#    followlist.show()
#    if parseInt(window.follow_count) > _follow_limit
#      pagiation.show()
#      _follow_has_more = true
#    else
#      pagiation.hide()
#      _follow_has_more = false
#  else
#    listloading.hide()
#    listempty.show()
#    pagiation.hide()

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

$(document).on 'blur','.list-search-follow', ->
  set_clean_follow_search($(this))
$(document).on 'keyup','.list-search-follow', ->
  set_clean_follow_search($(this))

set_clean_follow_search = (me) ->
  clear_icon = me.parent().find('i.icon-closepop')
  if me.val() isnt '' or _follow_list_by_search
    clear_icon.addClass('show')
  else
    clear_icon.removeClass('show')

$(document).on 'keypress','.list-search-follow', (e)->
  me = $(this)
  if(e.which == 13)
    if me.val() isnt ''
      _follow_search_keyword = me.val()
      _follow_list_by_search = true
      init_follow_data(true)

$(document).on 'click','#btnInitDashboardList', ->
  clean_follow_search()

$(document).on 'click','.clear-follow-search', ->
  clean_follow_search()

clean_follow_search = () ->
  search_text = $('.list-search-follow')
  if search_text isnt ''
    search_text.val('')
    _follow_search_keyword = ''
    $('.clear-follow-search').removeClass('show')
    if _follow_list_by_search
      init_follow_data()

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
      cache: false
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
          window.follow_recommand_data = result.data
        gen_follow_Item()

        _follow_is_loading = false
        if result.more is 1
          btn_ShowMore.html('我要看更多').removeClass('loading')
          _follow_has_more = true
        else
          btn_ShowMore.html('已经全部看完了').removeClass('loading')
          _follow_has_more = false
      error: (result)->
        if result.status isnt 0
          alert('服务器君跑到外太空去了,刷新试试看!')
        _follow_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
    }

query_follow_recommand_data = () ->
  gen_follow_recommand_item(window.follow_recommand_data)
#  if state is 'follow'
#    action = 'get_approve_user_ajax'
#    recommand_limit = 7
#
#  $.ajax {
#    url: SITE_URL + 'services/service.php'
#    type: "GET"
#    data: {'m': 'u', 'a': action, ajax: 1, 'page': 1, 'count': '', 'limit': recommand_limit, 'follow',0}
#    cache: false
#    dataType: "json"
#    success: (result)->
#      if result.data
#        gen_follow_recommand_item(result.data)
#    error: (result)->
#      if result.status isnt 0
#        alert('服务器君跑到外太空去了,刷新试试看!')
#  }

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

  if state is 'follow'
    if _follow_search_keyword isnt ''
      $('.list-search-follow').val(_follow_search_keyword)
      $('.clear-follow-search').addClass('show')

  if window.follow_list_data
    if window.follow_list_data.length > 0
      if _follow_end < window.follow_list_data.length
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
    else
      pagiation.hide()
      listempty.show()
      if _follow_show_me
        if state is 'follow'
          query_follow_recommand_data()
  else
    pagiation.hide()
    listempty.show()
    if _follow_show_me
      if state is 'follow'
        query_follow_recommand_data()

  listloading.hide()
  if state is 'follow'
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
    txtEmptytitle.html(['没有找到任何用户'].join(''))
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