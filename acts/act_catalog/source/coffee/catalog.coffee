init = ->
  initTouch()

  $app = $('#catalog')

  $intro        = $app.find 'section.intro'
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

  $submit_btn.click ->
    submitForm()
#    formValidate($input_name,$input_mobile,$input_mail,$input_pid,submitForm())

  num = 3
  _scratch_is_finished = false
  $btn_bj.click ->
    $number.text num
    motionIntroToDraw()

  motionIntroToDraw = ->
    ele = $([$intro_title,$intro_shoe,$intro_desc,$intro_city,$intro_inst,$btn_mycode])
    ele.each ->
      $(this).addClass 'leave'
    $logos.addClass 'center'

    $('.scratch-cover').eraser({
      progressFunction: (p)->
        if p > 0.66
          afterScratch()
    })

    ele = $([$draw, $actions])
    ele.each ->
      $(this).show()
      $(this).addClass 'show'


  afterScratch = ->
    if !_scratch_is_finished
      changeRemainNumber()
      motionDrawFail()

  changeRemainNumber = ->
    _scratch_is_finished = true
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

  submitForm = ->
    submitSuccess()

  submitSuccess = ->
    $after_submit.addClass 'show'
    $before_submit.addClass 'leave'

  $btn_share.click ->
    $popup.find('.text--share').show()
    $popup.fadeIn()
  $btn_again.click ->
    if num > 0
      $scratch.addClass 'to-play-again'
      $actions.find('article.again').addClass('slide-out').removeClass('show')

      setTimeout ->
        $('.scratch-cover').remove()
        $scratch.append('<img class="scratch-cover" src="../../../img/act/catalog/draw-cover.jpg" />')
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
