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

  #  Switch forms 三个表格切换
  $('.goto-phone').click ->
    $('.form-container').addClass 'at-register'
    form_w = $('.form-container').width()
    $('.switch-container').css 'left', -(form_w + 30)
    $('#form-phone-reclaim').show()
    $('#form-mail-reclaim').hide()
  $('.goto-mail').click ->
    $('.form-container').removeClass 'at-register'
    $('.switch-container').css 'left', 0
    $('#form-phone-reclaim').hide()
    $('#form-phone-changed').hide()
    $('#form-mail-reclaim').show()
  $('.goto-phone-changed').click ->
    $('#form-phone-reclaim').hide()
    $('#form-phone-changed').show()

  btn_reveal_pw = $('.icon-unseen')
  btn_reveal_pw.click ->
    $(this).toggleClass 'icon-seen'
    ipt_pass = $(this).prev();
    if ipt_pass.attr('type') is 'password'
      ipt_pass.attr('type', 'text')
    else
      ipt_pass.attr('type', 'password')

  # 刷新電腦驗證碼
  $.fn.refresh_captcha = ->
    $(this).css("background-image",
      'url(' + SITE_URL + "services/service.php?m=index&a=verify&rand=" + Math.random() + ')')

  $('#form-mail-reclaim').find('a.captcha').refresh_captcha()
  $('a.captcha').click ->
    $(this).refresh_captcha()

  # Form input error tip 彈出錯誤提示
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

  # Form input error tip 彈出錯誤提示
  showSmallErrorTip = (text)->
    $('.form-error-mob').find('label').html(text)
    $('.form-error-mob').fadeIn(200)
    setTimeout(->
      $(".form-error-mob").fadeOut(100)
    , 1000)

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
  $.fn.changePopupPosForIE = ->
    popup_content = $(this).find('.popup-content')
    popup_content_w = popup_content.width() + 96
    popup_content.css 'left': ($(window).width() - popup_content_w) / 2, 'top': 200


  # -------------------------- 郵件修改密碼 - START -------------------------
  # 点击邮件修改密码按钮
  $('#submitMailReclaim').click ->
    user_mail = $('#form-mail-reclaim').find('input.input-mail').val()
    captcha = $('#form-mail-reclaim').find('#captchaInput1').val()
    if user_mail is ''
      showFormError('请输入邮箱', 310, 45)
    else if !validateEmail(user_mail)
      showFormError('邮箱输入有误', 310, 45)
    else if captcha is '' or captcha.length isnt 5
      showFormError('验证码输入有误', 310, 100)
    else
      $('.hand-loading').show()
      query = new Object()
      query.email = user_mail
      query.verify = captcha
      $.ajax {
        url: SITE_URL +'services/service.php?m=user&a=forgetpassword',
        type: "POST",
        data: query,
        cache: false,
        dataType: "json",
        success: (result)->
          if result.status is 1
            console.log result
            $('#form-mail-reclaim').find('.before-submit').hide()
            $('#form-mail-reclaim').find('.after-submit').show()
            $('.hand-loading').fadeOut(200)
            resend_mail_countdown()
          else if result.msg isnt ''
            showSmallErrorTip(result.msg)
            $('.hand-loading').hide(200)
        error: ->
#          showSmallErrorTip('操作失败，请稍后重新尝试')
          $('.hand-loading').hide(200)
      }

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

  # 刷新郵件重置密碼表單
  $(document).on 'click', '.refresh-mail-reclaim', ->
    $('#form-mail-reclaim').find('a.captcha').refresh_captcha()
    $('#form-mail-reclaim').find('.before-submit').show()
    $('#form-mail-reclaim').find('.after-submit').hide()

  # -------------------------- 郵件修改密碼 - END -------------------------


  # -------------------------- 手機修改密碼 - START -------------------------

  # 關閉手機找回密碼的驗證碼彈窗
  popup_phone_reclaim = $('#phoneReclaimPopup')

  show_phone_reclaim = (class_name)->
#    if popup_phone_reclaim.find('a.captcha').css('background-image') is 'none'
    popup_phone_reclaim.find('a.captcha').refresh_captcha()
    popup_phone_reclaim.find('input.captcha-input').val ''
    popup_phone_reclaim.find('input.phone-code-input').val ''
    popup_phone_reclaim.find('button.send-code').show()
    popup_phone_reclaim.find('.phone-code-input-row').hide()
    popup_phone_reclaim.find('h5.resend-code').hide()
    popup_phone_reclaim.find('button.submit-reclaim').hide()
    if checkIE()
      popup_phone_reclaim.changePopupPosForIE()
    popup_phone_reclaim.fadeIn(200)
    popup_phone_reclaim.find('button.submit-reclaim').removeClass('submit-phone-reclaim').removeClass('submit-phone-changed')
    popup_phone_reclaim.find('button.submit-reclaim').addClass(class_name)

