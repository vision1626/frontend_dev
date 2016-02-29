initSlideshow = ->
  $slideshow = $('.slideshow .slides__wrap')
  $slides = $slideshow.find('.slides')
  $slide = $slides.find('li')
  $bullets = $slideshow.find('.slides__bullets')

  slide_count = $slide.length

  for i in [0...slide_count]
    $bullets.append('<li></li>')
  $bullet = $bullets.find('li')
  $bullet.eq(0).addClass('current')
  b_w = $bullet.width()
  b_margin = parseInt($bullet.css 'margin-left')
  $bullets.width((b_w + (b_margin*2))*slide_count)


  winW = $(window).width()
  $slide.width winW
  $slides.width winW * slide_count