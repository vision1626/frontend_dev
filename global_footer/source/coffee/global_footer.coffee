init_global_footer = (friend_links)->
  footer_mag = $('.footer__mag')
  footer_mag.click ->
    window.open('http://www.1626buy.com', '_blank');

  if friend_links isnt ''
    friend_links = $.parseJSON(friend_links)
    friend_links_ele = $('.friend-links')
    friend_links_ele.append('友情链接：&nbsp;')
    for link in friend_links
      name = link.name
      url = link.url
      friend_links_ele.append("<a href='#{url}'>#{name}</a>&nbsp;&nbsp;|&nbsp;&nbsp;")
