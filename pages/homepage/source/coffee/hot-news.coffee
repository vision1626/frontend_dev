initHotNews = ->
  $hot_news = $('#homepage-wrap').find('section.hot-news')
  $items = $hot_news.find('ul.news-blocks li')

  showAndHideLastNews = ->
    winW = $(window).width()
    if winW > 1329 and winW < 1610
      $items.last().hide()
    else
      $items.last().show()

  showAndHideLastNews()

  $(window).on 'resize', ->
    showAndHideLastNews()

