init = ->
  $('input[type=text],input[type=password]').focus ->
    $(this).parent().addClass 'focus'
  .blur ->
    $(this).parent().removeClass 'focus'

  # Responsive 自適應
  resizeEle = ->
    form_w = $('.form-container').width()
    $('.switch-header').width form_w
    $('.form-header').width form_w
    $('.switch-container').width form_w * 2 + 30

  resizeEle()
  $(window).resize ->
    resizeEle()

  # 刷新電腦驗證碼
  $.fn.refresh_captcha = ->
    $(this).css("background-image",
      'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')')

  at_page = 0

  #  Switch forms 三个表格切换
  $('.goto-phone').click ->
    $('.form-container').addClass 'at-register'
    form_w = $('.form-container').width()
    $('.switch-container').css 'left', -(form_w + 30)
    $('#form-phone-reclaim').show()
    $('#form-mail-reclaim').hide()
    $('.form-error').hide()
    $('#form-phone-reclaim').find('input.captcha-input').val('')
    $('#form-phone-reclaim').find('a.captcha').refresh_captcha()
    at_page = 0 #手機修改密碼
  $('.goto-mail').click ->
    $('.form-container').removeClass 'at-register'
    $('.switch-container').css 'left', 0
    $('#form-phone-reclaim').hide()
    $('#form-phone-changed').hide()
    $('#form-mail-reclaim').show()
    $('.form-error').hide()
    $('#form-mail-reclaim').find('input.captcha-input').val('')
    $('#form-mail-reclaim').find('a.captcha').refresh_captcha()
    at_page = 1 #郵箱修改密碼
  $('.goto-phone-changed').click ->
    $('#form-phone-reclaim').hide()
    $('#form-phone-changed').show()
    $('#form-phone-changed').find('input.captcha-input').val('')
    $('.form-error').hide()
    at_page = 2 #手機號碼更改

  btn_reveal_pw = $('.icon-unseen')
  btn_reveal_pw.click ->
    $(this).toggleClass 'icon-seen'
    ipt_pass = $(this).prev();
    if ipt_pass.attr('type') is 'password'
      ipt_pass.attr('type', 'text')
    else
      ipt_pass.attr('type', 'password')

  $('a.captcha').click ->
    $(this).refresh_captcha()
    $(this).parent('.captcha').find('input').val('')

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
  locationHashChanged = ->
    if location.hash is "#phone"
      $('.goto-phone').click()
    else if location.hash is "#mail"
      $('.goto-mail').click()

  $(window).bind 'hashchange', ->
    locationHashChanged()

  locationHashChanged()

  # 侦测键盘输入，隐藏错误提示
  $('input[type=text],input[type=password]').on 'propertychange input', ->
    $('.form-error').fadeOut(300)

  # IE瀏覽器居中彈窗
