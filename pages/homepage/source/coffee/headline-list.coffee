initHeadlineList = ->
  $list = $('.headlines__list')
  $list_item = $list.find 'li'
  $list_item.mouseenter ->
    $list_item.removeClass 'expanded'
    $(this).addClass 'expanded'

  $(".nano").nanoScroller()