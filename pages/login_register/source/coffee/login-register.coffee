init = ->
  $form_login = $('#form-login')
  $form_register = $('#form-register')

  # 230 流程与正式环境不一样！！！！！
  is_230 = true

  $('input[type=text],input[type=password]').focus ->
    $(this).parent().addClass 'focus'
  .blur ->
    $(this).parent().removeClass 'focus'

  #  Responsive 自適應
  resizeEle = ->
#    form_w = $('.form-container').width()
#    $('.switch-header').width form_w
#    $('.form-header').width form_w
#    $('.switch-container').width form_w * 3 + 30

  resizeEle()
  $(window).resize ->
    resizeEle()

  at_page = 0
  if $form_register.length > 0
    at_page = 1

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

#  $(window).bind 'load', ->
#    if location.href.indexOf('register.html')>0
#      btn_goto_register.click()
#    else
#      btn_goto_login.click()

#  locationHashChanged()

  # 鍵入，隱藏錯誤提示
  $('input[type=text],input[type=password]').on 'propertychange input', ->
    $('.form-error').fadeOut(300)

  # 更新電腦驗證碼
  renew_captcha = ->
    if !$('.input-row.captcha input').hasClass('prohibited')
      $('.input-row.captcha .captcha').css("background-image",'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')')
      $('.input-row.captcha input').val('')
#      $('.input-row.captcha input').focus()
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
  btn_login_submit = $form_login.find 'button#submitLogin'

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
      url: $form_login.attr('data-action'),
      type: "POST",
      data: query,
      cache: false,
      dataType: "json",
      success: (result)->
        if result.status is 1
          $('.hand-loading').fadeOut(100)
          if is_230
            if result.is_no_follow_category is 0
              showSmallErrorTip('登录成功！<br/>即将跳转到登录前的页面',1)
              setTimeout(->
                window.location.href = result.success_url
              , 1500)
            else
              initPickInterest(result.category,false)
              showSmallErrorTip('登录成功！<br/>你还没选择兴趣哦',1)
              setTimeout(->
                $('.login-panel').hide()
                $('.pick-interest').fadeIn(100)
              , 1500)
          else #正式环境
            showSmallErrorTip('登录成功！<br/>即将跳转到登录前的页面',1)
            setTimeout(->
              window.location.href = result.success_url
            , 1500)
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

  reg_input_phone = $form_register.find('input.input-phone')
  reg_input_pass = $form_register.find('input.input-password')
  reg_input_captcha = $form_register.find('input#captchaInput')
  reg_input_agree = $form_register.find('#agreed')
  reg_input_code_row = $form_register.find('li#code_input')
  reg_input_code = $form_register.find('#mobCodeInput')
  reg_resend_code = $form_register.find('#resend_code')
  btn_reg_info_submit = $form_register.find('button#submitInfo')
  configMap = {
    isAccountExisted: false
  }

  # DOM method
  isPhoneExist = (exisied)->
    if exisied
      configMap.isAccountExisted = true
    else
      configMap.isAccountExisted = false
  isEmailExist = (exisied)->
    if exisied
      configMap.isAccountExisted = true
    else
      configMap.isAccountExisted = false
      
  # EventListener
  reg_input_captcha.on('keyup', checkCaptcha)
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
    # renew_captcha()
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
            btn_reg_info_submit.html('请输入手机验证码').removeClass('send-code').addClass('code-sent')
            disableBtnInfoSubmit()
            send_code_count_down()
            reg_input_phone.attr('readonly', true).addClass('prohibited')
            reg_input_captcha.attr('readonly', true).addClass('prohibited')
            reg_input_code.parent('li').fadeIn('slow')
          when -2 # 短信验证码发送失败
            showSmallErrorTip '短信验证码发送失败'
            renew_captcha()
          else
            showSmallErrorTip result.msg
            if result.msg is '验证码错误'
              renew_captcha()
            else 
              reg_input_code.val('').parent('li').fadeIn('slow')
              btn_reg_info_submit.html('请输入手机验证码').removeClass('send-code').addClass('code-sent')
              reg_input_phone.attr('readonly', true).addClass('prohibited')
              reg_input_captcha .attr('readonly', true).addClass('prohibited')
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
#          showSmallErrorTip('注册成功！<br/>即将跳转到首页',1)
#          setTimeout(->
#            window.location.href = SITE_URL
#          , 2000)
#         替换成注册成功后修改昵称
          $('.form-container').removeClass('at-register')
          $('.form-container').addClass 'at-nickname'
          $('#form-nickname').show()
          $form_register.hide()
          $('.social-login').hide()
          $('span.old-nickname').text(' ' + result.user_name)
          $('a.nickname-skip').attr('data-href',result.success_url)
          form_w = $('.form-container').width() * 2
          $('.switch-container').css 'left', -(form_w + 30)
          $('.form-error').hide()
          form_nickname.find('input.input-nickname').focus()
          at_page = 2 # nickname
          if is_230
            initPickInterest(result.category)
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
      if !validateEmail(user_phone) && !validateMobile(user_phone)
      # if !validateMobile(user_phone)
        showFormError('邮箱/手机号有误', 310, 45)
      else if configMap.isAccountExisted
        showFormError('此账号已被注册', 310, 45)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if user_phone isnt '' and user_pass isnt '' and captcha isnt '' and captcha.length >= 5 and reg_input_agree.is(':checked')
