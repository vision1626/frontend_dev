_step = -2
_q_n= 0
_done = 0
_score = 0
_not_answer = false
_image_path  = './tpl/hi1626/images/starwars/'
_virgin = true
_waittime = 1000

_mobile_empty_msg = '请输入电话号码'
_mobile_error_msg = '请输入正确的电话号码'
_name_empty_msg = '请输入姓名'
_name_error_msg = '请输入正确的姓名,仅支持中英文'
#_not_show_prize = true

init = ->
#  alert(navigator.userAgent)
  _virgin = parseInt(window.virgin_score) is -1
  set_step(_step)
#  set_step(3)

#$('.nexstep').click ->
#  alert('n2')
#  step = $(this).attr('s')
#  set_step(parseInt(step))

$(document).on 'click','.nexstep', ->
  step = $(this).attr('s')
  set_step(parseInt(step))

$(document).on 'click','.select_answer', ->
  me = $(this)
  my_select = me.attr('a')
  q = question_list[_q_n]
  if _not_answer
    _not_answer = false
    me.find('span').html('')
    if parseInt(my_select) is parseInt(q.answer)
      me.addClass "right"
      me.find('span').addClass('icon').addClass('icon-tick')
      _score += 1
    else
      me.addClass "wrong"
      me.find('span').addClass('icon').addClass('icon-cross')
    setTimeout ->
      if _q_n < question_list.length-1
        _q_n += 1
        me.removeClass('right').removeClass('wrong')
        me.find('span').removeClass('icon').removeClass('icon-tick').removeClass('icon-cross')
        if _q_n is 3 or _q_n is 6
          set_step(2)
        else
          set_question()
      else
        set_step(3)
    , _waittime

$('.hide_prize').click ->
  toggle_prize()

$(document).on 'click','.show_prize', ->
  toggle_prize()

$(document).on 'click','.share_now', ->
  $('.share_mask').show()

$(document).on 'click','.alert_mask', ->
  close_alert()

$('.alert_mask').click ->
  close_alert()

$(document).on 'click','.share_mask', ->
  $('.share_mask').hide()

$('.share_mask').click ->
  $('.share_mask').hide()

#$(document).on 'click','#submit_button', ->
#  before_submit()
##  after_submit()

$('#submit_button').click ->
  before_submit()
#  after_submit()

#$('#copy_button').click ->
#  $(this).zclip
#
#$('#copy_button').zclip ->
#  path: './public/js/ZeroClipboard.swf'
#  copy: ->
#    'what the f**k!'
#  beforeCopy: ->
#    alert('before')
#  afterCopy: ->
#    alert('copy done')

$(document).on 'focus','input', ->
  me = $(this)
  me.removeClass('error')
  if me.hasClass('empty')
    me.val('')
  else
    this.select()

#$('#key_text').click ->
#  this.contents().find('body').select()

#$(document).on 'click','#key_text', ->
#  this.contents().find('body').select()

$(document).on 'change','textarea', ->
  set_result(parseInt(window.virgin_score))

$(document).on 'blur','input', ->
  me = $(this)
  if me.val() isnt ''
    me.removeClass('empty')

    if me.hasClass('mobile')
      if !validateMobile(me.val())
        me.addClass('error')
    if me.hasClass('name')
      if !validateNickname(me.val())
        me.addClass('error')
  else
    me.addClass('empty')
    me.val(me.attr('ev'))

before_submit = () ->
  result = $('#result')
  alert_message = []
  input_mobile = result.find('.user_form').find('input.mobile')
  input_name = result.find('.user_form').find('input.name')

  if input_mobile.hasClass('empty')
    alert_message.push(_mobile_empty_msg)
  else if input_mobile.hasClass('error')
    alert_message.push(_mobile_error_msg)

  if input_name.hasClass('empty')
    alert_message.push(_name_empty_msg)
  else if input_name.hasClass('error')
    alert_message.push(_name_error_msg)

  if alert_message.length > 0
    show_alert(alert_message,'error')
  else
#    name = '丢那星'
    name = input_name.val()
#    mobile = '13800238000'
    mobile = input_mobile.val()
    $.ajax {
      url: SITE_URL + 'starwars/submit.html'
      type: "GET"
      data: {'name': name, 'mobile': mobile, 'score': _score}
      cache: false
      dataType: "json"
      success: (result)->
        if result.status is 1
          after_submit()
        else
          alert_message.push(result.msg)
          show_alert(alert_message,'error')
      error: (result)->
        alert_message.push('网络超时')
        show_alert(alert_message,'error')
    }

