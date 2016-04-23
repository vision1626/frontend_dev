initSlideshow = ->
  # 变量 ----------------------------------------------------------------
  $slideshow = $('.slideshow .slides__wrap')
  $slides = $slideshow.find('.slides')
  $slide = $slides.find('li')
  $bullets = $slideshow.find('.slides__bullets')
  $prev = $slideshow.find('.prev')
  $next = $slideshow.find('.next')
  slide_count = $slide.length
  $slides.attr 'on-slide',0

  # 画圆点 ----------------------------------------------------------------
  for i in [0...slide_count]
    $bullets.append('<li></li>')
  $bullet = $bullets.find('li')
  $bullet.eq(0).addClass('current')
  b_w = $bullet.width()
  b_margin = parseInt($bullet.css 'margin-left')
  $bullets.width((b_w + (b_margin*2))*slide_count)

#   左右翻页按钮逻辑
#  $slideshow.mouseenter ->


  # 函数：构建数据 ----------------------------------------------------------------
  buildSlidesData = ->
    slides_data = []
    $slide.each ->
      $s = $(this)
      item = {}
      link = $s.find('a').attr 'href'
      s_content = $s.find('.slide__content').html()
      item['link'] = link
      item['content'] = s_content
      slides_data.push item
      if $s.index($slide) isnt 0
        $s.remove()

  # 函数：设置幻灯片宽度 ----------------------------------------------------------------
  setSliderWidth = ->
    winW = $(window).width()
    $slide.width winW
    $slides.width 99999999

  # 函数：滑动 ----------------------------------------------------------------
  slideIt = (idx)->
    winW = $(window).width()
    $slides.animate {'left': -(winW * idx)},200,->
      if idx is slide_count
        idx = 0
        $slides.find('li.to-remove').remove()
        $slides.css 'left',0
      else if idx is -1
        idx = slide_count - 1
        $slides.find('li.to-remove').remove()
        $slides.css 'left', -(winW * idx)
      $slides.attr 'on-slide', idx
      $bullet.removeClass 'current'
      $bullet.eq(idx).addClass 'current'

  # 函数：向下一张滑动 ----------------------------------------------------------------
  slideNext = ->
    current_idx = $slides.attr 'on-slide'
    current_idx++
    if current_idx is slide_count
      $slides.append $slide.eq(0).clone().addClass('to-remove')
    slideIt(current_idx)

  # 函数：向上一张滑动 ----------------------------------------------------------------
  slidePrev = ->
    current_idx = $slides.attr 'on-slide'
    current_idx--
    if current_idx is -1
      $slides.prepend $slide.eq(slide_count-1).clone().addClass('to-remove')
      $slides.find('li').eq(0).css {'position':'absolute','left':-$(window).width()}
    slideIt(current_idx)

  # 函数：定时滑动 ----------------------------------------------------------------
  intervalID = null
  slideWithInterval = (is_auto_slide)->
    if is_auto_slide
      intervalID =
        setInterval ->
          slideNext()
        ,3000
    else
      clearInterval(intervalID)

  # 设置尺寸 ----------------------------------------------------------------
  setSliderWidth()

  $(window).resize ->
    setSliderWidth()

  # 点击动作 ----------------------------------------------------------------
  $next.click ->
    slideNext()

  $prev.click ->
    slidePrev()

  $bullet.click ->
    idx = $bullet.index($(this))
    slideIt(idx)

  # 开始滑动 ----------------------------------------------------------------
  slideWithInterval(true)

  $slideshow.mouseenter ->
    slideWithInterval(false)
  .mouseleave ->
    slideWithInterval(true)


initSlideshowMobile = ->
  $mobileSlideshow = $('<div class="slides--mobile__wrap"></div>')
  $slideshow = $('.slideshow .slides__wrap')
  winW = $(window).width()
  $slideshow.find('li a').each ->
    s = $(this)
    link = s.attr 'href'
    o_c = s.attr 'onclick'
    img_url = s.find('img.bg').attr('src')
    img_alt = s.find('img.bg').attr('alt')
    $new_slide = $("<div class='new_slide' style='width:#{winW}'><a href='#{link}' onclick='#{o_c}' style='background-image:url(#{img_url})'></a></div>")
    $mobileSlideshow.append $new_slide
  $slideshow.remove()
  $('section.slideshow').append $mobileSlideshow
  $mobileSlideshow.slick(
    arrows: false,
    dots: true,
    autoplay: true,
    autoplaySpeed: 3000,
    cssEase: 'ease-out',
    speed: '200'
  )