#        if validateMobile(user_phone)
        enableBtnInfoSubmit()
        if btn_reg_info_submit.hasClass('code-sent')
          btn_reg_info_submit.html('提交注册')
          if user_code.length < 5
            disableBtnInfoSubmit()
        else
          if validateMobile(user_phone)
            btn_reg_info_submit.html('发送验证码到 ' + user_phone).addClass('send-code')
          else
            btn_reg_info_submit.html('提交注册')
    else
      if user_phone is ''
        showFormError('请输入邮箱/手机号', 310, 45)
      else if !validateEmail(user_phone) && !validateMobile(user_phone)
        showFormError('邮箱/手机号有误', 310, 45)
      else if configMap.isAccountExisted
        showFormError('此账号已被注册', 310, 45)
      else if user_pass is ''
        showFormError('请输入密码', 310, 100)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if !reg_input_agree.is(':checked')
        showFormError('请同意条款', 310, 203)
      else if btn_reg_info_submit.hasClass('code-sent')
        submitRegister(user_phone,user_pass,'',user_code)
      else if btn_reg_info_submit.hasClass('send-code')
        if captcha.length < 5
          showFormError('验证码输入有误', 310, 150)
        else
          if validateMobile(user_phone)
            submitRegInfo(user_phone,captcha)
          else if validateEmail(user_phone)
            submitRegister(user_phone,user_pass,captcha)
      else if !btn_reg_info_submit.hasClass('send-code')
        if validateEmail(user_phone)
          submitRegister(user_phone,user_pass,captcha)

  # 檢查輸入是否有效，彈出驗證碼
  $('#submitInfo').click ->
    validateRegisterForm(true)
    # renew_captcha()

  # 重新發送驗證碼
  $(document).on 'click', 'a.click-to-resend', ->
    disableBtnInfoSubmit()
    renew_captcha()
    reg_input_captcha.removeClass('prohibited').attr('readonly', false)
    reg_input_code.parent('li').fadeOut()
    btn_reg_info_submit.removeClass 'code-sent'
    $('#resend_code').fadeOut('slow')

  # 動態檢查錄入
  # reg_input_phone.blur ->
  #   validateRegisterForm(false)
  reg_input_phone.on 'blur', ->
    acc = $(this).val()
    if validateMobile(acc)
      checkAccount(acc, isPhoneExist)
      validateRegisterForm(false)
    else if validateEmail(acc)
      reg_input_code_row.hide()
      reg_resend_code.hide()
      checkAccount(acc, isEmailExist)
      validateRegisterForm(false)
    else
      validateRegisterForm(false)
