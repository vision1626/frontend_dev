initHomepage = ->
  $homepage = $('#homepage-wrap')
  $phantoms = $homepage.find('img.phantom')
  $phantoms.each ->
    placePhantomImg($(this))

  initSlideshow()
  initHeadlineList()