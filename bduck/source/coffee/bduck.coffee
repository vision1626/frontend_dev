init = ->
  $invite_btn = $('.invitation-btn').find('img')
  $share = $('.share')
  $rules_btn = $('.rules-btn')
  $rules = $('.rules')
  $black_box = $('.black-box')
  $bduck = $('.bouncing-duck')
  $parts = $('.js-bduck')

  # helper method
  getRandomInt = (min, max)->
    Math.floor(Math.random() * (max - min)) + min

  largerThan7 = ()->
    r = getRandomInt(1, 10)
    return r > 7

  
  # dom
  delayToggle = ($ele, n)->
    if $ele.attr('data-random') == n.toString()
      if $ele.attr('data-light') == 'yes'
        # $ele.fadeOut()
        # $ele.attr('data-light', 'no')
        alert('这块已经亮过啦')
      else 
        $ele.attr('data-light', 'yes')
        $ele.fadeIn()

  slotMachine = (endPoint, startPoint, time)->
    if startPoint == endPoint
      return true
    else
      currentPart = $($parts[startPoint])
      if currentPart.attr('data-light') == 'no'
        currentPart
          .fadeIn(time)
          .fadeOut(time)
      else 
        currentPart
          .fadeOut(time)
          .fadeIn(time)
      startPoint++
      setTimeout ->
        slotMachine(endPoint, startPoint, time * 1.2)
      , 300

  # handlers
  slotMachineDuck = ->
    if slotMachine($($parts[4]).attr('data-random'), 0, 200)
      setTimeout ->
        if largerThan7()
          rn = getRandomInt(1, 6)
          delayToggle $(part), rn for part in $parts
        else
          delayToggle $(part), 2 for part in $parts
      , 2000 
    # only one click for each user

  # Event registers
  $invite_btn.on 'click', ->
    $share.css({'left': 'auto'})
  $rules_btn.on 'click', (event)->
    $rules.css({'left': 'auto'})
    event.stopPropagation()
  $black_box.on 'click', (e)->
    $(this).css({'left': '-1626px'})
    event.stopPropagation()
  $bduck.on 'click', (e)->
    slotMachineDuck()
    $(this).unbind('click')
    $parts.unbind('click')
  $parts.on 'click', ->
    slotMachineDuck()
    $(this).unbind('click')
    $bduck.unbind('click')