show_alert = (msg_list,type) ->
  alert_box = $('.alert_mask')
  if msg_list.length > 1
    msg = msg_list.join('<br>')
  else
    msg = msg_list[0]
  alert_message = alert_box.find('.alert_message').find('span')
  alert_message.html('').html(msg)
  if type
    alert_box.find('.alert_message').addClass(type)
  alert_box.show()

close_alert = () ->
  alert_box = $('.alert_mask')
  alert_box.find('.alert_message').removeClass('error').removeClass('alert')
  alert_box.hide()

set_step = (step) ->
  _step = step
  views = $('.view')
  eye_top = $('.eye_top')
  eye_bottom = $('.eye_bottom')
  outside = $('#outside')
  entrance = $('#entrance')
  start = $('#startquestion')
  questions = $('#questions')
  help = $('#help')
  show = $('#show')
  result = $('#result')

  views.hide()
  switch step
    when -1
#      eye_top.animate({height:'0'},1000)
      eye_top.addClass 'open_position2'
#      eye_bottom.animate({height:'0'},1000)
      eye_bottom.addClass 'open_position2'
      entrance.fadeIn 0
    when 0
      info_text = start.find('div.in')
      start.fadeIn 0
      info_text.animate({top:'-900px'},50000,'linear')
#        text_animate(info_text,400,-700)
    when 1
      questions.fadeIn 0
      set_question()
    when 2
      help_img = help.find('.help_img').find('img')
      if _q_n is 3
        help_img.attr('src',_image_path + 'help1.png')
      else
        help_img.attr('src',_image_path + 'help2.png')
      help.fadeIn 0
    when 3
      eye_top.hide()
      eye_bottom.hide()

      if _virgin
        result.find('.first_complete').show()
        result.find('.all_completion').hide()
        set_result(_score)
        result.fadeIn 0, ->
          if _score > 0
            setTimeout ->
              result.find('.light_body').addClass(['l',_score].join(''))
            , 500
      else
        result.fadeIn 0, ->
          set_result(parseInt(window.virgin_score))
          after_submit();
    else
      logo = outside.find('img')
      present = outside.find('h3')

      outside.fadeIn 0
      setTimeout ->
        eye_top.addClass 'open_position1'
#        eye_top.animate({height:'33%'},1000)
        eye_bottom.addClass 'open_position1'
#        eye_bottom.animate({height:'33%'},1000)
        present.addClass 'show'
#        present.animate({opacity:'1'},1000)
        logo.addClass 'show'
#        logo.animate({opacity:'1'},1000)
        setTimeout ->
          eye_top.removeClass 'open_position1'
#          eye_top.animate({height:'100%'},1000)
          eye_bottom.removeClass 'open_position1'
#          eye_bottom.animate({height:'100%'},1000)
          present.removeClass 'show'
#          present.animate({opacity:'0'},1000)
          logo.removeClass 'show'
#          logo.animate({opacity:'0'},1000)
          setTimeout ->
            set_step(-1)
          , 300
        , 2500
      , 300

set_result = (score) ->
  result = $('#result')
  desc1 = result.find('.first_complete').find('span.d1')
  desc2 = result.find('.first_complete').find('span.d2')
  tb_key = result.find('.key_text').find('textarea')
  rank = 0

  if score >= 3 and score <= 5
    rank = 1
  else if score >= 6 and score <= 7
    rank = 2

  desc1.html(reward_list[rank].description1)
  desc2.html(reward_list[rank].description2)
  tb_key.val(reward_list[rank].tb_key)
#  tb_key.contents().find('body').append(reward_list[rank].tb_key)

after_submit = () ->
  if _virgin
    window.virgin_score = _score
    _virgin = false
  result = $('#result')
  result.find('.first_complete').hide()
  result.find('.all_completion').show()

toggle_prize = () ->
  prize = $('#prize')
  if prize.hasClass('showout')
    prize.removeClass 'showout'
    prize.hide()
  else
    prize.show 0, ->
      prize.addClass 'showout'

set_question = () ->
  _not_answer = true
  questions = $('#questions')
  q = question_list[_q_n]
  questions.find('.question_no').find('span').html(q.num)
  questions.find('.question_content').find('span').html(decodeURIComponent(q.content))
  questions.find('.question_answer').find('.answer1').find('span').html(q.options[1])
  questions.find('.question_answer').find('.answer2').find('span').html(q.options[2])


