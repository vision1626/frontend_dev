_step = -2
_q_n= 0
_done = 0
_score = 7
_not_answer = false
_image_path  = './tpl/hi1626/images/starwars/'
_virgin = true
_waittime = 1000
#_not_show_prize = true

init = ->
#  set_step(_step)
  set_step(3)

$(document).on 'click','.nexstep', ->
  _virgin = parseInt(window.virgin_score) is -1

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
      me.find('span').addClass('icon').addClass('icon-glad')
      _score += 1
    else
      me.addClass "wrong"
      me.find('span').addClass('icon').addClass('icon-sad')
#    setTimeout ->
    if _q_n < question_list.length-1
      _q_n += 1
      me.removeClass('right').removeClass('wrong')
      me.find('span').removeClass('icon').removeClass('icon-glad').removeClass('icon-sad')
      if _q_n is 3 or _q_n is 6
        set_step(2)
      else
        set_question()
    else
      set_step(3)
#    , _waittime

$('.hide_prize').click ->
  toggle_prize()

$(document).on 'click','.show_prize', ->
  toggle_prize()

$(document).on 'click','.share_now', ->
#  $('.alert_mask').show()
  $('.share_mask').show()

$('.alert_mask').click ->
  $('.alert_mask').hide()

$('.share_mask').click ->
  $('.share_mask').hide()

#$(document).on 'click','.submit_button', ->
$('#submit_button').click ->
  name = '丢那星'
  mobile = '13800238000'
  $.ajax {
    url: SITE_URL + 'starwars/submit.html'
    type: "GET"
    data: {'name': name, 'mobile': mobile, 'score': _score}
    cache: false
    dataType: "json"
    success: (result)->
      alert(result.msg)
      after_submit()
    error: (result)->
      alert('errr: ' + result)
  }

$('#copy_button').click ->
  $(this).zclip

$('#copy_button').zclip ->
  path: './public/js/ZeroClipboard.swf'
  copy: ->
    'what the f**k!'
  beforeCopy: ->
    alert('before')
  afterCopy: ->
    alert('copy done')

$(document).on 'focus','input', ->
  me = $(this)
  me.removeClass('error')
  if me.hasClass('empty')
    me.val('')
  else
    this.select()

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

  views.fadeOut 0, ->
    switch step
      when -1
        eye_top.addClass 'open_top2'
        eye_bottom.addClass 'open_bottom2'
        entrance.fadeIn 0
      when 0
        info_text = start.find('div.in')
        start.fadeIn 0
        info_text.animate({top:'-900px'},50000)
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
          result.find('.first_complete').hide()
          result.find('.all_completion').show()
          set_result(parseInt(window.virgin_score))
      else
        logo = outside.find('img')
        present = outside.find('h3')

        outside.fadeIn 0, ->
          setTimeout ->
            eye_top.addClass 'open_top1'
            eye_bottom.addClass 'open_bottom1'
            present.addClass 'show'
            logo.addClass 'show'
            setTimeout ->
              eye_top.removeClass 'open_top1'
              eye_bottom.removeClass 'open_bottom1'
              present.removeClass 'show'
              logo.removeClass 'show'
              setTimeout ->
                set_step(-1)
              , 1300
            , 2500
          , 300

set_result = (score) ->
  result = $('#result')
  desc1 = result.find('.first_complete').find('span.d1')
  desc2 = result.find('.first_complete').find('span.d2')
  tb_key = result.find('.key_text').find('span')
  rank = 0

  if score >= 3 and score <= 5
    rank = 1
  else if score >= 6 and score <= 7
    rank = 2

  desc1.html(reward_list[rank].description1)
  desc2.html(reward_list[rank].description2)
  tb_key.html(reward_list[rank].tb_key)

after_submit = () ->
  window.virgin_score = _score
  _virgin = false
  result = $('#result')
  result.find('.first_complete').hide()
  result.find('.all_completion').show()

toggle_prize = () ->
  prize = $('#prize')
  if prize.hasClass('showout')
    prize.removeClass 'showout', ->
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


