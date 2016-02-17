_footer_qrchde_showout = false
#缓存时间,单位:分钟
_adv_cache_days = 1

init_global_footer = (friend_links)->
  footer_mag = $('.global-footer').find('.footer__mag')
  footer_mag.click ->
    mag_buy_link = footer_mag.attr 'data-link'
    if mag_buy_link isnt ''
      window.open(mag_buy_link, '_blank');

  if friend_links isnt ''
    friend_links = $.parseJSON(friend_links)
    friend_links_ele = $('.friend-links')
    friend_links_ele.append('友情链接：&nbsp;')
    for link in friend_links
      name = link.name
      url = link.url
      friend_links_ele.append("<a href='#{url}'>#{name}</a>&nbsp;&nbsp;|&nbsp;&nbsp;")

  getMagCover = ->
#    cover_src = ''
#    number = ''
#    buy_link = ''
    if !($.cookie('1626MsgAdv'))
      $.ajax({
        url: '/services/service.php?m=adv&a=get&id=30&limit=1',
        type: 'GET',
        dataType: 'json',
        data: {},
        success: (result,status,response)->
          if result.status is 1
            mag_all_data = result
            $.cookie('1626MsgAdv', response.responseText ,{expires:_adv_cache_days})
            afterGetMagCover(mag_all_data)
        error: (result)->
          alert('ft-errr: ' + result)
      })
    else
      mag_data = $.parseJSON(decodeURIComponent($.cookie('1626MsgAdv')))
      afterGetMagCover(mag_data)

  getMagCover()

afterGetMagCover = (in_data) ->
  mag_data = in_data.data.list[0]
  footer_mag = $('.global-footer').find('.footer__mag')
  cover_src = mag_data.code
  number = mag_data.title
  buy_link = mag_data.url
  $('.global-footer').find('.mag-cover img').attr 'src', cover_src
  $('.global-footer').find('.mag-buy strong').text number
  footer_mag.attr 'data-link', buy_link

$(document).on 'touchend','.qrcode_wechat', (e) ->
  e.preventDefault()
  $('.wechat_qrcode').show()

$(document).on 'touchend','.wechat_qrcode', (e) ->
  e.preventDefault()
  me = $(this)
  me.hide()