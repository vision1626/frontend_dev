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
    if (!validateCaptcha(String.fromCharCode(event.which)) &&
        (event.which < 96 || event.which > 105) && (event.which < 8 || event.which >64))
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

# 函数: 验证电话号码或邮箱是否合法(已注册否)
# 参数: userInfo: 手机或email 类型:string
#      callBack: 回调函数 阐述: ajax返回值 类型:boolean
checkAccount = (userInfo,callBack) ->
  if userInfo.indexOf('@')>0
    email = userInfo
    mobile = ''
  else
    email = ''
    mobile =  userInfo

  $.ajax {
    url: SITE_URL + "services/service.php"
    type: "GET"
    data: {m: 'user', a: 'check_account_exist', ajax: 1, mobile: mobile, email: email,  type: 'reg'}
    cache: false
    dataType: "json"
    success: (result)->
      # 状态如下:
      # 0:无效参数(手机、邮箱都不填),
      # -1:非法操作(手机、邮箱都填了),
      # -2:无效的手机号码,
      # -3:无效的电子邮箱,
      # -4:无此注册用户,
      # 1:账号已存在
      # 返回1则为true,即为已注册
      callBack(result.status is 1)
    error: ->
      callBack(false)
  }



imagePath = '/tpl/hi1626/images/login'