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
    if isAndroid(navigator.userAgent) and isQQBrowser(navigator.userAgent) 
      return
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

# Character validation for Login
validateCharacter = (inputvalue)->
  pattern =  /^1[35874][0-9][0-9]{8}$|^[\u4E00-\u9FA5A-Za-z0-9_.-]+$|^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
  pattern.test(inputvalue)

# Nickname validation 只可以输入中文英文数字
validateNickname = (inputvalue)->
  pattern = /^[\u4E00-\u9FA5A-Za-z][\u4E00-\u9FA5A-Za-z0-9]+$/;
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
    async: false
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

# 函数: 昵称是否存在
# 参数: userNickname: 用户昵称 类型:string
checkNickname = (userNickname,callBack) ->
  $.ajax {
    url: SITE_URL + "services/service.php"
    type: "GET"
    data: {m: 'user', a: 'check_nickname_exist', ajax: 1, nick_name: userNickname}
    cache: false
    async: false
    dataType: "json"
    success: (result)->
# 状态如下:
#0:非法操作
#-1:昵称含非法字符，仅支持中英文、数字
#-2:昵称长度为2-20个字符，可由中英文、数字组成
#-3:昵称已存在
#-4:修改失败
#-5:首字母不能为数字
#-6:已经修改过,不能再修改
#1:昵称可以使用
      callBack(result.status is 1)
    error: ->
      callBack(false)
  }


imagePath = '/tpl/hi1626/images/login'


#     浏览器/操作系统嗅探
isAndroid = (ua) ->
  /android/i.test(ua)

isQQBrowser = (ua) ->
  /mqq/i.test(ua)