#  $.fn.changePopupPosForIE = ->
#    popup_content = $(this).find('.popup-content')
#    popup_content_w = popup_content.width() + 96
#    popup_content.css 'left': ($(window).width() - popup_content_w) / 2, 'top': 200


  # -------------------------- 郵件修改密碼 - START -------------------------

  form_mail_reclaim = $('#form-mail-reclaim')
  mail_rec_input_mail = form_mail_reclaim.find('input.input-mail')
  mail_rec_input_captcha = form_mail_reclaim.find('#captchaInput1')
  btn_mail_rec_submit = form_mail_reclaim.find('#submitMailReclaim')
  link_mail_captcha = form_mail_reclaim.find('a.captcha')

  link_mail_captcha.refresh_captcha()

  # 发送郵件60秒倒计时
  resend_mail_countdown = (sec)->
    count_down_text = $('#form-mail-reclaim').find('.after-submit').find('p').eq(1)
    sec = sec || 60
    sec--
    if sec > 0
      count_down_text.html('如收不到邮件，可于' + sec + '秒后重试。')
      setTimeout(->
        resend_mail_countdown(sec)
      , 1000)
    else
      count_down_text.html("如收不到邮件，可<a class='text refresh-mail-reclaim' id=''>点击这里</a>重试。")
      $('#pop-applycode .icon-set-b').show()

  # Event Listener
  mail_rec_input_captcha.on('keyup', checkCaptcha);

  # 函數：激活/禁止提交按鈕
  disableBtnMailRecSubmit = ->
    btn_mail_rec_submit.addClass('disabled').removeClass('always-blue')
  enableBtnMailRecSubmit = ->
    btn_mail_rec_submit.removeClass('disabled').addClass('always-blue')

  # 函數: 提交郵件修改密碼請求
  submitMailReclaim = (mail,captcha)->
    $('.hand-loading').show()
    query = new Object()
    query.email = mail
    query.verify = captcha
    action = form_mail_reclaim.attr 'data-action'
    $.ajax {
      url: SITE_URL + action
      type: "POST"
      data: query
      cache: false
      dataType: "json"
      success: (result)->
        if result.status is 1
          form_mail_reclaim.find('.before-submit').hide()
          form_mail_reclaim.find('.after-submit').show()
          $('.goto-phone').hide()
          resend_mail_countdown()
        else if result.msg isnt ''
          showSmallErrorTip(result.msg)
        $('.hand-loading').hide()
        $('#form-mail-reclaim').find('a.captcha').refresh_captcha()
      error: ->
        showSmallErrorTip('操作失败，请稍后重新尝试')
        $('.hand-loading').hide()
    }

  # 函數：檢查錄入
  validateMailRecForm = (submit_pressed,typing)->
    user_mail = mail_rec_input_mail.val()
    captcha = mail_rec_input_captcha.val()
    if !submit_pressed
      disableBtnMailRecSubmit()
      if !validateEmail(user_mail)
        showFormError('邮箱输入有误', 310, 45)
#      else if validateEmail(user_mail)
#        checkAccount(user_mail, (result) ->
#          if !result
#            showFormError('该邮箱未注册', 310, 45)
#        )
      else if captcha.length isnt 5
        if typing is 0
          showFormError('验证码输入有误', 310, 100)
      else if captcha.length is 5

        enableBtnMailRecSubmit()
    else
      if user_mail is ''
        showFormError('请输入邮箱', 310, 45)
      else if !validateEmail(user_mail)
        showFormError('邮箱输入有误', 310, 45)
#      else if validateEmail(user_mail)
#        checkAccount(user_mail, (result) ->
#          if !result
#            showFormError('该邮箱未注册', 310, 45)
#        )
      else if captcha is '' or captcha.length isnt 5
        showFormError('验证码输入有误', 310, 100)
      else
        submitMailReclaim(user_mail,captcha)

  # 点击邮件修改密码按钮
  btn_mail_rec_submit.click ->
    validateMailRecForm(true)

  # 刷新郵件重置密碼表單
  $(document).on 'click', '.refresh-mail-reclaim', ->
    mail_rec_input_captcha.val ''
    link_mail_captcha.refresh_captcha()
    form_mail_reclaim.find('.before-submit').show()
    form_mail_reclaim.find('.after-submit').hide()
    $('.goto-phone').show()

  # 動態檢查錄入
  mail_rec_input_mail.blur ->
    validateMailRecForm(false)
  mail_rec_input_captcha.on 'propertychange input', ->
    mail = mail_rec_input_mail.val()
    if validateEmail(mail)
      validateMailRecForm(false)
  mail_rec_input_captcha.blur ->
    validateMailRecForm(false,0)

  # -------------------------- 郵件修改密碼 - END -------------------------


  # -------------------------- 手機修改密碼 - START -------------------------

  # 關閉手機找回密碼的驗證碼彈窗
  popup_phone_reclaim = $('#phoneReclaimPopup')

