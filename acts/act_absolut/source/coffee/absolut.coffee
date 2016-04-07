_beta = false
_gamma = false
_is_iphone = navigator.userAgent.indexOf('iPhone') > 0
_image_path = '../tpl/hi1626/images/act/absolut/'

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
  panda-say = pick.find '.panda-say'
  panda-say_content = pick.find 'h2'
  trigger = pick.find '.pick-triggers li'
  # panda doms
  panda_body = panda.find '.panda-body'
  holding = panda.find '.holding-drink'
  holding_fill = holding.find '.filling'
  holding_color = holding.find '.color'
  holding_img = holding.find 'img.type'
  # glasses doms
  glass_row = glasses.find '.glass-row'
  glass_filling = glass_row.find('li.glass').find('.filling')
  fluid = glasses.find '.fluid'
  # result doms
  explain_block = result.find '.explanations'
  explain_item = result.find('.explanations li')
  say_result = result.find('.say_result')
  panda_left = result.find('.panda_left')
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

    if _is_iphone
#      holding_color.show()
#      holding_img.hide()
    else
      holding_color.hide()
#      holding_img.show()

    say_content_base = '1份伏特加+5份'
    switch i
      when 0
        holding_img.attr('src',_image_path + 'passionfruit_dump.png')
        holding_fill.addClass 'passionfruit'
        glass_filling.addClass 'passionfruit'
        fluid.addClass 'passionfruit'
        say_result.addClass 'passionfruit'
        panda-say_content.html(say_content_base + '百香果')
      when 1
        holding_img.attr('src',_image_path + 'ice-tea_dump.png')
        holding_fill.addClass 'ice-tea'
        glass_filling.addClass 'ice-tea'
        fluid.addClass 'ice-tea'
        say_result.addClass 'ice-tea'
        panda-say_content.html(say_content_base + '冰红茶')
      when 2
        holding_img.attr('src',_image_path + 'lemon_dump.png')
        holding_fill.addClass 'lemon'
        glass_filling.addClass 'lemon'
        fluid.addClass 'lemon'
        say_result.addClass 'lemon'
        panda-say_content.html(say_content_base + '柠檬')
      when 3
        holding_img.attr('src',_image_path + 'coke_dump.png')
        holding_fill.addClass 'coke'
        glass_filling.addClass 'coke'
        fluid.addClass 'coke'
        say_result.addClass 'coke'
        panda-say_content.html(say_content_base + '可乐')
      when 4
        holding_img.attr('src',_image_path + 'cranberry_dump.png')
        holding_fill.addClass 'cranberry'
        glass_filling.addClass 'cranberry'
        fluid.addClass 'cranberry'
        say_result.addClass 'cranberry'
        panda-say_content.html(say_content_base + '蔓越莓')
      when 5
        holding_img.attr('src',_image_path + 'hawthorn_dump.png')
        holding_fill.addClass 'hawthorn'
        glass_filling.addClass 'hawthorn'
        fluid.addClass 'hawthorn'
        say_result.addClass 'hawthorn'
        panda-say_content.html(say_content_base + '山楂')

  introToPick = ->


    vodka = intro.find '.kv-vodka'
    vodka.addClass 'hidden'
    btn_start.addClass 'hidden'
    top_logo.addClass 'shrink'

    if _is_iphone
      drinks.find('img').hide()
      drinks.find('.color').show()
    else
      drinks.find('img').show()
      drinks.find('.color').hide()

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
    if !_beta and !_gamma
      setTimeout ->
        selected.addClass 'selected'
        right_hand.addClass 'leave'
        panda_body.addClass 'picked'
        panda-say.addClass 'shown'
      , 400
      setTimeout ->
        left_hand.addClass 'leave'
        panda-say.removeClass 'shown'
        hint.show().addClass('shown')
        rotateScreen()
      , 3400
      setTimeout ->
        holding.addClass 'picked'
        app.addClass 'picked'
      , 3600
      setTimeout ->
        pourDrink()
      , 5000
    else
      setTimeout ->
        selected.addClass 'selected'
        right_hand.addClass 'leave'
        panda_body.addClass 'picked'
        panda-say.addClass 'shown'
      , 400
      setTimeout ->
        left_hand.addClass 'leave'
        panda-say.removeClass 'shown'
        hint.show().addClass('shown')
      , 3400
      setTimeout ->
        holding.addClass 'picked'
        app.addClass 'picked'
      , 3600

  # hint.click ->
  #   rotateScreen()
  rotateScreen = ->
    backdrop.addClass 'rotated'
    hint.removeClass 'shown'
#    panda-say.removeClass 'shown'
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
      panda_left.addClass 'shown'
      say_result.addClass 'shown'

    , 9300

  gotoFinal = ->
    next_btn.removeClass 'shown'
    explain_block.removeClass 'shown'
    cocktail.removeClass 'shown'
    panda_left.removeClass 'shown'
    say_result.removeClass 'shown'
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
      if $(window).width() < $(window).height()
        screenAdjustedEvent = orientationData.getFixedFrameEuler()
        spec = app.find '.gyro-spec'
        b = printDataValue(screenAdjustedEvent.beta)
        g = printDataValue(screenAdjustedEvent.gamma)
        spec.find('p').eq(1).find('span').html(b)
        spec.find('p').eq(2).find('span').html(g)
        _gamma = g
        if g > 60 and app.hasClass('picked') and !app.hasClass('rotated')
          rotateScreen()
        if g > 60 and b < -15 and app.hasClass('rotated')
          pourDrink()
          orientationData.stop()


  $(window).on 'resize', ->
    hor = $('.horizontal-screen')
    hint = hor.find '.rotate-hint'
    if $(window).width() > $(window).height()
      hor.show()
      hint.addClass 'shown'
    else
      hint.removeClass 'shown'
      hor.hide()
