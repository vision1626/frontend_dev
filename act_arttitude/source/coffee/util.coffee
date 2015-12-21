getWinWidth = ()->
  $(window).width()

getWinHeight = ()->
  $(window).height()

$.fn.verticalCenter = ()->
  h = $(this).height()
  t = (getWinHeight() - h)/2
  $(this).css('top', t)

$.fn.horizontalCenter = ()->
  w = $(this).width()
  l = (getWinWidth() - w)/2
  $(this).css('left', l)

$.fn.windowCenter = ->
  $(this).verticalCenter()
  $(this).horizontalCenter()