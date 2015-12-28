_follow_is_loading = false
_follow_limit = 24
_follow_start = 0
_follow_end = 0
_follow_step = _follow_limit
_follow_has_more = true

init_follow = ->
  followlist = $('#follow-list')
  listempty = $('#list-empty')
  listloading = $('#list-loading')
  pagiation = $('#item-pagiation')

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
    if follow_list_data.length > _follow_limit
      pagiation.show()
    else
      pagiation.hide()
  else
    listloading.hide()
    listempty.show()