init = ->
  _outside.fadeIn(1000)
#  _entrance.show()

$(document).on 'click','#present', ->
  _outside.hide()
  _entrance.show()

$(document).on 'click','#start', ->
  _entrance.hide()
  _start.show()