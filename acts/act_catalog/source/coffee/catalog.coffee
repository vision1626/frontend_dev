init = ->
  $app = $('#catalog')
  $input_name     = $app.find 'input.name'
  $input_mobile   = $app.find 'input.mobile'
  $input_mail     = $app.find 'input.mail'
  $input_pid      = $app.find 'input.pid'

  $submit_btn     = $app.find '.submit_button'

  $('img.scratch-cover').eraser()

  $submit_btn.click ->
    formValidate($input_name,$input_mobile,$input_mail,$input_pid)