#  show_phone_reclaim = (class_name)->
##    if popup_phone_reclaim.find('a.captcha').css('background-image') is 'none'
#    popup_phone_reclaim.find('a.captcha').refresh_captcha()
#    popup_phone_reclaim.find('input.captcha-input').val ''
#    popup_phone_reclaim.find('input.phone-code-input').val ''
#    popup_phone_reclaim.find('button.send-code').show()
#    popup_phone_reclaim.find('.phone-code-input-row').hide()
#    popup_phone_reclaim.find('h5.resend-code').hide()
#    popup_phone_reclaim.find('button.submit-reclaim').hide()
#    if checkIE()
#      popup_phone_reclaim.changePopupPosForIE()
#    popup_phone_reclaim.fadeIn(200)
#    popup_phone_reclaim.find('button.submit-reclaim').removeClass('submit-phone-reclaim').removeClass('submit-phone-changed')
#    popup_phone_reclaim.find('button.submit-reclaim').addClass(class_name)
#
##   關閉手機找回密碼的彈窗
#  popup_phone_reclaim.find('.close-popup').click ->
#    popup_phone_reclaim.fadeOut(200)

  # DOM
  form_phone_reclaim          = $('#form-phone-reclaim')
  input_phone_rec_phone       = form_phone_reclaim.find('input.input-phone')
  input_phone_rec_pass        = form_phone_reclaim.find('input.input-password')
  input_phone_rec_pass_again  = form_phone_reclaim.find('input.input-password-again')
  input_phone_rec_captcha     = form_phone_reclaim.find('input.captcha-input')
  input_phone_rec_code        = form_phone_reclaim.find('input.phone-code-input')
  row_phone_rec_code          = form_phone_reclaim.find('li.phone-code-input-row')
  btn_phone_rec_submit        = form_phone_reclaim.find('#submitPhoneReclaim')
  link_resend_code            = form_phone_reclaim.find('h5.resend-code')
  link_captcha                = form_phone_reclaim.find('a.captcha')

  link_captcha.refresh_captcha()

  # 函數：激活/禁止提交按鈕
  disableBtnPhoneRecSubmit = ->
    btn_phone_rec_submit.addClass('disabled').removeClass('always-blue')
  enableBtnPhoneRecSubmit = ->
    btn_phone_rec_submit.removeClass('disabled').addClass('always-blue')

  # 发送手机验证码60秒倒计时
  phoneSendCodeCountDown = (rec_or_chg,sec)->
    sec = sec || 60
    sec--
    if rec_or_chg is 'rec'
      link_resend_code.show()
    else
      link_resend_code_p_c.show()
    if sec > 0
      if rec_or_chg is 'rec' then link_resend_code.html(sec + '秒后重新发送验证码') else link_resend_code_p_c.html(sec + '秒后重新发送验证码')
      setTimeout(->
        phoneSendCodeCountDown(rec_or_chg,sec)
      , 1000)
    else
      if rec_or_chg is 'rec'
        link_resend_code.html("<a class='text click-to-resend'>重新发送</a>验证码")
      else
        link_resend_code_p_c.html("<a class='text click-to-resend'>重新发送</a>验证码")

  # Evnet Listener
  input_phone_rec_captcha.on('keyup', checkCaptcha);

  # 函數：發送手機驗證碼請求
  sendPhoneCode = (rec_or_chg, phone,captcha,type)->
    $('.hand-loading').show()
    $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {m: 'user', a: 'get_mobile_verify', ajax: 1, mobile: phone, code: captcha, type: type}
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').hide()
        switch parseInt(result.status)
          when 1 # 短信验证码已经发送
            showSmallErrorTip '已发送验证码到你的手机', 1
            if rec_or_chg is 'rec'
              phoneSendCodeCountDown('rec')
              disableBtnPhoneRecSubmit()
              row_phone_rec_code.show()
              btn_phone_rec_submit.removeClass('send-code').addClass('code-sent').html('提交')
            else
              disableBtnPhoneChgSubmit()
              phoneSendCodeCountDown('chg')
              row_phone_chg_code.show()
              btn_phone_chg_submit.removeClass('send-code').addClass('code-sent').html('提交')
          when -2 # 短信验证码发送失败
            showSmallErrorTip '短信验证码发送失败'
          else
            if result.msg != ''
              showSmallErrorTip result.msg
      error: ->
        $('.hand-loading').hide()
        showSmallErrorTip '系统异常，请稍后重试'
    }

  # 重置成功后的3秒倒计时
  resetSuccessCountDown = (rec_or_chg, obj,sec)->
    sec = sec || 5
    sec--
    if sec > 0
      obj.html(sec + ' 秒后自动跳转')
      setTimeout(->
        resetSuccessCountDown(rec_or_chg,obj,sec)
      , 1000)
    else
      if rec_or_chg is 'rec'
        window.location.href = form_phone_reclaim.attr('data-redir')
      else
        window.location.href = form_phone_changed.attr('data-redir')

  # 成功後的操作
  afterSubmitSuccess = (rec_or_chg,phone,url,form)->
    form.attr('data-redir', url)
    form.children('*').hide()
    form.find('p.desc').html('已收到您的请求<br/>我们将在1-2个工作日内审核完毕<br />结果将发送至手机<br/><span> ' + phone.substr(0,
        3) + '****' + phone.substr(-4)) + '</span>'
    form.find('p.desc').show()
    if rec_or_chg is 'rec'
      resetSuccessCountDown(rec_or_chg,link_resend_code)
    else
      resetSuccessCountDown(rec_or_chg,link_resend_code_p_c)

  # 提交手機更改密碼
  submitPhoneReclaim = (user_phone,user_pass,user_pass_again,phone_code)->
    $('.hand-loading').show()
    query = new Object()
    query.account = user_phone
    query.password = user_pass
    query.password2 = user_pass_again
    query.code = ''
    query.rcode = phone_code
    url = form_phone_reclaim.attr 'data-action'
    $.ajax {
      url: SITE_URL + url
      type: "POST"
      data: query
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').hide()
        switch result.status
          when 1
            afterSubmitSuccess('rec',user_phone,result.success_url,form_phone_reclaim)
          when -12 # 无效的短信验证码
            showSmallErrorTip '短信验证码错误，请重新输入'
          else
            if result.msg != ''
              showSmallErrorTip result.msg
      error: ->
        $('.hand-loading').hide()
        showSmallErrorTip '系统异常，请稍后重试'
    }

  # 函數：檢查錄入
  validatePhoneRecForm = (submit_pressed)->
    user_phone      = $.trim(input_phone_rec_phone.val())
    user_pass       = $.trim(input_phone_rec_pass.val())
    user_pass_again = $.trim(input_phone_rec_pass_again.val())
    captcha         = $.trim(input_phone_rec_captcha.val())
    user_code       = $.trim(input_phone_rec_code.val())

    if !submit_pressed
      disableBtnPhoneRecSubmit()
      if !validateMobile(user_phone)
        showFormError('手机输入有误', 310, 45)
        btn_phone_rec_submit.html('获取手机验证码').addClass('send-code')
