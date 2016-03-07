initScratchCard = ($target)->
  container = $('#scratchCard')
  # Creates a new canvas element and appends it as a child
  # to the parent element, and returns the reference to
  # the newly created canvas element

  createCanvas = (parent, width, height) ->
    canvas = {}
    canvas.node = document.createElement('canvas')
    canvas.context = canvas.node.getContext('2d')
    canvas.node.width = width or 500
    canvas.node.height = height or 500
    parent.append(canvas.node)
    canvas

  init = (container, width, height, fillColor) ->
    canvas = createCanvas(container, width, height)
    ctx = canvas.context
    # define a custom fillCircle method

    ctx.fillCircle = (x, y, radius, fillColor) ->
      @fillStyle = fillColor
      @beginPath()
      @moveTo x, y
      @arc x, y, radius, 0, Math.PI * 2, false
      @fill()
      return

    ctx.clearTo = (fillColor) ->
      ctx.fillStyle = fillColor
      ctx.fillRect 0, 0, width, height
      return

    ctx.clearTo fillColor or '#ddd'
    # bind mouse events

    canvas.node.onmousemove = (e) ->
      `var fillColor`
      if !canvas.isDrawing
        return
      x = e.pageX - (@offsetLeft)
      y = e.pageY - (@offsetTop)
      radius = 20
      # or whatever
      fillColor = '#ff0000'
      ctx.globalCompositeOperation = 'destination-out'
      ctx.fillCircle x, y, radius, fillColor
      return

    canvas.node.onmousedown = (e) ->
      canvas.isDrawing = true
      return

    canvas.node.onmouseup = (e) ->
      canvas.isDrawing = false
      return

    return

  init(container, 200, 100, '#ddd')