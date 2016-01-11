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
  $form_cate_select = $form_publish.find('select[name="category"]')
  $form_cate_select2 = $form_publish.find('select[name="category2"]')
  $form_style_select = $form_publish.find('select[name="style"]')
  $form_price_input = $form_publish.find('input[name="price"]')
  $form_tags_input =  $form_publish.find('input[name="tag"]')
  $form_tags = $form_publish.find('.item-tags').find('ul').find('.unselected')
  $form_recommendation = $form_publish.find('textarea')
  $form_imgs_wrapper = $form_publish.find('.imgs-wrapper')
  $form_submit_btn = $form_publish.find('.publish')
  # preview
  $preview = $form_publish.find('dl.big_img.static')
  $preview_title = $preview.find('.item-b_title')
  $preview_price = $preview.find('.item-b_price')
  $draggable_bg = $preview.find('.item-b_image.preview')
  # imgs_proccessor
  $imgs_proccessor = $('.url-img-processor')
  $img_adder = $imgs_proccessor.find('.img-adder')

  get2ndCate = (id) ->
    obj = {
      pc_id: id,
      type : 'category'
    }
    $.ajax({
      url: SITE_URL + 
        'services/service.php?m=exchange&a=quick_edit_note',
      data: obj,
      type: 'post',
      dataType: 'json',
      success: (result) ->
        $form_cate_select2.html(result.html)
    })

  renderImg = (url)->
    img = $('<img src='+ url.substring() + '>')
    img_wrapper = $('<div class="url-img"></div>')
    img_editor = $('<div class="img-editor">' +
                     '<span>设为主图</span>' +
                     '<i class="icon icon-closepop"></i>' +
                   '</div>')
    img_wrapper.append(img_editor)
    img_wrapper.append(img)
    $img_adder.before(img_wrapper)

  renderStyle = (style)->
    option = $('<option>' + style + '</option>')
    $form_style_select.append(option)

  renderCatgory = (category)->
    option = $('<option value="' + category['id'] + 
      '">' + category['name'] + '</option>')
    $form_cate_select.append(option)
    $form_cate_select.on 'change', ->
      id = Number($(this).val())
      get2ndCate(id)

  setPreviewImg = ()->
    img = $draggable_bg.find('img')
    nozero = ()->
      return img.width() != 0 && img.height() != 0
    wrapper_width = $draggable_bg.width()
    wrapper_height = $draggable_bg.height()
    # 宽图
    if ((img.width() > img.height()) && nozero())
      img.draggable({axis: 'x', cursor: '-webkit-grabbing'})
      img.css({
        height: '100%',
        width: 'auto',
        'margin-left': -(img.width() - wrapper_width)/2 + 'px'
      })
    # 高图
    if ((img.height() > img.width()) && nozero())
      img.css({
        width: '100%',
        height: 'auto',
        'margin-top': -(img.height() - wrapper_height)/2 + 'px'
      })
      img.draggable({axis: 'y', cursor: '-webkit-grabbing'})

  updateBg = (url)->
    img = $('<img src=' + url + '>');
    $draggable_bg.find('img').remove()
    $draggable_bg.append(img)
    setPreviewImg()

  updatePreview = (o)->
    if o['goods_name']
      $preview_title.html(o['goods_name'])
    if o['goods_price']
      $preview_price.html("¥" +o['goods_price'])

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
        new_bg_src = $img_remove
                              .parent()
                              .parent()
                              .find('img')
                              .eq(0)
                              .attr('src')
        updateBg(new_bg_src)
        $(this).parent().parent('.url-img').remove()
    $img_set_main.each (index)->
      $(this).on 'click', ->
        all_img = $('.url-img-processor').find('img')
        selected_img = $(this)
                         .parent()
                         .parent()
                         .find('img')
        all_img.removeClass('main-img')
        selected_img.addClass('main-img')
        selected_src = selected_img.attr('src')
        updateBg(selected_src)

  getImgLength = ->
    $('.url-img').length

  imageUpload = ->
    if getImgLength() == 5
      alert '已经不能再上传了'
      reRenderFileInput()
    else 
      $.ajaxFileUpload({
        url: SITE_URL + "services/service.php?m=share&a=uploadsharefile&num=1",
        secureuri: false,
        fileElementId: 'file1',
        dataType:'json',
        success: (result) -> 
          renderImg(result['data'][0]['src'])
          setImgEditor()
          reRenderFileInput()
        error: (e)->
          alert e
      })

  reRenderFileInput = ->
    $('#file1').remove()
    new_input = $('<input data="test" type="file" id="file1" name="image[]">')
    new_input.on 'change', ->
      imageUpload()
    $('.img-adder').append(new_input)

  makeTag = (text)->
    span = $('<span class="pub-tag">' + 
                text +
                '<i class="icon icon-closepop"></icon>' 
             '</span>')
    $form_tags_input.before(span)
    span.find('.icon').on 'click', ->
      $(this).parent().remove()
  gentarateTags = ->
    $form_tags.each ->
      $(this).on 'click', ->
        if $(this).hasClass('unselected')
          makeTag($(this).text())
          $(this).removeClass('unselected')
        else
          $(this).addClass('unselected')

  ### popup ###
  $popup_close.on 'click', ->
    $blackbox.fadeOut(500)
  $popup_btn.on 'click', (e)->
    link = $popup_url.val()
    urlreg=/^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9\_\-]+\.[A-Za-z0-9\_\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/
    if (!urlreg.test(link))
      $(".urlwarning").html('请输入完整的链接地址')
      return false
    else
      $(".urlwarining")
        .css({color: '#00d0dc'})
        .html('正在获取信息...')

    obj = {
      url: encodeURIComponent(link),
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
          gentarateTags()
          g_expire = result['expire_time']
          if result['url_arr'].length > 0
            renderImg(SITE_URL + url) for url in result['url_arr']
            updateBg(SITE_URL + '/' + result['url_arr'][0])
          $('.url-img').first().find('img').addClass('main-img')
          renderStyle style for style in result['fengge_list']
          renderCatgory cate for cate in result['category_list']
          get2ndCate($form_cate_select.val()) 
          updatePreview(result)
          $blackbox.fadeOut(500)
          $('.item-list-filter').fadeOut(500)
          $('.item-list-container').fadeOut(500) 
          $('.form__container').fadeIn(500)
          setImgEditor()
    })
    e.preventDefault()

  ### form publish ###
  $form_title_input.on 'keyup', ->
    obj = {}
    obj['goods_name'] = $(this).val()
    updatePreview(obj)
  $form_price_input.on 'keyup', ->
    obj = {}
    obj['goods_price'] = $(this).val()
    updatePreview(obj)
  $form_tags_input.on 'keyup', (e)->
    if e.which == 188
      makeTag($(this).val().substring(0, $(this).val().length - 1))
      $(this).val('')
  $form_tags_input.on 'keydown', (e)-> 
    if $(this).val() == '' && (e.which == 8 || e.which == 46)
      if $(this).prev().is('span')
        $(this).prev().remove()
  
  $('#file1').on 'change', ->
    imageUpload()
    
  $form_submit_btn.on 'click', (e)->
    link    = $form_url_input.val()
    str = link.match(/http:\/\/.+/)
    if str == null
      link = 'http://'+ link;
    urlreg=/^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9\_\-]+\.[A-Za-z0-9\_\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/
    if (!urlreg.test(link))
      $(".warning").html('请输入完整的链接地址')
      return false
        
    title   = $form_title_input.val()
    if(title == '')
      $(".warning").html('<span style="color:#F00;">请填写分享名称</span>')
      return false

    price   = $form_price_input.val()
    if((price == '') || (price == 0) || isNaN(price))
      $(".warning").html('<span style="color:#F00;">请输入价格，填写数字</span>')
      return false

    catid   = $form_cate_select2.val()
    if catid == 0 || catid == ""
      $(".warning").html('<span style="color:#F00;">请选择分类</span>');
      return false;

    recommendation = $form_recommendation.val()
    if recommendation == ''
      $(".warning").html("请填写描述内容！")
      return false

    brand   = $form_brand_input.val()
    style   = $form_style_select.val()
    
    img_arr = []
    img_arr[0] = $('.main-img').attr('src')
    img_arr.push $(img).attr('src') for img in $('.url-img-processor').find('img').not('.main-img')
    tags = []
    tags.push $(tag).text() for tag in $('.pub-tag')

    img_info = {}
    ratioX = $draggable_bg.find('img').width() / $draggable_bg.find('img')[0].naturalWidth
    ratioY = $draggable_bg.find('img').height() / $draggable_bg.find('img')[0].naturalHeight
    deltaX = $draggable_bg.offset().left - 
        $draggable_bg.find('img').offset().left + 2 # 2px for border width
    deltaY = $draggable_bg.offset().top - 
        $draggable_bg.find('img').offset().top + 2
    img_info.x = ratioX * deltaX
    img_info.y = ratioY * deltaY

    obj = {
      'goods_name' :  title,
      'goods_price':  price,
      'catid'      :  catid,
      'pinpai'     :  brand,
      'fengge'     :  style,
      'img_arr'    :  img_arr,
      'expire'     :  g_expire,
      'content'    :  recommendation,
      'tags'       :  tags,
      'img_info'   :  img_info
    }
    $blackbox.fadeIn(500)
    $.ajax({
      url :  SITE_URL + 'services/service.php?m=share&a=share_save',
      type: 'post',
      data: obj,
      dataType: 'json',
      cache: false,
      success: (result)-> 
        if result.status == 1
          $('.emoji-hint').show()
          $('.empty-message').find('a').attr('href', result.url)
          $('.separator').show()
          $('.goods-link').find('label').show()
          $popup_loading.fadeOut(500)
          $popup.fadeIn(500)
    })
    e.preventDefault()
