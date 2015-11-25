init = ->
  $('input[type=text],input[type=password]').focus ->
    $(this).parent().addClass 'focus'
  .blur ->
    $(this).parent().removeClass 'focus'

  #  Responsive 自適應
  resizeEle = ->
    form_w = $('.form-container').width()
    $('.switch-header').width form_w
    $('.form-header').width form_w
    $('.switch-container').width form_w * 2 + 30

  resizeEle()
  $(window).resize ->
    resizeEle()

  at_page = 0

  btn_reveal_pw = $('.icon-unseen')
  btn_reveal_pw.click ->
    ipt_pass = $(this).prev();
    if ipt_pass.attr('type') is 'password'
      ipt_pass.attr('type', 'text')
      $(this).addClass 'icon-seen'
      $(this).removeClass 'icon-unseen'
    else
      ipt_pass.attr('type', 'password')
      $(this).removeClass 'icon-seen'
      $(this).addClass 'icon-unseen'

  #  Switch login and register 註冊登錄切換
  btn_goto_login = $('.goto-login')
  btn_goto_register = $('.goto-register')
  $('#form-login').show()
  $('#form-register').hide()
  btn_goto_login.click ->
    $('.form-container').removeClass 'at-register'
    $('#form-login').show()
    $('#form-register').hide()
    $('.switch-container').css 'left', 0
    $('.form-error').hide()
    $('.input-password').val('')
    at_page = 0 # login
  btn_goto_register.click ->
    $('.form-container').addClass 'at-register'
    $('#form-register').show()
    $('#form-register').find('input#captchaInput').val('')
#    $('#form-register').find('a.captcha').renew_captcha()
    renew_captcha()
    $('#form-login').hide()
    form_w = $('.form-container').width()
    $('.switch-container').css 'left', -(form_w + 30)
    $('.form-error').hide()
    $('.input-password').val('')
    at_page = 1 # register

  #  Form input error tip 彈出錯誤提示
  showFormError = (text, x, y, pass)->
    if $(window).width() > 950
      $('.form-error').find('label').text(text)
      $('.form-error').css {'left': x + 'px', 'top': y + 'px'}
      $('.form-error').show()
    else
      $('.form-error-mob').find('label').text(text)
      $('.form-error-mob').fadeIn(200)
      setTimeout(->
        $(".form-error-mob").fadeOut(100)
      , 1000)
      
  #  Form input error tip 彈出錯誤提示
  showSmallErrorTip = (text,mood)->
    mood = mood or 0 # 1是成功的笑臉，0是失敗的哭臉
    $('.form-error-mob').find('label').html(text)
    if mood is 1
      $('.form-error-mob').find('i.icon').addClass('icon-happy')
    $('.form-error-mob').fadeIn(200)
    setTimeout(->
      $(".form-error-mob").fadeOut(100, ->
        $('.form-error-mob').find('i.icon').removeClass('icon-happy')
      )
    , 1500)

  # 適應返回鍵
#  locationHashChanged = ->
#    if location.hash is "#register"
#      btn_goto_register.click()
#    else if location.hash is "#login"
#      btn_goto_login.click()
#
#  $(window).bind 'hashchange', ->
#    locationHashChanged()

  $(window).bind 'load', ->
    if location.href.indexOf('register.html')>0
      btn_goto_register.click()
    else
      btn_goto_login.click()

