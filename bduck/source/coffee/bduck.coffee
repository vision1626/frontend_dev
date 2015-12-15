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

  # handlers
  slotMachineDuck = ->
    if largerThan7()
      rn = getRandomInt(1, 6)
      delayToggle $(part), rn for part in $parts
    else
      delayToggle $(part), 2 for part in $parts
    # only one click for each user
    $bduck.unbind('click')

  $invite_btn.on 'click', ->
    $share.css({'left': 'auto'})
  $rules_btn.on 'click', (event)->
    $rules.css({'left': 'auto'})
    event.stopPropagation()
  $black_box.on 'click', (e)->
    $(this).css({'left': '-1626em'})
    event.stopPropagation()
  $bduck.on 'click', (e)->
    slotMachineDuck()