#   關閉手機找回密碼的彈窗
  popup_phone_reclaim.find('.close-popup').click ->
    popup_phone_reclaim.fadeOut(200)


  # 手機找回密碼提交
  $('#popMobileCaptcha').click ->
    user_phone = $('#form-phone-reclaim').find('input.input-phone').val()
    user_pass = $('#form-phone-reclaim').find('input.input-password').val()
    user_pass_again = $('#form-phone-reclaim').find('input.input-password-again').val()

    if user_phone is ''
      showFormError('请输入手机', 310, 45)
    else if !validateMobile(user_phone)
      showFormError('手机输入有误', 310, 45)
    else if user_pass is ''
      showFormError('请输入密码', 310, 100)
    else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
      showFormError('请输入6-12位密码', 310, 100)
    else if user_pass_again is ''
      showFormError('请重复输入密码', 310, 145)
    else if user_pass_again isnt user_pass
      showFormError('两次输入的密码不相同', 310, 145)
    else
      show_phone_reclaim('submit-phone-reclaim')

  # 发送手机验证码60秒倒计时
  phone_resend_code_count_down = (sec)->
    resend_text = popup_phone_reclaim.find('h5.resend-code')
    sec = sec || 60
    sec--
    if sec > 0
      resend_text.html(sec + '秒后重新发送验证码')
      setTimeout(->
        phone_resend_code_count_down(sec)
      , 1000)
    else
      resend_text.html("<a class='text click-to-resend'>重新发送</a>验证码")

  # 發送手機驗證碼請求
  send_phone_code = (phone,captcha,type)->
    $('.hand-loading').show()
    $.ajax {
      url: SITE_URL +'services/service.php',
      type: "GET",
      data: {m: 'user', a: 'get_mobile_verify', ajax: 1, mobile: phone, code: captcha, type: type},
      cache: false,
      dataType: "json",
      success: (result)->
        $('.hand-loading').hide()
        switch result.stauts
          when -10 # 短信验证码已经发送
            phone_resend_code_count_down()
            showSmallErrorTip '已发送验证码到你的手机'
          when -11 # 短信验证码发送失败
            showSmallErrorTip '短信验证码发送失败'
          else
            if result.msg != ''
              showSmallErrorTip result.msg
      error: ->
        $('.hand-loading').hide()
        showSmallErrorTip '系统异常，请稍后重试'
    }

  # 手機彈出框輸入驗證碼
  popup_phone_reclaim.find('button.send-code').click ->
    captcha = popup_phone_reclaim.find('.captcha-input').val()
    type = ''
    if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-reclaim')
      user_phone = $('#form-phone-reclaim').find('.input-phone').val()
    else if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-changed')
      user_phone = $('#form-phone-changed').find('.input-new-phone').val()
      type = 'reg'

    if captcha is ''
      showSmallErrorTip('请输入验证码')
    else if captcha.length > 0 && captcha.length isnt 5
      showSmallErrorTip('验证码不正确')
    else
      popup_phone_reclaim.find('button.send-code').hide()
      popup_phone_reclaim.find('h5.resend-code').show()
      popup_phone_reclaim.find('.phone-code-input-row').show()
      popup_phone_reclaim.find('button.submit-reclaim').show()
      send_phone_code(user_phone,captcha,type)

  # 重新发送验证码
  $(document).on 'click','#phoneReclaimPopup h5.resend-code a', ->
    captcha = popup_phone_reclaim.find('.captcha-input').val()
    type = ''
    if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-reclaim')
      user_phone = $('#form-phone-reclaim').find('.input-phone').val()
    else if $(this).parent().find('button.submit-reclaim').hasClass('submit-phone-changed')
      user_phone = $('#form-phone-changed').find('.input-new-phone').val()
      type = 'reg'

    if captcha is '' or captcha.length isnt 5
      showSmallErrorTip '验证码不正确'
    else
      send_phone_code(user_phone,captcha,type)

  # 重置成功后的3秒倒计时
  reset_success_count_down = (sec)->
    sec = sec || 4
    sec--
    if sec > 0
      $('.popup-content').find('h5').html(sec + ' 秒后自动跳转')
      setTimeout(->
        reset_success_count_down(sec)
      , 1000)
    else
      window.location.href = $('.popup-content').attr('data-redir')

  # 成功後的操作
  after_submit_success = (phone,url)->
    $('.popup-content').attr('data-redir', url)
    $('.popup-content').find('p.title').html('已收到您的请求')
    $('.popup-content').find('button.send-code, button.submit-reclaim, div.input-row').hide()
    $('.popup-content').find('p.desc').html('我们将在1-2个工作日内审核完毕<br />结果将发送至手机<br/><span> ' + phone.substr(0,
        3) + '****' + phone.substr(-4)) + '</span>'
    $('.popup-content').find('p.desc').show()
    reset_success_count_down()

  # 提交手機更改密碼
  $(document).on 'click','.submit-phone-reclaim', ->
    this_popup = popup_phone_reclaim
    form_phone_reclaim = $('#form-phone-reclaim')
    phone_code = this_popup.find('input.phone-code-input').val()
    user_phone = form_phone_reclaim.find('input.input-phone').val()
    user_pass = form_phone_reclaim.find('input.input-password').val()
    user_pass_again = form_phone_reclaim.find('input.input-password-again').val()
    if phone_code is ''
      showSmallErrorTip('请输入手机验证码')
    else if phone_code.length > 0 && phone_code.length isnt 5
      showSmallErrorTip('验证码不正确')
    else
      $('.hand-loading').show()
      query = new Object()
      query.account = user_phone
      query.password = user_pass
      query.password2 = user_pass_again
      query.code = ''
      query.rcode = phone_code

      $.ajax {
        url: SITE_URL +'services/service.php?m=user&a=resetapply',
        type: "POST",
        data: query,
        cache: false,
        dataType: "json",
        success: (result)->
          $('.hand-loading').hide()
          switch result.status
            when 1
              after_submit_success(user_phone,result.success_url)
            when -12 # 无效的短信验证码
              showSmallErrorTip '短信验证码错误，请重新输入'
            else
              if result.msg != ''
                showSmallErrorTip result.msg
        error: ->
          $('.hand-loading').hide()
          showSmallErrorTip '系统异常，请稍后重试'
      }

  # -------------------------- 手機修改密碼 - END -------------------------


  # -------------------------- 換了手機號碼 - START -------------------------

  form_phone_changed = $('#form-phone-changed')
  popup_phone_changed = $('#phoneChangedPopup')

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

  # 點擊下拉菜單按鈕
  dd_trigger = $('#form-phone-changed').find('.dropdown-trigger')
  dd_trigger.click ->
    location_dd.show()
  # 離開下拉菜單
  location_dd.mouseleave ->
    dd_trigger.blur()
    selected_region_input.val selected_region_text.text()
    location_dd.hide()

  $('#popPhoneChangedCaptcha').click ->
    user_phone_old = form_phone_changed.find('.input-phone').val()
    user_phone_new = form_phone_changed.find('.input-new-phone').val()
    user_password = form_phone_changed.find('.input-password').val()
    user_password_again = form_phone_changed.find('.input-password-again').val()
