init = ->
  initTouch()

  $app = $('#catalog')

  $intro        = $app.find 'section.intro'
  $btn_city     = $intro.find '.cities a'
  $btn_bj       = $intro.find 'a.beijing'
  $btn_sh       = $intro.find 'a.shanghai'
  $btn_mycode   = $intro.find '.my-code'
  $intro_title  = $intro.find '.title'
  $intro_shoe   = $intro.find '.shoe'
  $intro_desc   = $intro.find '.desc'
  $intro_city   = $intro.find '.select-city'
  $intro_inst   = $intro.find '.instruction'

  $logos = $app.find 'section.logos'

  $draw = $app.find 'section.draw'
  $scratch = $draw.find '.scratch'
  $code = $scratch.find '.success span'

  $actions    = $app.find 'section.actions'
  $number     = $actions.find '.remain h1 span'
  $btn_share  = $actions.find 'a.share'
  $btn_again  = $actions.find 'a.again'

  $form = $app.find 'section.form'
  $input_name     = $form.find 'input.name'
  $input_mobile   = $form.find 'input.mobile'
  $input_mail     = $form.find 'input.mail'
  $input_pid      = $form.find 'input.pid'
  $submit_btn     = $form.find '#submit_button'
  $user_form      = $form.find 'form.user_form'
  $before_submit  = $form.find '.before-submit'
  $after_submit   = $form.find '.after-submit'

  $popup = $app.find 'section.popup'
  $close_popup = $popup.find 'button.close'

  $instruction = $app.find 'section.instruction'

  _scratch_is_finished = false

  # AWARD_STATUS '1' 已中奖未填资料，跳去表单
  # AWARD_STATUS '2' 已中奖已填资料，跳去邀请码
  # AWARD_STATUS '0' 未玩过
  AWARD_CODE = '09'
  AWARD_STATUS = '0'
  AWARD_LOCAL = '2'

  if AWARD_STATUS isnt '0'
    $btn_mycode.show()
  $btn_mycode.click ->
    justShowMyCode()

  $btn_city.click ->
    $btn = $(this)
    if $btn.hasClass 'beijing'
      window.city = '1'
    else
      window.city = '2'

    if AWARD_STATUS is '0'
      getChance(window.city)
    else
      justShowMyCode()

  justShowMyCode = ->
    $code.text AWARD_CODE
    $scratch.find('.scratch-cover').hide()
    $scratch.find('.success').show()
    $actions.hide()
    motionIntroToCode(AWARD_STATUS,AWARD_LOCAL)

  getChance = (city)->
    $.ajax {
      url: SITE_URL + 'catalog/get_award.html'
      type: "GET"
      data: {'location': city}
      cache: true
      dataType: "json"
      success: (msg, status)->
        rest = msg.chances
        rest = 0
        code = msg.award
        code = '09'
#        a_status = '1'
        status = -1

        $number.text(rest)
        switch status
#          when 0 # 已中大奖
#            $code.text code
#            $scratch.find('.scratch-cover').hide()
#            $scratch.find('.success').show()
#            $actions.hide()
#            # if a_status is '2' #未填資料
#            # if a_status is '1' #已填資料
#            motionIntroToCode(a_status,city)
          when 1 # 中大奖了
            $scratch.find('.success').show()
            $code.text code
            motionIntroToDraw(true)
          when -2 # 抽不到
            $scratch.find('.fail').show()
            motionIntroToDraw(false)
          when -1 # 机会用光了
            $scratch.find('.scratch-cover').hide()
            $scratch.find('.fail').show()
            $actions.show()
            motionIntroToCode('-1',city)

      error: (xhr, status, error)->
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
    }

  motionIntroFade = ->
    ele = $([$intro_title,$intro_shoe,$intro_desc,$intro_city,$intro_inst,$btn_mycode])
    ele.each ->
      $(this).addClass 'leave'
    $logos.addClass 'center'

  # 过渡：开始抽奖 ----------------------------------------
  motionIntroToDraw = (is_winner)->
    motionIntroFade()

    $('.scratch-cover').eraser({
      progressFunction: (p)->
        if p > 0.66
          afterScratch(is_winner)
    })

    ele = $([$draw, $actions])
    ele.each ->
      $(this).show()
      $(this).addClass 'show'


  # 过渡：已中大奖 or 機會用光----------------------------------------
  motionIntroToCode = (a_status,city)->
    motionIntroFade()
    setTimeout ->
      $draw.show().addClass('show')
    , 200
    setTimeout ->
      if a_status is '2'
        motionDrawSuccess()
      else if a_status is '1'
        $draw.find('.result').addClass('show')
        $form.show()
        $before_submit.hide()
        submitSuccess(city)
      else if a_status is '-1'
        $actions.addClass 'show'
        setTimeout ->
          $actions.find('.again').addClass('show')
        , 400
    , 800

  afterScratch = (is_winner)->
    if !_scratch_is_finished
      changeRemainNumber()
      if is_winner
        motionDrawSuccess()
      else
        motionDrawFail()

  changeRemainNumber = ->
    _scratch_is_finished = true
    num = parseInt($number.text())
    num--
    $number.addClass 'fade-out'
    setTimeout ->
      $number.text num
      $number.removeClass 'fade-out'
    ,200

  motionDrawSuccess = ->
    $draw.find('.result').addClass('show')
    $actions.find('.remain').addClass('hide')
    $form.show()
    $before_submit.addClass('show')

  motionDrawFail = ->
    $actions.find('article.again').addClass('show')

  _form_is_submitting = false
  $submit_btn.click ->
    if !_form_is_submitting
      formValidate($input_name,$input_mobile,$input_mail,$input_pid,submitForm())

  submitForm = ->
    _form_is_submitting = true
    $user_form.css 'opacity', .5
    name = $.trim($input_name.val())
    mobile = $.trim($input_mobile.val())
    email = $.trim($input_mail.val())
    pid = $.trim($input_pid.val())

    $.ajax {
      url: SITE_URL + 'catalog/submit.html'
      type: "POST"
      data: {'name':name, 'mobile':mobile, 'email':email, 'id':pid}
      cache: true
      dataType: "json"
      success: (msg, status)->
        _form_is_submitting = false
        if status is 1
          submitSuccess(window.city)
        else
          $user_form.css 'opacity', 1
          alert '请检查输入的信息'
      error: (xhr, status, error)->
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
    }

  submitSuccess = (city)->
    if city is '1'
      $after_submit.find('.beijing').show()
    else
      $after_submit.find('.shanghai').show()
    $after_submit.addClass 'show'
    $before_submit.addClass 'leave'


  $btn_share.click ->
    $popup.find('.text--share').show()
    $popup.fadeIn()
  $btn_again.click ->
    if parseInt($number.text()) > 0
      $scratch.addClass 'to-play-again'
      $actions.find('article.again').addClass('slide-out').removeClass('show')

      setTimeout ->
        $('.scratch-cover').remove()
#        $scratch.append('<img class="scratch-cover" src="../../../img/act/catalog/draw-cover.jpg" />')
        $scratch.append("<img class='scratch-cover' src='#{SITE_URL}/tpl/hi1626/images/act/catalog/draw-cover.jpg'/>")
        $actions.find('article.again').removeClass('slide-out')
      , 400
      setTimeout ->
        _scratch_is_finished = false
        $scratch.find('.scratch-cover').eraser({
          progressFunction: (p)->
            if p > 0.66
              afterScratch()
        })
        $scratch.removeClass 'to-play-again'
      , 900
    else
      $popup.find('.text--ask').show()
      $popup.fadeIn()

  $close_popup.click ->
    $popup.fadeOut()
    $popup.find('.text--share').hide()
    $popup.find('.text--ask').hide()

  $intro_inst.click ->
    $instruction.addClass 'show'
  $instruction.find('a.close').click ->
    $instruction.removeClass 'show'
    $instruction.scrollTop(0)