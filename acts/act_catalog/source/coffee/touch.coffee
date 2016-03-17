initTouch = ->
  FastClick.attach(document.body)
  $(document).on 'touchstart','.touchable', ->
    ele = $(this)
    ele.addClass 'touched'
  $(document).on 'touchend', '.touchable', ->
    ele = $(this)
    ele.removeClass 'touched'