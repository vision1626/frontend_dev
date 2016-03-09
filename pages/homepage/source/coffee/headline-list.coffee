initHeadlineList = ->
  $list = $('.headlines__list')
  $list_item = $list.find 'li'
  $list_item.eq(0).addClass 'expanded'
  $list_item.mouseenter ->
    $list_item.removeClass 'expanded'
    $(this).addClass 'expanded'

  $(".nano").nanoScroller({ preventPageScrolling: true })

  $item_tag = $list_item.find 'b.tag'
  if $item_tag.text is '1626独家'
    $item_tag.addClass 'exclusive'