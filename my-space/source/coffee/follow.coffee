_follow_is_loading = false
_follow_limit = 6
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
  if follow_list_data
    if follow_list_data.length > _follow_limit
      _follow_end = _follow_step
    else
      _follow_end = follow_list_data.length
    _follow_is_loading = true
    for ld,i in follow_list_data
      if _follow_start < _follow_end
        followlist.append(followItem_Generater(ld,i))
        _follow_start++
    _follow_is_loading = false
    listloading.hide()
    followlist.show()
    if parseInt(follow_count) > _follow_limit
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
  if follow_list_data isnt undefined
    btn_ShowMore = $(document).find('.show-more')
    if !_follow_is_loading and _follow_has_more
      _follow_is_loading = true
      if follow_list_data.length > 0
        page = (_follow_end/_follow_limit)+1
      else
        page = 1

      url = 'services/service.php?m=u&a=get_follow_ajax'
      method = 'GET'
      $.ajax {
        url: SITE_URL + url
        type: method
        data: {'count': follow_count ,'page': page ,'limit': _follow_limit , 'hid': h_id}
        cache: false
        dataType: "json"
        success: (result)->
          for d in result.data
            follow_list_data.push(d)
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

  if _follow_end < follow_list_data.length
    _follow_end += _follow_step
    for ld,i in follow_list_data
      if _follow_start < _follow_end and i >= _follow_start
        followlist.append(followItem_Generater(ld,i))
        _follow_start++
  followlist.show()
  listloading.hide()
  _follow_is_loading = false