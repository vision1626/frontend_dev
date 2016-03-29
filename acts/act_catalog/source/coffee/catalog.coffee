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
  $intro_acts   = $intro.find '.after-acts'
  $intro_inst   = $intro.find '.instruction'
  $view_code    = $intro.find '.view-code'
  $view_winners = $intro.find '.view-winners'

  $logos = $app.find 'section.logos'

  $draw = $app.find 'section.draw'
  $scratch = $draw.find '.scratch'
  $code = $scratch.find '.success span'

  $actions    = $app.find 'section.actions'
  $number     = $actions.find '.remain h1 span'
  $btn_share  = $actions.find 'a.share'
  $btn_again  = $actions.find 'a.again'

  $form = $app.find 'section.form'
  $input_name       = $form.find 'input.name'
  $input_mobile     = $form.find 'input.mobile'
  $input_mail       = $form.find 'input.mail'
  $input_pid        = $form.find 'input.pid'
  $submit_btn       = $form.find '#submit_button'
  $user_form        = $form.find 'form.user_form'
  $before_submit    = $form.find '.before-submit'
  $after_submit     = $form.find '.after-submit'
  $before_announce  = $form.find '.before-announce'

  $popup = $app.find 'section.popup'
  $close_popup = $popup.find 'button.close'

  $instruction = $app.find 'section.instruction'

  _scratch_is_finished = false
  _selected_city = '0'

  $winners = $app.find 'section.winners'

  # AWARD_STATUS '1' 已中奖未填资料，跳去表单
  # AWARD_STATUS '2' 已中奖已填资料，跳去邀请码
  # AWARD_STATUS '0' 未玩过
#  AWARD_CODE = '09'
#  AWARD_STATUS = '1'
#  AWARD_LOCAL = '2'

#  IS_SUBMITTED = '1'
#  IS_OFF = '1'

#  if AWARD_STATUS isnt '0'
#    $btn_mycode.show()
#  $btn_mycode.click ->
#    justShowMyCode()

  if WINNERS isnt 'null' and WINNERS isnt '' and IS_OFF is '1'
    initWinners(WINNERS)

#  initWinners(WINNERS)

  if IS_OFF is '0'
    $intro_city.show()
    $intro_title.find('img.flash').attr 'src',"#{SITE_URL}/tpl/hi1626/images/act/catalog/title-2-bg.png"
  else if IS_OFF is '1'
    $intro_acts.show()
    $intro_title.find('img.flash').attr 'src',"#{SITE_URL}/tpl/hi1626/images/act/catalog/title-end.png"
    $intro_desc.hide()

  $btn_city.click ->
    if IS_SUBMITTED is '0'
      $btn = $(this)
      if $btn.hasClass 'beijing'
        _selected_city = '1'
      else
        _selected_city = '2'
      motionIntroToForm()
    else if IS_SUBMITTED is '1'
      motionIntroFade()
      setTimeout ->
        $form.show()
        $before_submit.hide()
        $before_announce.addClass 'show'
      , 200

#  $view_code.click ->
#    justShowMyCode()

  $view_winners.click ->
    motionIntroFade()
    setTimeout ->
      $winners.show().addClass('show')
    , 200

#  justShowMyCode = ->
#    $code.text AWARD_CODE
#    $scratch.find('.scratch-cover').hide()
#    $scratch.find('.success').show()
#    $actions.hide()
#    $form.css 'margin-top','64%'
#    motionIntroToCode(AWARD_STATUS,AWARD_LOCAL)

#  getChance = (city)->
#    $.ajax {
#      url: SITE_URL + 'catalog/get_award.html'
#      type: "GET"
#      data: {'location': city}
#      cache: true
#      dataType: "json"
#      success: (msg, status)->
#        rest = msg.chances
#        rest = 0
#        code = msg.award
#        code = '09'
##        a_status = '1'
#        status = -1
#
#        $number.text(rest)
#        switch status
##          when 0 # 已中大奖
##            $code.text code
##            $scratch.find('.scratch-cover').hide()
##            $scratch.find('.success').show()
##            $actions.hide()
##            # if a_status is '2' #未填資料
##            # if a_status is '1' #已填資料
##            motionIntroToCode(a_status,city)
#          when 1 # 中大奖了
#            $scratch.find('.success').show()
#            $code.text code
#            motionIntroToDraw(true)
#          when -2 # 抽不到
#            $scratch.find('.fail').show()
#            motionIntroToDraw(false)
#          when -1 # 机会用光了
#            $scratch.find('.scratch-cover').hide()
#            $scratch.find('.fail').show()
#            $actions.show()
#            motionIntroToCode('-1',city)
#
#      error: (xhr, status, error)->
#        if status is 502
#          alert('服务器君跑到外太空去了,刷新试试看!')
#    }

  motionIntroFade = ->
    ele = $([$intro_title,$intro_shoe,$intro_desc,$intro_city,$intro_acts,$intro_inst,$btn_mycode])
    ele.each ->
      $(this).addClass 'leave'
    $logos.addClass 'center'

  # 过渡：开始抽奖 ----------------------------------------