#  locationHashChanged()

  # 鍵入，隱藏錯誤提示
  $('input[type=text],input[type=password]').on 'propertychange input', ->
    $('.form-error').fadeOut(300)

  # 更新電腦驗證碼
  renew_captcha = ->
    $('.input-row.captcha .captcha').css("background-image",
      'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')');
    $('.input-row.captcha input').val('');
  renew_captcha()



  # Click and change captcha image 點擊驗證碼刷新
  $("a.captcha").click ->
    renew_captcha()

  # -------------------------- 用户条款弹窗 - START -------------------------

  popup = $('.popup-wrap')
  popup_content = popup.find '.popup-content'

  changePopupPosForIE = ->
    popup_content_w = popup_content.width() + 96
    popup_content.css 'left': ($(window).width() - popup_content_w) / 2, 'top': 200

  # 触发弹窗
  $('a.show-terms').click ->
    if $(window).width() > 950
      url = $(this).attr 'data-href'
      window.open(url, '_blank')
    else
      popup_content.find('article').html(USERTERMS) #Separate JS @ /www.hi1626.com/public/js/user-terms.js
      popup.fadeIn(100)
      if checkIE()
        changePopupPosForIE()

  # 關閉彈窗
  $('.close-popup').click ->
    popup.fadeOut(100)

  # -------------------------- 用户条款弹窗 - END -------------------------

  # -------------------------- 登錄 - START -------------------------

  log_input_phone = $('#form-login input.input-phone')
  log_input_pass = $('#form-login input.input-password')
  form_login = $('#form-login')
  btn_login_submit = form_login.find 'button#submitLogin'

  # 函數：激活/禁止提交按鈕
  disableBtnLogSubmit = ->
    btn_login_submit.addClass('disabled').removeClass('always-blue')
  enableBtnLogSubmit = ->
    btn_login_submit.removeClass('disabled').addClass('always-blue')

  # 函數：提交登錄
  submitLogin = (phone,pass)->
    $('.hand-loading').show()
    query = new Object()
    query.account = phone
    query.password = pass
    query.remember = $('#remember').is(':checked') ? 1: 0
    query.rhash = $.trim($("input[name=rhash]").val());
    $.ajax {
      url: form_login.attr('data-action'),
      type: "POST",
      data: query,
      cache: false,
      dataType: "json",
      success: (result)->
        if result.status is 1
          window.location.href = result.success_url
          false
        else if result.status is 2
          $('.hand-loading').fadeOut(200)
          showSmallErrorTip("账户已被冻结<br/>如有疑问请发邮件至1626@1626.com")
        else
          $('.hand-loading').fadeOut(200)
          showSmallErrorTip('账户或密码错误')
      error: ->
        showSmallErrorTip('操作失败，请稍后重新尝试')
        $('.hand-loading').fadeOut(200)
    }

  # 函數：檢查錄入
  validateLoginForm = (submit_pressed)->
    user_phone = $.trim(log_input_phone.val())
    user_pass = $.trim(log_input_pass.val())
    if user_phone is ''
      if submit_pressed then showFormError('请输入用户名/邮箱/手机号', 310, 45) else disableBtnLogSubmit()
    else if !validateCharacter(user_phone)
      showFormError('用户名/邮箱/手机号有误', 310, 45)
      if !submit_pressed then disableBtnLogSubmit()
    else if user_pass is ''
      if submit_pressed then showFormError('请输入密码', 310, 100) else disableBtnLogSubmit()
    else
      if !submit_pressed then enableBtnLogSubmit() else submitLogin(user_phone,user_pass)

  # 動態檢查錄入
  log_input_phone.blur ->
    validateLoginForm(false)
  log_input_phone.on 'propertychange input', ->
    acc = $(this).val()
    if validateMobile(acc) || validateEmail(acc)
      validateLoginForm(false)
  log_input_pass.blur ->
    validateLoginForm(false)
  log_input_pass.on 'propertychange input', ->
    validateLoginForm(false)

  # 點擊提交登錄按鈕
  btn_login_submit.click ->
    validateLoginForm(true)

  # -------------------------- 登錄 - END -------------------------


  # -------------------------- 註冊 - START -------------------------

  form_register = $('#form-register')
  reg_input_phone = form_register.find('input.input-phone')
  reg_input_pass = form_register.find('input.input-password')
  reg_input_captcha = form_register.find('input#captchaInput')
  reg_input_agree = form_register.find('#agreed')
  reg_input_code_row = form_register.find('li#code_input')
  reg_input_code = form_register.find('#mobCodeInput')
  reg_resend_code = form_register.find('#resend_code')
  btn_reg_info_submit = form_register.find('button#submitInfo')
  configMap = {
    isAccountExisted: false
  }

  # DOM method
  isPhoneExist = (exisied)->
    if exisied
      showFormError('手机号已被注册', 310, 45)
      configMap.isAccountExisted = true
    else
      configMap.isAccountExisted = false
  isEmailExist = (exisied)->
    if exisied
      showFormError('邮箱已被注册', 310, 45)
      configMap.isAccountExisted = true
    else
      configMap.isAccountExisted = false
      
  # EventListener
  reg_input_captcha.on('input keyup', checkCaptcha)