#      else if validateMobile(user_phone)
#        checkAccount(user_phone, (result) ->
#          if !result
#            showFormError('该手机未注册', 310, 45)
#        )
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if user_pass_again isnt '' and user_pass_again isnt user_pass
        showFormError('两次输入的密码不相同', 310, 145)
      else if user_phone isnt '' and user_pass isnt '' and user_pass_again isnt '' and captcha isnt '' and captcha.length is 5
        if btn_phone_rec_submit.hasClass('send-code')
          enableBtnPhoneRecSubmit()
        else if btn_phone_rec_submit.hasClass('code-sent') and user_code isnt '' and user_code.length is 5
          enableBtnPhoneRecSubmit()
    else
      if user_phone is ''
        showFormError('请输入手机', 310, 45)
      else if !validateMobile(user_phone)
        showFormError('手机输入有误', 310, 45)
#      else if validateMobile(user_phone)
#        checkAccount(user_phone, (result) ->
#          if !result
#            showFormError('该手机未注册', 310, 45)
#        )
      else if user_pass is ''
        showFormError('请输入密码', 310, 100)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 100)
      else if user_pass_again is ''
        showFormError('请重复输入密码', 310, 145)
      else if user_pass_again isnt user_pass
        showFormError('两次输入的密码不相同', 310, 145)
      else if btn_phone_rec_submit.hasClass('send-code')
        sendPhoneCode('rec',user_phone,captcha,'')
      else if btn_phone_rec_submit.hasClass('code-sent')
        submitPhoneReclaim(user_phone,user_pass,user_pass_again,user_code)


  # 重新发送验证码
  $(document).on 'click','#form-phone-reclaim h5.resend-code a', ->
    btn_phone_rec_submit.addClass('send-code')
    btn_phone_rec_submit.removeClass('code-sent')
    validatePhoneRecForm(true)

  # 提交手機取回密碼表單
  btn_phone_rec_submit.click ->
    validatePhoneRecForm(true)

  # 動態檢查錄入
  input_phone_rec_phone.blur ->
    validatePhoneRecForm(false)
    user_phone      = $.trim(input_phone_rec_phone.val())
    if validateMobile(user_phone)
      btn_phone_rec_submit.html('发送验证码到 ' + user_phone)
  input_phone_rec_pass.blur ->
    validatePhoneRecForm(false)
  input_phone_rec_pass_again.blur ->
    validatePhoneRecForm(false)
  input_phone_rec_captcha.on 'propertychange input', ->
    validatePhoneRecForm(false)
  input_phone_rec_code.on 'propertychange input', ->
    validatePhoneRecForm(false)

