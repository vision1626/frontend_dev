_step = -2
_q_n= 0
_done = 0

init = ->
  set_step(_step)

$(document).on 'click','.nexstep', ->
  step = $(this).attr('s')
  set_step(parseInt(step))

$(document).on 'click','.change', ->
  me = $(this)
  if me.attr('c') is 'p'
    if _q_n >= 0
      _q_n -= 1
      set_question()
    else
      _q_n = 0
      set_question()
  else
    if _q_n <=6
      _q_n += 1
      set_question()
    else
      _q_n = 6
      set_question()

set_step = (step) ->
  _step = step
  views = $('.view')
  outside = $('#outside')
  entrance = $('#entrance')
  start = $('#startquestion')
  questions = $('#questions')

  views.fadeOut 0, ->
    switch step
      when -1
        entrance.fadeIn 0
      when 0
        start.fadeIn 0
      when 1
        questions.fadeIn 0
        set_question()
      else
        outside.fadeIn 1000

set_question = () ->
  questions = $('#questions')
  q = question_list[_q_n]
  selected = selected_answers[_q_n]
  questions.find('.question_no').find('span').html(q.num)
  questions.find('.question_content').find('span').html(decodeURIComponent(q.content))
  if selected is 0
    questions.find('.question_answer').find('.answer1').find('span').html(q.options[1])
    questions.find('.question_answer').find('.answer2').find('span').html(q.options[2])
  else
    if selected is q.answer
      q_result = "✔"
    else
      q_result = "✘"

    if selected is 1
      questions.find('.question_answer').find('.answer1').find('span').html(q_result)
      questions.find('.question_answer').find('.answer2').find('span').html(q.options[2])
    else if selected is 2
      questions.find('.question_answer').find('.answer1').find('span').html(q.options[1])
      questions.find('.question_answer').find('.answer2').find('span').html(q_result)



