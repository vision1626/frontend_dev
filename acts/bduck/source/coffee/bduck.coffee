init = ->
  $invite_btn = $('.invitation-btn').find('img')
  $help_btn = $('.help-btn')
  $helped_btn = $('.helped-btn')
  $share = $('.share')
  $rules_btn = $('.rules-btn')
  $rules = $('.rules')
  $detail_btn = $('.prize-detail-btn')
  $detail = $('.prize-detail')
  $black_box = $('.black-box')
  $bduck = $('.bouncing-duck')
  $parts = $('.js-bduck')
  $submit = $('.form-submit')
  $check_helpers_btn = $('.check-helpers-btn')
  $helpers = $('.lighten-users')

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
        # alert('这块已经亮过啦')
      else 
        $ele.attr('data-light', 'yes')
        $ele.fadeIn()
      $.ajax({
        method: 'POST',
        url: window.lighten_url,
        data: { part: n },
        dataType: 'json',
        success: (result) ->
          # if result.status is 1
          #   alert('works!')
          # else 
          #   alert(result.msg)
      })
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
        slotMachine(endPoint, startPoint, time * 1.25)
      , 200
  lightController = ->
    $img_controllers.each ->
      if $(this).find('img').attr('src') is $img_holder.attr('src')
        $(this).addClass('current-img')
      else
        $(this).removeClass('current-img')

  showPart = (number) ->
    $parts.each ->
      if $(this).attr('data-random') == number
        $(this).show().attr('data-light', 'yes')

  showLigtenDuck = ->
    ligtened_parts_arr = window.lighten_parts.split(',')
    showPart number for number in ligtened_parts_arr

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
    $share.addClass('show')
  $rules_btn.on 'click', (event)->
    $rules.addClass('show')
    event.stopPropagation()
  $detail_btn.on 'click', ->
    $detail.addClass('show')
  $black_box.on 'click', (e)->
    $(this).removeClass('show')
    event.stopPropagation()
  $check_helpers_btn.on 'click', ->
    $helpers.toggleClass('show-helpers')
  $submit.on 'click', (e)->
    name = $('form').find('.input-name').val()
    tel = $('form').find('.input-tel').val()
    addr = $('form').find('.input-addr').val()
    obj = {
      name: name,
      tel: tel,
      addr: addr
    }
    $.ajax({
      method: 'POST',
      url: window.deliver_url,
      data: obj,
      dataType: 'json',
      success: (result) ->
        # if result.status is 1
        #   alert('works!')
        # else 
        #   alert(result.msg)
    })
    e.preventDefault()

  # init
  lightController()
  showLigtenDuck()

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
    if $help_btn.length > 0
      $help_btn.on 'click', (e)->
        if islighten == "1"
          $share.addClass('show')
        else
          slotMachineDuck()
          $(this).unbind('click')
          $helped_btn.fadeIn()
          $parts.unbind('click')
      $parts.on 'click', ->
        if islighten == "0"
          slotMachineDuck()
          $(this).unbind('click')
          $bduck.unbind('click')
          $help_btn.unbind('click')
    else if $bduck.length > 0
      $bduck.on 'click', (e)->
        slotMachineDuck()
        $(this).unbind('click')
        $parts.unbind('click')
      $parts.on 'click', ->
        slotMachineDuck()
        $(this).unbind('click')
        $bduck.unbind('click')
        $help_btn.unbind('click')
  , 2000