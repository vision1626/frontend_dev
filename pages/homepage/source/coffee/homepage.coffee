initHomepage = ->

  initSlideshow()
  initHeadlineList()
  initHotNews()
  initGoodsAsync()

  removeOverflowCats = ->
    special_cat = $('.specials .section__nav').find('li')
    special_cat_count = special_cat.length
    max_count = 9
    overflow_count = special_cat_count - max_count
    slice = parseInt(0-overflow_count)
    if $(window).width() < 1020 and special_cat_count > max_count
      special_cat.slice(slice).remove()

  removeOverflowCats()