#    user_province = selected_region_input.attr 'data-province'
    user_city = selected_region_input.attr 'data-city'
    if user_phone_old is ''
      showFormError('请输入旧号码', 310, 45)
    else if !validateMobile(user_phone_old)
      showFormError('旧号码输入有误', 310, 45)
    else if user_phone_new is ''
      showFormError('请输入新号码', 310, 100)
    else if !validateMobile(user_phone_new)
      showFormError('新号码输入有误', 310, 100)
    else if user_city is '0'
      showFormError('请选择完整省市',310,152)
    else if user_password is ''
      showFormError('请输入密码', 310, 204)
    else if user_password.length > 0 && (user_password.length < 6 || user_password.length > 20)
      showFormError('请输入6-12位密码', 310, 204)
    else if user_password_again is ''
      showFormError('请重复输入密码', 310, 256)
    else if user_password_again isnt user_password
      showFormError('两次输入的密码不相同', 310, 256)
    else
      show_phone_reclaim('submit-phone-changed')

  # 提交手機更改密碼
  $(document).on 'click','.submit-phone-changed', ->
    this_popup = $(this).parent()
    user_phone_old = form_phone_changed.find('.input-phone').val()
    user_phone_new = form_phone_changed.find('.input-new-phone').val()
    user_password = form_phone_changed.find('.input-password').val()
    user_password_again = form_phone_changed.find('.input-password-again').val()
    user_province = selected_region_input.attr 'data-province'
    user_city = selected_region_input.attr 'data-city'
    phone_code = popup_phone_reclaim.find('input.phone-code-input').val()
    if phone_code is ''
      showSmallErrorTip('请输入手机验证码')
    else if phone_code.length > 0 && phone_code.length isnt 5
      showSmallErrorTip('验证码不正确')
    else
      query = new Object()
      query.mobile_old = user_phone_old
      query.mobile = user_phone_new
      query.province = user_province
      query.city = user_city
      query.password = user_password
      query.password2 = user_password_again
      query.rcode = phone_code

      this_popup.attr('data-redir', 'http')
      this_popup.find('p.title').html('已收到您的请求')
      this_popup.find('button.send-code, button.submit-reclaim, h5, div.input-row').hide()
      this_popup.find('p.desc').show()
      this_popup.find('p.desc').html('我们将在1-2个工作日内审核完毕<br />结果将发送至手机 ' + user_phone_new.substr(0,
          3) + '****' + user_phone_new.substr(-4))
      reset_success_count_down()

      $.ajax {
        url: SITE_URL +'services/service.php?m=user&a=resetapply',
        type: "POST",
        data: query,
        cache: false,
        dataType: "json",
        success: (result)->
          switch result.status
            when 1
              after_submit_success user_phone_new, result.success_url
            when -12 # 无效的短信验证码
              showSmallErrorTip '短信验证码错误，请重新输入'
            else
              if result.msg != ''
                showSmallErrorTip result.msg
        error: ->
          $('.hand-loading').hide()
          showSmallErrorTip '系统异常，请稍后重试'
      }

  # -------------------------- 換了手機號碼 - END -------------------------