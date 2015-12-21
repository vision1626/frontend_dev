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

# --------------- Handlers -----------------
checkCaptcha = (event)-> 
    if (!validateCaptcha(String.fromCharCode(event.which)) && event.which != 8)
      $(this).val($(this).val().slice(0, -1))
# --------------- End of Handlers -----------------

# Captcha validation
validateCaptcha = (inputvalue)->
  pattern = /\d/
  pattern.test(inputvalue)

# Mobile validation
validateMobile = (inputvalue)->
  pattern = /^1[35874][0-9][0-9]{8}$/;
  pattern.test(inputvalue)

# Email validation
validateEmail = (inputvalue)->
  pattern = /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
  pattern.test(inputvalue)

#  Check if IE
checkIE = ->
  ua = window.navigator.userAgent;
  msie = ua.indexOf("MSIE ");
  msie > 0

imagePath = '/tpl/hi1626/images/login'