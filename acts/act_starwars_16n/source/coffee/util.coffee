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


validateMobile = (inputvalue)->
  pattern = /^1[35874][0-9][0-9]{8}$/;
  pattern.test(inputvalue)

# Nickname validation 只可以输入中文英文数字
validateNickname = (inputvalue,checkfirstchar)->
  if checkfirstchar
    pattern = /^[\u4E00-\u9FA5A-Za-z][\u4E00-\u9FA5A-Za-z]+$/;
  else
    pattern = /^[\u4E00-\u9FA5A-Za-z]+$/;
  pattern.test(inputvalue)
#
#copyToClipboard = (me,target) ->
#  me.zclip
#    path: '../../js/ZeroClipboard.swf'
#    copy: ->
#      target.html()
#    beforeCopy: ->
#      alert(target)
#    afterCopy: ->
#      alert('copy done')
