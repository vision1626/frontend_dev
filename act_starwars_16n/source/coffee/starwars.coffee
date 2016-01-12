_step = -2
_q_n= 0
_done = 0
_score = 0
_not_answer = true

init = ->
  set_step(_step)

$(document).on 'click','.nexstep', ->
  step = $(this).attr('s')
  set_step(parseInt(step))

#$(document).on 'click','.change', ->
#  me = $(this)
#  if me.attr('c') is 'p'
#    if _q_n >= 0
#      _q_n -= 1
#      set_question()
#    else
#      _q_n = 0
#      set_question()
#  else
#    if _q_n <=6
#      _q_n += 1
#      set_question()
#    else
#      _q_n = 6
#      set_question()

$(document).on 'click','.select_answer', ->
  me = $(this)
  my_select = me.attr('a')
  q = question_list[_q_n]
  if _not_answer
    _not_answer = false
    me.find('span').html('')
    if parseInt(my_select) is parseInt(q.answer)
#      me.find('span').html("✔")
#      me.find('span').html("对滴")
      me.addClass "right"
      me.find('span').addClass('icon').addClass('icon-glad')
      _score += 1
    else
#      me.find('span').html("✘")
#      me.find('span').html("错啦")
      me.addClass "wrong"
      me.find('span').addClass('icon').addClass('icon-sad')
    setTimeout ->
      if _q_n < question_list.length-1
        _q_n += 1
        me.removeClass('right').removeClass('wrong')
        me.find('span').removeClass('icon').removeClass('icon-glad').removeClass('icon-sad')
        set_question()
      else
        alert(_score)
    , 2000


set_step = (step) ->
  _step = step
  views = $('.view')
  eye_top = $('.eye_top')
  eye_bottom = $('.eye_bottom')
  outside = $('#outside')
  entrance = $('#entrance')
  start = $('#startquestion')
  questions = $('#questions')

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

set_question = () ->
  _not_answer = true
  questions = $('#questions')
  q = question_list[_q_n]
#  selected = selected_answers[_q_n]
  questions.find('.question_no').find('span').html(q.num)
  questions.find('.question_content').find('span').html(decodeURIComponent(q.content))
#  if selected is 0
  questions.find('.question_answer').find('.answer1').find('span').html(q.options[1])
  questions.find('.question_answer').find('.answer2').find('span').html(q.options[2])
#  else
#    if selected is q.answer
#      q_result = "✔"
#    else
#      q_result = "✘"
#
#    if selected is 1
#      questions.find('.question_answer').find('.answer1').find('span').html(q_result)
#      questions.find('.question_answer').find('.answer2').find('span').html(q.options[2])
#    else if selected is 2
#      questions.find('.question_answer').find('.answer1').find('span').html(q.options[1])
#      questions.find('.question_answer').find('.answer2').find('span').html(q_result)

text_animate = (obj,begin,end) ->
  alert(obj.style.top)


