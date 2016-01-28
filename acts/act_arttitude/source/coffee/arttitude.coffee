init = ->
  app = $('#arttitude')
  section = app.find('section')
  sectionHome = app.find('section.home')
  sectionIntro = app.find('section.intro')
  sectionBrands = app.find('section.brands')
  sectionPartners = app.find('section.partners')
  homeBrandLinks = sectionHome.find('.brand-links')
  title = app.find('.title-wrap')
  logo = app.find('.title__logo')
  slogan = app.find('.title__slogan')

  winH = getWinHeight()
  homeBrandLinksH = homeBrandLinks.height()
  homeBrandLinks.css 'top', (winH - homeBrandLinksH)/2 + 10

  introAnimation = (fromNav)->
    winH = getWinHeight()
    title.show()
    titleH = title.height()
    titlePosStart = (winH - titleH)/2
    brandLinkShowDelay = 0
    if !fromNav
      title.css 'top':titlePosStart
      brandLinkShowDelay = 1000
    title.css 'opacity',1
#    slogan.fadeIn(200)
    setTimeout(->
      title.css 'top','0'
      homeBrandLinks.removeClass 'hidden'
      $('.show-desc').removeClass 'hidden'
    , brandLinkShowDelay)

  introAnimation(false)

  navLink = app.find('nav a')
  navLinkLi = app.find('nav li')
  navLink.click ->
    clickedLink = $(this)
    clickedLi = clickedLink.parent()
    clickedIdx = navLinkLi.index(clickedLi)
    navLink.removeClass('current')
    clickedLink.addClass('current')
    if clickedLi.hasClass 'home'
      section.fadeOut(200)
      introAnimation(true)
      sectionHome.show()
      title.removeClass 'desized'
    else
      homeBrandLinks.addClass 'hidden'
      $('.show-desc').addClass 'hidden'
      title.addClass 'desized'
#      slogan.fadeOut(200)
      section.fadeOut(200)
      section.eq(clickedIdx).fadeIn(200)
    window.scrollTo(0,0)

  itemList    = sectionBrands.find 'ul.products'
  itemBulletList = sectionBrands.find 'ul.bullets'
  item        = itemList.find 'li'
  itemBullet = itemBulletList.find 'li'
  itemCount = item.length
  resizeProductList = ->
    winW = getWinWidth()
    item.width winW
    itemListW = winW * itemCount
    itemList.width itemListW
  resizeProductList()

  btnPrev = app.find('.pager.prev')
  btnNext = app.find('.pager.next')

  showChosenItem = (gotoItemIdx)->
    window.scrollTo(0,0)
    winW = getWinWidth()
    itemList.css 'left', -(gotoItemIdx * winW)
    itemBullet.removeClass 'current'
    itemBullet.eq(gotoItemIdx).addClass('current')
    itemList.parent().height item.eq(gotoItemIdx).height()

  btnNext.click ->
    curItemIdx = parseInt(itemList.attr 'cur-item')
    if curItemIdx isnt itemCount-1
      gotoItemIdx = curItemIdx+1
      showChosenItem(gotoItemIdx)
      itemList.attr 'cur-item',gotoItemIdx
      btnPrev.removeClass 'disabled'
    if curItemIdx is itemCount-2
      btnNext.addClass 'disabled'

  btnPrev.click ->
    curItemIdx = parseInt(itemList.attr 'cur-item')
    if curItemIdx isnt 0
      gotoItemIdx = curItemIdx-1
      showChosenItem(gotoItemIdx)
      itemList.attr 'cur-item',gotoItemIdx
      btnNext.removeClass 'disabled'
    if curItemIdx is 1
      btnPrev.addClass 'disabled'

  sectionBrands.swipe {
    swipeLeft: ->
      btnNext.click()
    swipeRight: ->
      btnPrev.click()
  }

  homeBrandLinks.find('li').click ->
    clickedBrandLink = $(this)
    navLink.eq(2).click()
    idx = homeBrandLinks.find('li').index(clickedBrandLink)
    itemList.attr 'cur-item',idx
    if idx isnt 0
      btnPrev.removeClass 'disabled'
    showChosenItem(idx)

