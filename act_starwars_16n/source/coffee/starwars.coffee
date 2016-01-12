_step = -2
_q_n= 0
_done = 0
_score = 0
_not_answer = false
_image_path  = './tpl/hi1626/images/starwars/'
#_not_show_prize = true

init = ->
#  set_step(_step)
  set_step(3)

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
      me.find('span').addClass('icon').addClass('icon-glad')
      _score += 1
    else
      me.addClass "wrong"
      me.find('span').addClass('icon').addClass('icon-sad')
    setTimeout ->
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
    , 2000

$('.hide_prize').click ->
  toggle_prize()

$(document).on 'click','.show_prize', ->
  toggle_prize()

$(document).on 'click','.share_now', ->
  alert(2)

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
        eye_top.addClass 'open_top2'
        eye_bottom.addClass 'open_bottom2'

        result.fadeIn 0
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


