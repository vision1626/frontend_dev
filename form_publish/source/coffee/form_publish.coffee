init_form_publish = ->
  g_expire = ''

  $popup_close = $('.popup__close')
  $blackbox = $('.popup__blackbox')
  $popup = $('.popup')
  $popup_btn = $blackbox.find('button')
  $popup_url = $blackbox.find('input[name=url]')
  $popup_loading = $blackbox.find('.popup__loading');

  # publish form
  $form_publish = $('form.form__body')
  $form_url_input = $form_publish.find('input[name="url"]')
  $form_title_input = $form_publish.find('input[name="title"]')
  $form_brand_input = $form_publish.find('input[name="brand"]')
  $form_cate_input = $form_publish.find('input[name="category"]')
  $form_color_input = $form_publish.find('input[name="color"]')
  $form_style_input = $form_publish.find('input[name="style"]')
  $form_price_input = $form_publish.find('input[name="price"]')
  $form_recommendation = $form_publish.find('textarea')
  $form_imgs_wrapper = $form_publish.find('.imgs-wrapper')
  $form_submit_btn = $form_publish.find('.publish')
  # preview 
  $draggable_bg = $form_publish.find('.item-b_image')
  # imgs_proccessor
  $imgs_proccessor = $('.url-img-processor')
  $img_adder = $imgs_proccessor.find('.img-adder')

 
  renderImg = (url)->
    img = $('<img src=' + '"' + SITE_URL + 
      url.substring() + '"' + '>')
    img_wrapper = $('<div class="url-img"></div>')
    img_editor = $('<div class="img-editor">' +
                     '<span>设为主图</span>' +
                     '<i class="icon icon-closepop"></i>' +
                   '</div>')
    img_wrapper.append(img_editor)
    img_wrapper.append(img)
    $img_adder.before(img_wrapper)

  drawImgSrc = ($img)->


  updateBg = (url)->
    $draggable_bg.css({
      'background': 'url("' + url + '") no-repeat center center',
      'background-size': 'cover'
    })

  setImgEditor = ->
    $img_remove = $imgs_proccessor.find('.icon-closepop')
    $img_set_main = $imgs_proccessor.find('span')
    $img_remove.each (index)->
      $(this).on 'click', ->
        select_src = $(this)
                      .parent()
                      .parent()
                      .find('img')
                      .attr('src')
        $.post(SITE_PATH+"services/service.php?m=index&a=del_upload_gallery", {'del_img': select_src})
        new_bg_src = $(img_remove
                              .parent()
                              .parent()
                              .find('img')
                              .eq(0)
                              .attr('src'))
        updateBg(new_bg_src)
        $(this).parent().parent('.url-img').remove()
    $img_set_main.each (index)->
      $(this).on 'click', ->
        select_src = $(this)
                      .parent()
                      .parent()
                      .find('img')
                      .attr('src')
        updateBg(select_src)


  $popup_close.on 'click', ->
    $blackbox.fadeOut(500)
  $popup_btn.on 'click', (e)->
    obj = {
            url: encodeURIComponent($popup_url.val()),
            type: 'local'
          }
    $popup.fadeOut(500)
    $popup_loading.fadeIn(500)
    $.ajax({
      url: SITE_URL + "services/service.php?m=u&a=add_share",
      type: "get",
      data: obj,
      dataType: "json",
      success: (result)->
        if result.status == 1
          $form_url_input.val(result['url'])
          $form_title_input.val(result['goods_name'])
          $form_price_input.val(result['goods_price'])
          g_expire = result['expire_time']
          if result['url_arr'].length > 0
            renderImg url for url in result['url_arr']
            updateBg(SITE_URL + '/' + result['url_arr'][0])
          $blackbox.fadeOut(500)
          $('.item-list-filter').fadeOut(500)
          $('.item-list-container').fadeOut(500) 
          $('.form__container').fadeIn(500)
          setImgEditor()
    })
    e.preventDefault()

  $form_submit_btn.on 'click', (e)->
    title   = $form_title_input.val()
    price   = $form_price_input.val()
    link    = $form_url_input.val()
    brand   = $form_brand_input.val()
    style   = $form_style_input.val()
    catid   = $form_cate_input.val()
    recommendation = $form_recommendation.val()
    img_arr = []
    img_arr.push $(img).attr('src') for img in $('.url-img-processor').find('img')
    obj = {
      'goods_name' :  title,
      'goods_price':  price,
      'catid'      :  catid,
      'pinpai'     :  brand,
      'fengge'     :  style,
      'img_arr'    :  img_arr,
      'expire'     :  g_expire,
      'content'    :  recommendation
    }
    $.ajax({
      url :  SITE_URL + 'services/service.php?m=share&a=share_save',
      type: 'post',
      data: obj,
      dataType: 'json',
      cache: false,
      success: (result)->
        # 
    })
    e.preventDefault()
