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

  btn_reveal_pw = $('.icon-unseen')
  btn_reveal_pw.click ->
    $(this).toggleClass 'icon-seen'
    ipt_pass = $(this).prev();
    if ipt_pass.attr('type') is 'password'
      ipt_pass.attr('type', 'text')
    else
      ipt_pass.attr('type', 'password')

  #  Switch login and register 註冊登錄切換
  btn_goto_login = $('.goto-login')
  btn_goto_register = $('.goto-register')
  btn_goto_register.click ->
    $('.form-container').removeClass 'at-register'
    $('.switch-container').css 'left', 0
    $('.form-error').fadeOut(100)
  btn_goto_login.click ->
    $('.form-container').addClass 'at-register'
    form_w = $('.form-container').width()
    $('.switch-container').css 'left', -(form_w + 30)
    $('.form-error').fadeOut(100)

  #  Form input error tip 彈出錯誤提示
  showFormError = (text, x, y)->
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
  showSmallErrorTip = (text)->
    $('.form-error-mob').find('label').html(text)
    $('.form-error-mob').fadeIn(200)
    setTimeout(->
      $(".form-error-mob").fadeOut(100)
    , 1000)

  # 適應返回鍵
  locationHashChanged = ->
    if location.hash is "#register"
      btn_goto_register.click()
    else if location.hash is "#login"
      btn_goto_login.click()

  $(window).bind 'hashchange', ->
    locationHashChanged()

  locationHashChanged()

  # 鍵入，隱藏錯誤提示
  $('input[type=text],input[type=password]').on 'propertychange input', ->
    $('.form-error').fadeOut(300)

  #  Login submit 提交登錄
  form_login = $('#form-login')
  form_login.submit ->
    user_phone = $.trim($('#form-login input.input-phone').val())
    user_pass = $.trim($('#form-login input.input-password').val())
    if user_phone is ''
      showFormError('请输入邮箱/手机号', 310, 45)
    else if !validateEmail(user_phone) && !validateMobile(user_phone)
      showFormError('邮箱/手机号有误', 310, 45)
    else if user_pass is ''
      showFormError('请输入密码', 310, 100)
    else
      query = new Object()
      query.account = user_phone
      query.password = user_pass
      query.remember = $('#remember').is(':checked') ? 1: 0
      query.rhash = $.trim($("input[name=rhash]").val());

      $('.hand-loading').show()

      $.ajax {
        url: $(this).attr('data-action'),
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
    false

  # 更新電腦驗證碼
  renew_captcha = ->
    $('.input-row.captcha .captcha').css("background-image",
      'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')');
    $('.input-row.captcha input').val('');


  # 驗證碼彈出框
  popup = $('.popup-wrap')
  popup_content = popup.find '.popup-content'

  changePopupPosForIE = ->
    popup_content_w = popup_content.width() + 96
    #    popup_content_h = popup_content.height() + 96
    popup_content.css 'left': ($(window).width() - popup_content_w) / 2, 'top': 200

  # 檢查輸入是否有效，彈出驗證碼
  $('#pop-captcha').click ->
    user_phone = $.trim($('#form-register input.input-phone').val())
    user_pass = $.trim($('#form-register input.input-password').val())

    if $('.input-row.captcha .captcha').css('background-image') is 'none'
      renew_captcha()

    $('#resend_code, #code_input, #send_code').hide()

    if user_phone is ''
      showFormError('请输入邮箱/手机号', 310, 45)
    else if !validateEmail(user_phone) && !validateMobile(user_phone)
      showFormError('邮箱/手机号有误', 310, 45)
    else if user_pass is ''
      showFormError('请输入密码', 310, 100)
    else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
      showFormError('请输入6-12位密码', 310, 100)
    else if !$('#agreed').is(':checked')
      showFormError('请同意条款', 310, 145)
    else if validateEmail(user_phone)
      $('#submit_register').show()
      $('#send_code').hide()
      if checkIE()
        changePopupPosForIE()
      popup.fadeIn(200)
    else if validateMobile(user_phone)
      $('#submit_register').hide()
      $('#send_code').html('发送验证码到 ' + user_phone).show()
      if checkIE()
        changePopupPosForIE()
      popup.fadeIn(200)
    false

  # 发送手机验证码60秒倒计时
  send_code_count_down = (sec)->
    sec = sec || 60
    sec--
    if sec > 0
      $('#resend_code').html(sec + '秒后重新发送验证码')
      setTimeout(->
        send_code_count_down(sec)
      , 1000)
    else
      $('#resend_code').html("<a class='text click-to-resend'>重新发送</a>验证码")

  # 發送手機驗證碼
  $(document).on 'click', '#send_code, a.click-to-resend', ->
    v_code = $.trim($('#captchaInput').val())
    if v_code is ''
      showSmallErrorTip('请输入验证码')
    else if v_code.length > 0 && v_code.length isnt 5
      showSmallErrorTip('验证码错误')
    else
      $('.hand-loading').show()
      $('#code_input, #resend_code, #submit_register').show()
      $('#send_code').hide()
      user_phone = $.trim($('#form-register input.input-phone').val())
      v_code = $.trim($('#captchaInput').val())
      $.ajax {
        url: SITE_URL + 'services/service.php',
        type: "GET",
        data: {m: 'user', a: 'get_mobile_verify', ajax: 1, mobile: user_phone, code: v_code, type: 'reg'},
        cache: false,
        dataType: "json",
        success: (result)->
          $('.hand-loading').hide()
          switch result.stauts
            when -10 # 短信验证码已经发送
              showSmallErrorTip '已发送验证码到你的手机'
              send_code_count_down()
            when -11 # 短信验证码发送失败
              showSmallErrorTip '短信验证码发送失败'
            else
              if result.msg != ''
                showSmallErrorTip result.msg
        error: ->
          $('.hand-loading').hide()
          showSmallErrorTip '系统异常，请稍后重试'
      }

  # 提交註冊
  # 接口函數
  submitRegister = (user_phone, user_pass, v_code, m_code)->
    $('.hand-loading').show()
    query = new Object()
    query.account = user_phone
    query.password = user_pass
    query.code = v_code
    query.rcode = m_code
    query.rhash = $("input[name=rhash]").val()
    $.ajax {
      url: SITE_URL + 'user/ajax_register.html',
      type: "POST",
      data: query,
      cache: false,
      dataType: "json",
      success: (result)->
        $('.hand-loading').fadeOut(200)
        console.log result
      error: ->
        $('.hand-loading').fadeOut(200)
        console.log result
    }

  # 點擊註冊按鈕
  $('#submit_register').click ->
    user_phone = $.trim($('#form-register input.input-phone').val())
    user_pass = $.trim($('#form-register input.input-password').val())
    v_code = $.trim($('#captchaInput').val())
    m_code = $.trim($('mobCodeInput').val())

    if validateEmail(user_phone)
      m_code = ''
      if v_code is ''
        showSmallErrorTip('请输入验证码')
      else if v_code.length > 0 && v_code.length isnt 5
        showSmallErrorTip('验证码错误')
      else
        submitRegister(user_phone, user_pass, v_code, m_code)
    else if validateMobile(user_phone)
      v_code = ''
      if m_code is ''
        showSmallErrorTip('请输入手机验证码')
      else if m_code.length > 0 && m_code.length isnt 5
        showSmallErrorTip('手机验证码错误')
      else
        submitRegister(user_phone, user_pass, v_code, m_code)

  # 關閉彈窗
  $('.close-popup').click ->
    popup.fadeOut(200)

  # Click and change captcha image 點擊驗證碼刷新
  $("a.captcha").click ->
    renew_captcha()