#  reg_input_pass.on 'propertychange input', ->
#    validateRegisterForm(false)
  # reg_input_captcha.on 'propertychange input', ->
  #   validateRegisterForm(false)
  reg_input_agree.click ->
    validateRegisterForm(false)
  # reg_input_code.on 'propertychange input', ->
  #   validateRegisterForm(false)
  reg_input_code.blur ->
    validateRegisterForm(false)    
  reg_input_captcha.blur ->
    validateRegisterForm(false)
  reg_input_captcha.on 'propertychange input', ->
    if $(this).val().length is 5
      validateRegisterForm(false)
  reg_input_code.on 'propertychange input', ->
    validateRegisterForm(false)


  # -------------------------- 註冊 - END -------------------------

  # -------------------------- 修改昵称 - START -------------------------
  form_nickname = $('#form-nickname')
  nic_input_name = form_nickname.find('input.input-nickname')
  btn_nic_info_submit = form_nickname.find('button#submitNickname')

  # 函数: 激活/禁止提交按钮
  disableBtnNicknameSubmit = ->
    btn_nic_info_submit.addClass('disabled').removeClass('always-blue')
  enableBtnNicknameSubmit = ->
    btn_nic_info_submit.removeClass('disabled').addClass('always-blue')

  # 函数：检查录入
  validateNicknameForm = (submit_pressed)->
    user_nickname = $.trim(nic_input_name.val())
    nickname_lawful   = true

#    if validateNickname(user_nickname)
#      checkNickname(user_nickname, (result)->
#        nickname_lawful = result
#    )

    if !submit_pressed
      disableBtnNicknameSubmit()
      if user_nickname.length < 2
        showFormError('请输入2-15位用户名', 310, 115)
        false
      else if !validateNickname(user_nickname,false)
        showFormError('含有非法字符', 310, 115)
        false
      else if !validateNickname(user_nickname,true)
        showFormError('用户名不能以数字开头', 310, 115)
        false
      else if user_nickname isnt '' and user_nickname.length > 1
        enableBtnNicknameSubmit()
    else
      if user_nickname is ''
        showFormError('请输入用户名', 310, 115)
        false
      else if user_nickname.length < 2
        showFormError('请输入2-15位用户名', 310, 115)
        false
      else if !validateNickname(user_nickname,false)
        showFormError('含有非法字符', 310, 115)
      else if !validateNickname(user_nickname,true)
        showFormError('用户名不能以数字开头', 310, 115)
      else if !nickname_lawful
        showFormError('用户名已被占用', 310, 115)
      else
        submitNickname(user_nickname)

  # 实时检查录入状态
  nic_input_name.on 'propertychange input', ->
    if nic_input_name.val().length > 1
      validateNicknameForm(false)
#  nic_input_name.blur ->
#    validateNicknameForm(false)

  # 函数: 提交用户名
  submitNickname = (user_nickname)->
    $('.hand-loading').show()

    $.ajax {
      url: SITE_URL + "/services/service.php?m=user&a=update_nickname"
      type: "POST"
      data: {'nick_name':user_nickname}
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').fadeOut(200)
        if result.status > 0
          if is_230
            showSmallErrorTip('用户名修改成功！',1)
            setTimeout(->
              $('.login-panel').hide()
              $('.pick-interest').fadeIn(100)
            , 1500)
          else
            showSmallErrorTip('用户名修改成功！即将跳转到首页',1)
            setTimeout(->
              window.location.href = SITE_URL
            , 1500)
        else
          if result.msg is ''
            showSmallErrorTip '系统异常，请稍后重试'
          else
            showSmallErrorTip result.msg
            showFormError(result.msg, 310, 115)
      error: (result)->
        $('.hand-loading').fadeOut(200)
        if result.msg is ''
          showSmallErrorTip '系统异常，请稍后重试'
        else
          showSmallErrorTip result.msg + ''
    }

  btn_nic_info_submit.click ->
    validateNicknameForm(true)

  $('a.nickname-skip').click ->
#    url = $(this).attr 'data-href'
#    location.href = url
    if is_230
      $('.login-panel').hide()
      $('.pick-interest').fadeIn(100)
    else
      showSmallErrorTip('即将跳转到首页<br>记得修改用户名哦',1)
      setTimeout(->
        window.location.href = SITE_URL
      , 1500)

  # -------------------------- 修改昵称 - END -------------------------

  # 偵測回車鍵
  form_nickname.find('input.input-nickname').keypress (e)->
    # 此function为了解决在此输入框中按回车键时直接页面跳转的问题
    if(e.which == 13)
      validateNicknameForm(true)
      false

  $(document).keypress (e)->
    if(e.which == 13)
      if at_page is 0
        validateLoginForm(true)
      else if at_page is 1
        validateRegisterForm(true)
      else if at_page is 2
        validateNicknameForm(true)