# 手機彈出框輸入驗證碼
#  popup_phone_reclaim.find('button.send-code').click ->
#    captcha = popup_phone_reclaim.find('.captcha-input').val()
#    type = ''
#    if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-reclaim')
#      user_phone = $('#form-phone-reclaim').find('.input-phone').val()
#    else if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-changed')
#      user_phone = $('#form-phone-changed').find('.input-new-phone').val()
#      type = 'reg'
#
#    if captcha is ''
#      showSmallErrorTip('请输入验证码')
#    else if captcha.length > 0 && captcha.length isnt 5
#      showSmallErrorTip('验证码不正确')
#    else
#      popup_phone_reclaim.find('button.send-code').hide()
#      popup_phone_reclaim.find('h5.resend-code').show()
#      popup_phone_reclaim.find('.phone-code-input-row').show()
#      popup_phone_reclaim.find('button.submit-reclaim').show()
#      sendPhoneCode(user_phone,captcha,type)

  # -------------------------- 手機修改密碼 - END -------------------------


  # -------------------------- 換了手機號碼 - START -------------------------

  form_phone_changed = $('#form-phone-changed')
  popup_phone_changed = $('#phoneChangedPopup')

  input_phone_chg_phone       = form_phone_changed.find('.input-phone')
  input_phone_chg_phone_new   = form_phone_changed.find('.input-new-phone')
  input_phone_chg_pass        = form_phone_changed.find('.input-password')
  input_phone_chg_pass_again  = form_phone_changed.find('.input-password-again')
  input_phone_chg_code        = form_phone_changed.find('input.phone-code-input')
  input_phone_chg_captcha     = form_phone_changed.find('input.captcha-input')
  row_phone_chg_code          = form_phone_changed.find('li.phone-code-input-row')
  btn_phone_chg_submit        = form_phone_changed.find('#submitPhoneChanged')
  link_resend_code_p_c        = form_phone_changed.find('h5.resend-code')
  link_captcha_p_c            = form_phone_changed.find('a.captcha')

  # 地區下拉菜單
  selected_region_text = form_phone_changed.find('.dd-result span')
  selected_region_input = form_phone_changed.find('.choose-region')

  # 初始化地區菜單
  location_dd = form_phone_changed.find('.form-dropdown')
  province_dd = location_dd.find('dl.provinces')
  city_dd = location_dd.find('dl.cities')

  # 畫下拉菜單
  build_region_list = (id,obj)->
    data = REGIONS[id]
    list = ''
    for region in data
      item = "<dd data-id='" + region.id + "' >" + region.name + "</dd>"
      list += item
    obj.html list

  # 先畫北京
  build_region_list(0,province_dd)
  build_region_list(1,city_dd)

  city_dd.addClass 'disabled'

  # 選擇省份
  $(document).on 'click', 'dl.provinces dd', ->
    if !$(this).hasClass 'selected'
      city_dd.scrollTop 0
      location_dd.find('i').remove()
      province_dd.find('dd').removeClass('selected')
      city_dd.removeClass 'disabled'
      $(this).append('<i class="icon icon-tick icon-sml"></i>').addClass('selected')
      selected_region_text.html($(this).text()).addClass('has-region')
      province_id = $(this).attr 'data-id'
      selected_region_input.attr 'data-province':province_id,'data-city':0
      build_region_list(province_id,city_dd)

  # 選擇城市
  $(document).on 'click', 'dl.cities dd', ->
    if !$(this).hasClass('selected') and !$(this).parent().hasClass('disabled')
      city_dd.find('i').remove()
      $(this).append('<i class="icon icon-tick icon-sml"></i>').addClass('selected')
      province_text = province_dd.find('.selected').text()
      selected_region_text.html(province_text + ' ' + $(this).text())
      city_id = $(this).attr 'data-id'
      selected_region_input.attr 'data-city',city_id
      dd_trigger.blur()
      selected_region_input.val selected_region_text.text()
      location_dd.hide()
      validatePhoneChgForm(false)

  # 點擊下拉菜單按鈕
  dd_trigger = $('#form-phone-changed').find('.dropdown-trigger')
  dd_trigger.click ->
    location_dd.show()
    $('.form-error').fadeOut(300)
  # 離開下拉菜單
  location_dd.mouseleave ->
    dd_trigger.blur()
    selected_region_input.val selected_region_text.text()
    location_dd.hide()

  link_captcha_p_c.refresh_captcha()

  # 函數：激活/禁止提交按鈕
  disableBtnPhoneChgSubmit = ->
    btn_phone_chg_submit.addClass('disabled').removeClass('always-blue')
  enableBtnPhoneChgSubmit = ->
    btn_phone_chg_submit.removeClass('disabled').addClass('always-blue')

  # 函數：提交手機更改
  submitPhoneChanged = (user_phone_old,user_phone_new,user_province,user_city,user_password,user_password_again,phone_code)->
    query = new Object()
    query.mobile_old = user_phone_old
    query.mobile = user_phone_new
    query.province = user_province
    query.city = user_city
    query.password = user_password
    query.password2 = user_password_again
    query.rcode = phone_code

    $.ajax {
      url: SITE_URL +'services/service.php?m=user&a=resetapply',
        type: "POST",
        data: query,
        cache: false,
        dataType: "json",
        success: (result)->
          switch result.status
            when 1
              form_phone_changed.attr('data-redir', result.success_url)
              form_phone_changed.find('p.desc').show()
              form_phone_changed.find('p.desc').html('已收到您的请求。<br/>我们将在1-2个工作日内审核完毕<br />结果将发送至手机 ' + user_phone_new.substr(0,
                  3) + '****' + user_phone_new.substr(-4))
              afterSubmitSuccess('chg',user_phone_new,result.success_url,form_phone_changed)
            when -12 # 无效的短信验证码
              showSmallErrorTip '短信验证码错误，请重新输入'
            else
              if result.msg != ''
                showSmallErrorTip result.msg
        error: ->
          $('.hand-loading').hide()
          showSmallErrorTip '系统异常，请稍后重试'
    }

  # 函數：檢查錄入
  validatePhoneChgForm = (submit_pressed)->
    user_phone      = $.trim(input_phone_chg_phone.val())
    user_phone_new  = $.trim(input_phone_chg_phone_new.val())
    user_pass       = $.trim(input_phone_chg_pass.val())
    user_pass_again = $.trim(input_phone_chg_pass_again.val())
    captcha         = $.trim(input_phone_chg_captcha.val())
    user_code       = $.trim(input_phone_chg_code.val())
    user_province   = selected_region_input.attr 'data-province'
    user_city       = selected_region_input.attr 'data-city'

    input_phone_chg_captcha.on('keyup', checkCaptcha)

    if !submit_pressed
      disableBtnPhoneChgSubmit()
      if !validateMobile(user_phone)
        showFormError('旧号码输入有误', 310, 45)
      else if user_phone_new.length > 0 and !validateMobile(user_phone_new)
        showFormError('新号码输入有误', 310, 100)
        btn_phone_chg_submit.html('获取手机验证码')
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 204)
      else if user_pass_again isnt '' and user_pass_again isnt user_pass
        showFormError('两次输入的密码不相同', 310, 255)
      else if user_phone isnt '' and user_pass isnt '' and user_pass_again isnt '' and user_city isnt '0' and captcha isnt '' and captcha.length is 5
        if btn_phone_chg_submit.hasClass('send-code')
          enableBtnPhoneChgSubmit()
        if btn_phone_chg_submit.hasClass('code-sent') and user_code isnt '' and user_code.length is 5
          enableBtnPhoneChgSubmit()
    else
      if user_phone is ''
        showFormError('请输入旧号码', 310, 45)
      else if !validateMobile(user_phone)
        showFormError('旧号码输入有误', 310, 45)
      else if user_phone_new is ''
        showFormError('请输入新号码', 310, 100)
      else if !validateMobile(user_phone_new)
        showFormError('新号码输入有误', 310, 100)
      else if user_city is '0'
        showFormError('请选择完整省市',310,152)
      else if user_pass is ''
        showFormError('请输入密码', 310, 204)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 204)
      else if user_pass_again is ''
        showFormError('请重复输入密码', 310, 255)
      else if user_pass_again isnt user_pass
        showFormError('两次输入的密码不相同', 310, 255)
      else if btn_phone_chg_submit.hasClass('send-code')
        sendPhoneCode('chg',user_phone_new,captcha,'')
      else if btn_phone_chg_submit.hasClass('code-sent')
        submitPhoneChanged(user_phone,user_phone_new,user_province,user_city,user_pass,user_pass_again,user_code)

  # 重新发送验证码
  $(document).on 'click','#form-phone-changed h5.resend-code a', ->
    btn_phone_chg_submit.addClass('send-code')
    btn_phone_chg_submit.removeClass('code-sent')
    validatePhoneChgForm(true)

  # 提交手機取回密碼表單
  btn_phone_chg_submit.click ->
    validatePhoneChgForm(true)

  # 動態檢查錄入
  input_phone_chg_phone.blur ->
    validatePhoneChgForm(false)
  input_phone_chg_phone_new.blur ->
    validatePhoneChgForm(false)
    user_phone_new = $.trim(input_phone_chg_phone_new.val())
    if validateMobile(user_phone_new)
      btn_phone_chg_submit.html('发送验证码到 ' + user_phone_new)
  input_phone_chg_pass.blur ->
    validatePhoneChgForm(false)
  input_phone_chg_pass_again.blur ->
    validatePhoneChgForm(false)
  input_phone_chg_captcha.on 'propertychange input', ->
    validatePhoneChgForm(false)
  input_phone_chg_code.on 'propertychange input', ->
    validatePhoneChgForm(false)

  # -------------------------- 換了手機號碼 - END -------------------------


  # 偵測回車鍵
  $(document).keypress (e)->
    if(e.which == 13)
      switch at_page
        when 0
          validatePhoneRecForm(true)
        when 1
          validateMailRecForm(true)
        when 2
          validatePhoneChgForm(true)


