initHomepage = ->
#  $homepage = $('#homepage-wrap')
#  $phantoms = $homepage.find('img.phantom')
#  $phantoms.each ->
#    placePhantomImg($(this))

  initSlideshow()
  initHeadlineList()

  removeOverflowCats = ->
    special_cat = $('.specials .section__nav').find('li')
    special_cat_count = special_cat.length
    max_count = 9
    overflow_count = special_cat_count - max_count
    slice = parseInt(0-overflow_count)
    if $(window).width() < 1020 and special_cat_count > max_count
      special_cat.slice(slice).remove()

  removeOverflowCats()