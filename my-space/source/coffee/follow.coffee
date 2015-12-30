_follow_is_loading = false
_follow_limit = 14
_follow_start = 0
_follow_end = 0
_follow_step = _follow_limit
_follow_has_more = true

init_follow = ->
  followlist = $('#follow-list')
  listempty = $('#list-empty')
  listloading = $('#list-loading')
  pagiation = $('#pagiation')

  listloading.show()
  if window.follow_list_data
    if window.follow_list_data.length > _follow_limit
      _follow_end = _follow_step
    else
      _follow_end = window.follow_list_data.length
    _follow_is_loading = true
    for ld,i in window.follow_list_data
      if _follow_start < _follow_end
        followlist.append(followItem_Generater(ld,i))
        _follow_start++
    _follow_is_loading = false
    listloading.hide()
    followlist.show()
    if parseInt(window.follow_count) > _follow_limit
      pagiation.show()
      _follow_has_more = true
    else
      pagiation.hide()
      _follow_has_more = false
  else
    listloading.hide()
    listempty.show()

$(document).on 'click','div.follow_ed', ->
  do_follow(this,'ed')

$(document).on 'click','div.follow_nt', ->
  do_follow(this,'nt')

$(document).on 'click','#folloe-show-more', ->
  query_follow_Data()

$(window).bind 'scroll', (e)->
  parallax($('.profile-container'))
  e.stopPropagation()

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
    me.find('label').html('已经关注')
  else if status is 2
    me.removeClass('follow_nt').addClass('follow_ed')
    me.find('.icon').removeClass('icon-follow').addClass('icon-unfollow')
    me.find('label').html('互相关注')
  else
    me.removeClass('follow_ed').addClass('follow_nt')
    me.find('label').html('关注Ta')
    me.find('.icon').removeClass('icon-unfollow').addClass('icon-follow')

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
      data: {'m': 'u', 'a': action, ajax: 1, 'count': follow_count ,'page': page ,'limit': _follow_limit , 'hid': h_id}
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

gen_follow_Item = () ->
  _follow_is_loading = true
  followlist = $('#follow-list')
  listloading = $('#list-loading')
  listempty = $('#list-empty')
  pagiation = $('#item-pagiation')

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
  else
    pagiation.hide()
    listempty.show()

  listloading.hide()
  _follow_is_loading = false

init_follow_data = () ->
  followlist = $('#follow-list')
  listloading = $('#list-loading')
  pagiation = $('#pagiation')
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
  btn_ShowMore.html('我要看更多').removeClass('loading')

  query_follow_Data()