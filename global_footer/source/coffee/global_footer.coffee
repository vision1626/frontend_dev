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
    cover_src = ''
    number = ''
    buy_link = ''
    $.ajax({
      url: '/services/service.php?m=adv&a=get&id=30&limit=1',
      type: 'post',
      dataType: 'json',
      data: {},
      success: (result)->
        if result.status is 1
          mag_data = result.data.list[0]
          cover_src = mag_data.code
          number = mag_data.title
          buy_link = mag_data.url
          $('.global-footer').find('.mag-cover img').attr 'src', cover_src
          $('.global-footer').find('.mag-buy strong').text number
          footer_mag.attr 'data-link', buy_link
      error: (result)->
        alert('errr: ' + result)
    })

  getMagCover()