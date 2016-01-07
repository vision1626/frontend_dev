_follow_is_loading = false
_follow_limit = 14
_follow_start = 0
_follow_end = 0
_follow_step = _follow_limit
_follow_has_more = true
_follow_show_me = false
_dashboard_doing_follow = false

init_follow = ->
#  followlist = $('#follow-list')
#  listempty = $('#list-empty')
#  listloading = $('#list-loading')
#  pagiation = $('#pagiation')

  if myid is uid
    _follow_show_me = true
  else
    _follow_show_me = false

  if window.follow_list_string isnt ''
    window.follow_list_data = $.parseJSON(window.follow_list_string)

  init_follow_empty_message()
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

$(document).on 'click','div.follow_ed', ->
  if !_dashboard_doing_follow
    _dashboard_doing_follow = true
    do_follow(this,'ed')

$(document).on 'click','div.follow_nt', ->
  if !_dashboard_doing_follow
    _dashboard_doing_follow = true
    do_follow(this,'nt')

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
  location.href = SITE_URL + url

$(document).on 'click','.fans-concemed_follow', ->
  uid = $(this).attr('uid')
  url = ['u/follow-',uid,'.html'].join('')
  location.href = SITE_URL + url

do_follow = (obj,status) ->
  me = $(obj)
  uid = me.attr('uid')

  url = 'services/service.php?m=user&a=follow'
  method = 'POST'
  $.ajax {
    url: SITE_URL + url
    type: method
    data: {'uid': uid}
    cache: false
    dataType: "json"
    success: (result)->
      after_follow(me,result.status)
    error: (result)->
      alert('errr: ' + result)
  }

after_follow = (me,status)->
  if status is 1
    me.removeClass('follow_nt').addClass('follow_ed')
    me.find('.icon').removeClass('icon-follow').addClass('icon-unfollow')
    me.find('label.sl1').html('已关注')
  else if status is 2
    me.removeClass('follow_nt').addClass('follow_ed')
    me.find('.icon').removeClass('icon-follow').addClass('icon-unfollow')
    me.find('label.sl1').html('互相关注')
  else
    me.removeClass('follow_ed').addClass('follow_nt')
    me.find('label.sl1').html('关注Ta')
    me.find('.icon').removeClass('icon-unfollow').addClass('icon-follow')
  _dashboard_doing_follow = false

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
    else
      action = 'get_follow_ajax'

    url = 'services/service.php'
    method = 'GET'
    $.ajax {
      url: SITE_URL + url
      type: method
      data: {'m': 'u', 'a': action, ajax: 1, 'count': follow_count ,'page': page ,'limit': _follow_limit , 'hid': window.uid}
      cache: false
      dataType: "json"
      success: (result)->
        window.follow_count = result.count

        if result.data
          if window.follow_list_data
            for d in result.data
              window.follow_list_data.push(d)
          else
            window.follow_list_data = result.data
        gen_follow_Item()

        _follow_is_loading = false
        if result.more is 1
          btn_ShowMore.html('我要看更多').removeClass('loading')
          _follow_is_loading = true
        else
          btn_ShowMore.html('已经全部看完了').removeClass('loading')
          _follow_is_loading = false
      error: (result)->
        alert('errr: ' + result)
        _follow_is_loading = false
        btn_ShowMore.html('我要看更多').removeClass('loading')
    }

query_follow_recommand_data = () ->
  if state is 'follow'
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
        gen_follow_recommand_item(result.data)
    error: (result)->
      alert('errr: ' + result)
  }

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
  _follow_is_loading = false

init_follow_data = () ->
  followlist = $('#follow-list')
  listloading = $('#list-loading')
  pagiation = $('#pagiation')
  listempty = $('#list-empty')
  recommandTitle = $('#recommandTitle')
  recommandList = $('#recommand')
  btn_ShowMore = $(document).find('#folloe-show-more')
  _follow_is_loading = false
  _follow_start = 0
  _follow_end = 0
  _follow_has_more = true

  if window.follow_list_data
    window.follow_list_data.length = 0

  window.follow_count = ''
  listloading.show()
  followlist.html('')
  followlist.hide()
  pagiation.hide()
  listempty.hide()
  recommandList.html('')
  recommandTitle.hide()
  recommandList.hide()
  btn_ShowMore.html('我要看更多').removeClass('loading')

  init_follow_empty_message()
  query_follow_Data()

init_follow_empty_message = () ->
  txtEmptytitle = $(document).find('span.empty-title')
  txtEmptycontent = $(document).find('label.empty-content')
  btnReturnhome = $(document).find('div.return_home')
  btnPublish = $(document).find('div#btnPublish')

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

  if window.location.pathname.indexOf('fans') > 0
    txtEmptytitle.html([who,'还没有粉丝'].join(''))
    txtEmptycontent.html(content_text)
    if _follow_show_me
      btnReturnhome.hide()
      btnPublish.show()
    else
      btnReturnhome.show()
      btnPublish.hide()
  else
    txtEmptytitle.html([who,'还没有关注任何人'].join(''))
    txtEmptycontent.html(content_text)
    btnReturnhome.show()
    btnPublish.hide()