# 验证中文名称
isChineseName = (name)->
  pattern = /^[\u4E00-\u9FA5]{1,6}$/
  pattern.test name

# 验证手机号
isMobile = (mobile)->
  pattern = /^1[34578]\d{9}$/
  pattern.test mobile

# 验证身份证
isCardNo = (card)->
  pattern = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/
  pattern.test card

# Email validation
isEmail = (mail)->
  pattern = /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/
  pattern.test mail

# 验证函数
#formValidate = ($name,$mobile,$mail,$pid)->
formValidate = ($name,$mobile,$mail)->
  str = ''
  # 判断名称
  name = $.trim($name.val())
  if name.length == 0
    str += '请输入姓名\n'
  else
    if !isChineseName(name)
      str += '请输入正确的姓名\n'

  # 判断手机号码
  mobile = $.trim($mobile.val())
  if mobile.length == 0
    str += '请输入手机号码\n'
  else
    if !isMobile(mobile)
      str += '请输入正确的手机号码\n'

  # 验证邮箱
  mail = $.trim($mail.val())
  if mail.length == 0
    str += '请输入邮箱\n'
  else
    if !isEmail(mail)
      str += '请输入正确的邮箱\n'

#  # 验证身份证
#  pid = $.trim($pid.val())
#  if !isCardNo(pid)
#    str += '请输入正确的身份证号码\n'

  str