#  motionIntroToDraw = (is_winner)->
#    motionIntroFade()
#
#    $('.scratch-cover').eraser({
#      progressFunction: (p)->
#        if p > 0.66
#          afterScratch(is_winner)
#    })
#
#    ele = $([$draw, $actions])
#    ele.each ->
#      $(this).show()
#      $(this).addClass 'show'


  # 过渡：已中大奖 or 機會用光----------------------------------------
#  motionIntroToCode = (a_status,city)->
#    motionIntroFade()
#    setTimeout ->
#      $draw.show().addClass('show')
#    , 200
#    setTimeout ->
#      if a_status is '2'
#        motionDrawSuccess()
#      else if a_status is '1'
#        $draw.find('.result').addClass('show')
#        $form.show()
#        $before_submit.hide()
#        showShopDetail(city)
#      else if a_status is '-1'
#        $actions.addClass 'show'
#        setTimeout ->
#          $actions.find('.again').addClass('show')
#        , 400
#    , 800

#  motionIntroToCode = (city)->
#    motionIntroFade()
#    setTimeout ->
#      $draw.show().addClass('show')
#    , 200
#    setTimeout ->
#      $draw.find('.result').addClass('show')
#      $form.show()
#      $before_submit.hide()
#      showShopDetail(city)
#    , 800

  motionIntroToForm = ->
    motionIntroFade()
    setTimeout ->
      $actions.find('.remain').addClass('hide')
      $form.show()
      $before_submit.addClass('show')
    , 200

#  afterScratch = (is_winner)->
#    if !_scratch_is_finished
#      changeRemainNumber()
#      if is_winner
#        motionDrawSuccess()
#      else
#        motionDrawFail()

#  changeRemainNumber = ->
#    _scratch_is_finished = true
#    num = parseInt($number.text())
#    num--
#    $number.addClass 'fade-out'
#    setTimeout ->
#      $number.text num
#      $number.removeClass 'fade-out'
#    ,200
#
#  motionDrawSuccess = ->
#    $draw.find('.result').addClass('show')
#    $actions.find('.remain').addClass('hide')
#    $form.show()
#    $before_submit.addClass('show')
#
#  motionDrawFail = ->
#    $actions.find('article.again').addClass('show')

  _form_is_submitting = false
  $submit_btn.click ->
#    submitSuccess()
    if !_form_is_submitting
      str = formValidate($input_name,$input_mobile,$input_mail)
      if str is ''
        submitForm()
      else
        alert str

#  alert SITE_URL + 'catalog/submit.html'
#  false

  submitForm = ->
    _form_is_submitting = true
    $user_form.css 'opacity', .3
    name = $.trim($input_name.val())
    mobile = $.trim($input_mobile.val())
    email = $input_mail.val()
#    pid = $.trim($input_pid.val())
    $.ajax {
      url: SITE_URL + 'catalog/submit.html'
      type: "GET"
      data: {'name':name, 'mobile':mobile, 'email':email, 'location':parseInt(_selected_city)}
      dataType: "json"
      success: (result)->
        _form_is_submitting = false
        if result.status is 1
          submitSuccess()
        else
          $user_form.css 'opacity', 1
          alert result.msg
      error: (xhr, status, error)->
        _form_is_submitting = false
        $user_form.css 'opacity', 1
        alert '服务器君跑到外太空去了,刷新试试看!'
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
    }

  submitSuccess = ()->
    $before_announce.addClass 'show'
    $before_submit.addClass 'leave'

#  showShopDetail = (city)->
#    if city is '1'
#      $after_submit.find('.beijing').show()
#    else
#      $after_submit.find('.shanghai').show()
#    $after_submit.addClass 'show'

#  $btn_share.click ->
#    $popup.find('.text--share').show()
#    $popup.fadeIn()
#  $btn_again.click ->
#    if parseInt($number.text()) > 0
#      $scratch.addClass 'to-play-again'
#      $actions.find('article.again').addClass('slide-out').removeClass('show')
#
#      setTimeout ->
#        $('.scratch-cover').remove()
##        $scratch.append('<img class="scratch-cover" src="../../../img/act/catalog/draw-cover.jpg" />')
#        $scratch.append("<img class='scratch-cover' src='#{SITE_URL}/tpl/hi1626/images/act/catalog/draw-cover.jpg'/>")
#        $actions.find('article.again').removeClass('slide-out')
#      , 400
#      setTimeout ->
#        _scratch_is_finished = false
#        $scratch.find('.scratch-cover').eraser({
#          progressFunction: (p)->
#            if p > 0.66
#              afterScratch()
#        })
#        $scratch.removeClass 'to-play-again'
#      , 900
#    else
#      $popup.find('.text--ask').show()
#      $popup.fadeIn()

  $close_popup.click ->
    $popup.fadeOut()
    $popup.find('.text--share').hide()
    $popup.find('.text--ask').hide()

  $intro_inst.click ->
    $instruction.addClass 'show'
  $before_announce.find('a.button').click ->
    $instruction.addClass 'show'
  $instruction.find('a.close').click ->
    $instruction.removeClass 'show'
    $instruction.scrollTop(0)