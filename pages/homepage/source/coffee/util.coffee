placePhantomImg = ($phantom)->
  img_url = $phantom.data('img')
  $real_img = $phantom.parent('.real-img')
  $real_img.css 'background-image',"url(#{img_url})"