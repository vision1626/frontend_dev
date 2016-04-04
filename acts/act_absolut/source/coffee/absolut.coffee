init = ->
  initTouch()

  app = $('#absolut')
  # section doms
  intro = app.find 'section.intro'
  pick = app.find 'section.pick-drink'
  panda = app.find 'section.panda'
  glasses = app.find 'section.glasses'
  result = app.find 'section.result'
  final = app.find 'section.final'
  bg = app.find 'section.logo-background'
  # bg doms
  top_logo = bg.find '.logo'
  backdrop = bg.find '.bg'
  # intro doms
  btn_start = intro.find 'a.start'
  # pick doms
  drinks = pick.find '.drinks'
  hands = pick.find '.panda-hands'
  left_hand = hands.find '.left'
  right_hand = hands.find '.right'
  pls = pick.find 'h3.pls'
  hint = pick.find '.rotate-hint'
  trigger = pick.find '.pick-triggers li'
  # panda doms
  panda_body = panda.find '.panda-body'
  holding = panda.find '.holding-drink'
  holding_fill = holding.find '.filling'
  # glasses doms
  glass_row = glasses.find '.glass-row'
  glass_filling = glass_row.find('li.glass').find('.filling')
  fluid = glasses.find '.fluid'
  # result doms
  explain_block = result.find '.explanations'
  explain_item = result.find('.explanations li')
  cocktail = result.find '.cocktail'
  next_btn = result.find 'a.next'
  # final doms
  prizes = final.find '.prizes'
  form = final.find '.form'
  brand = final.find '.brand'

  btn_start.click ->
    introToPick()

  next_btn.click ->
    gotoFinal()

  trigger.click ->
    t = $(this)
    i = trigger.index(t)
    pickedAndShowPanda(drinks.find('li').eq(i))
    explain_item.eq(i).show()
    cocktail.find('img').eq(i).show()
    switch i
      when 0
        holding_fill.addClass 'passionfruit'
        glass_filling.addClass 'passionfruit'
        fluid.addClass 'passionfruit'
      when 1
        holding_fill.addClass 'ice-tea'
        glass_filling.addClass 'ice-tea'
        fluid.addClass 'ice-tea'
      when 2
        holding_fill.addClass 'lemon'
        glass_filling.addClass 'lemon'
        fluid.addClass 'lemon'
      when 3
        holding_fill.addClass 'coke'
        glass_filling.addClass 'coke'
        fluid.addClass 'coke'
      when 4
        holding_fill.addClass 'cranberry'
        glass_filling.addClass 'cranberry'
        fluid.addClass 'cranberry'
      when 5
        holding_fill.addClass 'hawthorn'
        glass_filling.addClass 'hawthorn'
        fluid.addClass 'hawthorn'

  introToPick = ->
    vodka = intro.find '.kv-vodka'
    vodka.addClass 'hidden'
    btn_start.addClass 'hidden'
    top_logo.addClass 'shrink'
    setTimeout ->
      pick.show()
      drinks.addClass 'shown'
      pls.addClass 'shown'
      panda.show()
      panda_body.addClass 'shown'
    , 600
    setTimeout ->
      left_hand.addClass 'shown'
    , 1600
    setTimeout ->
      right_hand.addClass 'shown'
    , 2100

  pickedAndShowPanda = (selected)->
    selected.siblings().addClass 'leave'
    pls.removeClass 'shown'
    setTimeout ->
      selected.addClass 'selected'
      left_hand.addClass 'leave'
      right_hand.addClass 'leave'
      panda_body.addClass 'picked'
      hint.show().addClass('shown')
    , 400
    setTimeout ->
      holding.addClass 'picked'
      app.addClass 'picked'
    , 600

  # hint.click ->
  #   rotateScreen()
  rotateScreen = ->
    backdrop.addClass 'rotated'
    hint.removeClass 'shown'
    top_logo.addClass 'rotated'
    panda_body.addClass 'rotated'
    glasses.show()
    glass_row.addClass 'shown'
    holding.addClass 'ready-to-pour'
    app.addClass 'rotated'
    # setTimeout ->
    #   pourDrink()
    # , 1400

  pourDrink = ->
    $(document).unbind('deviceorientation', detectOri)
    glasses.find('h3').fadeOut(500)
    holding.addClass 'pouring'
    fluid.show()
    glass_filling.eq(4).addClass 'full'
    setTimeout ->
      fluid.hide()
      holding.addClass 'pouring-4to3'
      panda_body.addClass 'pouring-3'
    , 1000
    setTimeout ->
      holding.addClass 'pouring-3'
      fluid.show().addClass('pouring-3')
      glass_filling.eq(3).addClass 'full'
    , 1600
    setTimeout ->
      fluid.hide()
      holding.addClass 'pouring-3to2'
      panda_body.addClass 'pouring-2'
    , 2600
    setTimeout ->
      holding.addClass 'pouring-2'
      fluid.show().addClass('pouring-2')
      glass_filling.eq(2).addClass 'full'
    , 3200
    setTimeout ->
      fluid.hide()
      holding.addClass 'pouring-2to1'
      panda_body.addClass 'pouring-1'
    , 4200
    setTimeout ->
      holding.addClass 'pouring-1'
      fluid.show().addClass('pouring-1')
      glass_filling.eq(1).addClass 'full'
    , 4800
    setTimeout ->
      fluid.hide()
      holding.addClass 'pouring-1to0'
      panda_body.addClass 'pouring-0'
    , 5800
    setTimeout ->
      holding.addClass 'pouring-0'
      fluid.show().addClass('pouring-0')
      glass_filling.eq(0).addClass 'full'
    , 6600
    setTimeout ->
      fluid.hide()
      holding.addClass 'pouring-end'
    , 7600
    setTimeout ->
      holding.addClass 'leave'
      panda_body.addClass 'leave'
      top_logo.fadeOut(300)
      glass_row.addClass 'leave'
    , 8200
    setTimeout ->
      backdrop.removeClass 'rotated'
      result.show()
    , 8700
    setTimeout ->
      next_btn.addClass 'shown'
      explain_block.addClass 'shown'
      cocktail.addClass 'shown'
    , 9300

  gotoFinal = ->
    next_btn.removeClass 'shown'
    explain_block.removeClass 'shown'
    cocktail.removeClass 'shown'
    setTimeout ->
      final.show()
      prizes.addClass 'shown'
      form.addClass 'shown'
      brand.addClass 'shown'
    , 600

  detectOri = (event)->
    # alpha = event.alpha
    beta = event.beta
    gamma = event.gamma
    spec = app.find '.gyro-spec'
    # spec.find('p').eq(0).find('span').html(alpha)
    spec.find('p').eq(1).find('span').html(beta)
    spec.find('p').eq(2).find('span').html(gamma)
    if gamma > 60 and app.hasClass('picked')
      rotateScreen()
      if beta < -15 and app.hasClass('rotated')
        pourDrink()

  printDataValue = (input)->
    if input is undefined
      "undefined"
    if input is null
      "null"
    if input is true
      "true"
    if input is false
      "false";
    if Object.prototype.toString.call(input) is "[object Number]"
      Math.round((input + 0.00001) * 100) / 100
    input + ""

  deviceOrientation = FULLTILT.getDeviceOrientation({'type': 'world'})
  deviceOrientation.then (orientationData)->
    orientationData.listen ()->
      screenAdjustedEvent = orientationData.getFixedFrameEuler()
      spec = app.find '.gyro-spec'
      b = printDataValue(screenAdjustedEvent.beta)
      g = printDataValue(screenAdjustedEvent.gamma)
      # spec.find('p').eq(1).find('span').html(b)
      # spec.find('p').eq(2).find('span').html(g)
      if g > 60 and app.hasClass('picked')
        rotateScreen()
        if b < -15 and app.hasClass('rotated')
          pourDrink()
          orientationData.stop()
    