#  reg_input_phone.blur ->
  # reg_input_phone.keyup ->
  #   user_phone = $.trim(reg_input_phone.val())
  #   if validateMobile(user_phone)
  #     checkAccount(user_phone, isPhoneExist)
  #   else
  #     reg_input_code_row.hide()
  #     reg_resend_code.hide()
  #     checkAccount(user_phone, isEmailExist)

  # 函數：激活/禁止提交按鈕
  disableBtnInfoSubmit = ->
    btn_reg_info_submit.addClass('disabled').removeClass('always-blue')
  enableBtnInfoSubmit = ->
    btn_reg_info_submit.removeClass('disabled').addClass('always-blue')

  # 函數：发送手机验证码60秒倒计时
  send_code_count_down = (sec)->
    sec = sec || 60
    sec--
    if sec > 0
      reg_resend_code.html(sec + '秒后重新发送验证码').show()
      setTimeout(->
        send_code_count_down(sec)
      , 1000)
    else
      reg_resend_code.html("<a class='text click-to-resend'>重新发送</a>验证码")

  # 函數：提交手机和电脑验证码获取短信验证码
  submitRegInfo = (phone, captcha)->

    $('.hand-loading').show()
    $.ajax {
      url: SITE_URL + "services/service.php"
      type: "GET"
      data: {m: 'user', a: 'get_mobile_verify', ajax: 1, mobile: phone, code: captcha, type: 'reg'}
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').hide()
        switch parseInt(result.status)
          when 1 # 短信验证码已经发送
            showSmallErrorTip('已发送验证码到你的手机',1)
            reg_input_code_row.show()
            btn_reg_info_submit.html('请输入手机验证码').removeClass('send-code').addClass('code-sent').html('提交注册')
            disableBtnInfoSubmit()
            send_code_count_down()
          when -2 # 短信验证码发送失败
            showSmallErrorTip '短信验证码发送失败'
          else
            if result.msg != ''
              showSmallErrorTip result.msg
              renew_captcha()
      error: ->
        $('.hand-loading').hide()
        showSmallErrorTip '系统异常，请稍后重试'
    }


  # 函數: 提交註冊
  submitRegister = (user_phone, user_pass, v_code, m_code)->
    $('.hand-loading').show()
    query = new Object()
    query.account = user_phone
    query.password = user_pass
    query.code = v_code
    query.rcode = m_code or ''
    query.rhash = $("input[name=rhash]").val()
    $.ajax {
      url: SITE_URL + "user/ajax_register.html"
      type: "POST"
      data: query
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').fadeOut(200)
        if result.status > 0
          showSmallErrorTip('注册成功！<br/>即将跳转到首页',1)
          setTimeout(->
            window.location.href = SITE_URL
          , 2000)
        else
          if result.msg is ''
            showSmallErrorTip '系统异常，请稍后重试'
          else
            showSmallErrorTip result.msg

      error: ->
        $('.hand-loading').fadeOut(200)
        if result.msg is ''
          showSmallErrorTip '系统异常，请稍后重试'
        else
          showSmallErrorTip result.msg
    }

  # 函數：檢查錄入
  validateRegisterForm = (submit_pressed)->
    user_phone = $.trim(reg_input_phone.val())
    user_pass = $.trim(reg_input_pass.val())
    captcha = $.trim(reg_input_captcha.val())
    user_code = $.trim(reg_input_code.val())

    if !submit_pressed
      disableBtnInfoSubmit()
#      if !validateEmail(user_phone) && !validateMobile(user_phone)
      if !validateMobile(user_phone)
        showFormError('邮箱/手机号有误', 310, 45)
      else if configMap.isAccountExisted
        showFormError('此账号已被注册', 310, 45)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if user_phone isnt '' and user_pass isnt '' and captcha isnt '' and captcha.length is 5 and reg_input_agree.is(':checked')
#        if btn_reg_info_submit.hasClass('send-code')
#          enableBtnInfoSubmit()
#        else if btn_reg_info_submit.hasClass('code-sent') and user_code isnt '' and user_code.length is 5
        enableBtnInfoSubmit()
        if validateMobile(user_phone)
          btn_reg_info_submit.html('发送验证码到 ' + user_phone).addClass('send-code')
        else
          btn_reg_info_submit.html('提交注册')
#        else
#          enableBtnInfoSubmit()

    else
      if user_phone is ''
        showFormError('请输入用户名/邮箱/手机号', 310, 45)
      else if !validateEmail(user_phone) && !validateMobile(user_phone)
        showFormError('邮箱/手机号有误', 310, 45)
      else if user_pass is ''
        showFormError('请输入密码', 310, 100)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if captcha is '' or captcha.length isnt 5
        showFormError('验证码输入有误', 310, 150)
      else if !reg_input_agree.is(':checked')
        showFormError('请同意条款', 310, 203)
      else if btn_reg_info_submit.hasClass('send-code')
        submitRegInfo(user_phone,captcha)
      else if btn_reg_info_submit.hasClass('code-sent')
        submitRegister(user_phone,user_pass,'',user_code)
      else
        submitRegister(user_phone,user_pass,captcha)

  # 檢查輸入是否有效，彈出驗證碼
  $('#submitInfo').click ->
    validateRegisterForm(true)

  # 重新發送驗證碼
  $(document).on 'click', 'a.click-to-resend', ->
    disableBtnInfoSubmit()
    reg_input_code.val ''
    btn_reg_info_submit.removeClass 'code-sent'
    validateRegisterForm(true)


  # 動態檢查錄入
  # reg_input_phone.blur ->
  #   validateRegisterForm(false)
  reg_input_phone.on 'propertychange input', ->
    acc = $(this).val()
    if validateMobile(acc)
      checkAccount(acc, isPhoneExist)
      validateRegisterForm(false)
    else if validateEmail(acc)
      reg_input_code_row.hide()
      reg_resend_code.hide()
      checkAccount(acc, isEmailExist)
      validateRegisterForm(false)
#  reg_input_pass.on 'propertychange input', ->
#    validateRegisterForm(false)
  reg_input_pass.blur ->
    validateRegisterForm(false)
  reg_input_captcha.on 'propertychange input', ->
    validateRegisterForm(false)
  reg_input_agree.click ->
    validateRegisterForm(false)
  reg_input_code.on 'propertychange input', ->
    validateRegisterForm(false)

  # -------------------------- 註冊 - END -------------------------

  # 偵測回車鍵
  $(document).keypress (e)->
    if(e.which == 13)
      if at_page is 0 then validateLoginForm(true) else validateRegisterForm(true)