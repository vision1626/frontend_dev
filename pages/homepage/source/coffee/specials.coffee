initSpecials = ->
  $special_items = $('section.specials').find('.specials__blocks li')
  i_w = $special_items.width()
  i_h = i_w / (280/170)
  $special_items.height i_h