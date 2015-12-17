init = ->
  $invite_btn = $('.invitation-btn').find('img')
  $share = $('.share')
  $rules_btn = $('.rules-btn')
  $rules = $('.rules')
  $detail_btn = $('.prize-detail-btn')
  $detail = $('.prize-detail')
  $black_box = $('.black-box')
  $bduck = $('.bouncing-duck')
  $parts = $('.js-bduck')

  $img_holder = $(".js-img-holder")
  $img_controllers = $(".js-img-controllers").find('li')

  state_Map = {
    idx_counter: 0;
  }

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

  lightController = ->
    $img_controllers.each ->
      if $(this).find('img').attr('src') is $img_holder.attr('src')
        $(this).addClass('current-img')
      else
        $(this).removeClass('current-img')

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

  slideAsce = ()->
    if state_Map.idx_counter is 4
      state_Map.idx_counter = 0
      currentImg = $($img_controllers[state_Map.idx_counter])
      $img_holder.attr('src', currentImg.find('img').attr('src'))
    else 
      currentImg = $($img_controllers[state_Map.idx_counter++])
      $img_holder.attr('src', currentImg.next().find('img').attr('src'))
  slideDesc = ()->
    if state_Map.idx_counter is -1
      state_Map.idx_counter = 3
      currentImg = $($img_controllers[state_Map.idx_counter])
      $img_holder.attr('src', currentImg.find('img').attr('src'))
    else 
      currentImg = $($img_controllers[state_Map.idx_counter--])
      $img_holder.attr('src', currentImg.prev().find('img').attr('src'))


  # Event registers
  $invite_btn.on 'click', ->
    $share.css({'left': 'auto'})
  $rules_btn.on 'click', (event)->
    $rules.css({'left': 'auto'})
    event.stopPropagation()
  $detail_btn.on 'click', ->
    $detail.css({'left': 'auto'})
  $black_box.on 'click', (e)->
    $(this).css({'left': '-1626em'})
    event.stopPropagation()


  lightController()

  # swipe
  $img_holder.swipe({
    swipeLeft: ->
      slideAsce()
      lightController()
    swipeRight: ->
      slideDesc()
      lightController()
  })
  setTimeout ->
    $bduck.on 'click', (e)->
      slotMachineDuck()
      $(this).unbind('click')
      $parts.unbind('click')
    $parts.on 'click', ->
      slotMachineDuck()
      $(this).unbind('click')
      $bduck.unbind('click')
  , 2000