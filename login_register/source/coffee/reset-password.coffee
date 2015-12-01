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

  # 鍵入，隱藏錯誤提示
  $('input[type=text],input[type=password]').on 'propertychange input', ->
    $('.form-error').fadeOut(300)

  # -------------------------- 重置密码 - START -------------------------

  form_reset = $('#form-reset')
  input_pass = form_reset.find('input.input-password')
  input_pass_again = form_reset.find('input.input-password-again')

  btn_reset_submit = form_reset.find 'button#submitReset'

  # 函數：激活/禁止提交按鈕
  disableBtnRstSubmit = ->
    btn_reset_submit.addClass('disabled').removeClass('always-blue')
  enableBtnRstSubmit = ->
    btn_reset_submit.removeClass('disabled').addClass('always-blue')

  # 函數：提交重置
  submitReset = (pass,pass_again)->
    $('.hand-loading').show()
    query = new Object()
    query.uid = uid
    query.password = pass
    query.confirm_password = pass_again
    $.ajax {
      url: SITE_URL + "services/service.php?m=user&a=resetpassword"
      type: "POST"
      data: query
      cache: false
      dataType: "json"
      success: (result)->
        $('.hand-loading').fadeOut(100)
        if(result.status == 0)
          showSmallErrorTip(result.msg)
        else
          showSmallErrorTip "重置密码成功", 1
          setTimeout(->
            window.location.href = result.success_url
          , 1000)
      error: ->
        showSmallErrorTip('操作失败，请稍后重新尝试')
        $('.hand-loading').fadeOut(100)
    }

  # 函數：檢查錄入
  validateResetForm = (submit_pressed,typing)->
    user_pass = $.trim(input_pass.val())
    user_pass_again = $.trim(input_pass_again.val())
    if !submit_pressed
      disableBtnRstSubmit()
      if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 45)
      else if typing is 1
        if user_pass_again isnt '' and user_pass_again is user_pass
          enableBtnRstSubmit()
      else if user_pass_again isnt ''
        if user_pass_again isnt user_pass
          showFormError('两次输入的密码不相同', 310, 100)
        else
          enableBtnRstSubmit()

    else
      if user_pass is ''
        showFormError('请输入密码', 310, 45)
      else if user_pass.length > 0 && (user_pass.length < 6 || user_pass.length > 20)
        showFormError('请输入6-12位密码', 310, 45)
      else if user_pass_again isnt user_pass
        showFormError('两次输入的密码不相同', 310, 100)
      else
        submitReset(user_pass,user_pass_again)

  # 動態檢查錄入
  input_pass.blur ->
    validateResetForm(false)
  input_pass_again.on 'propertychange input', ->
    validateResetForm(false,1)
  input_pass_again.blur ->
    validateResetForm(false)

  # 點擊提交登錄按鈕
  btn_reset_submit.click ->
    validateResetForm(true)

  # -------------------------- 重置密码 - END -------------------------


  # 偵測回車鍵
  $(document).keypress (e)->
    if(e.which == 13)
      validateResetForm(true)