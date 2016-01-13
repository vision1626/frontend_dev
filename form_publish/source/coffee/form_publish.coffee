init_form_publish = ->
  g_expire = ''

  $popup_close = $('.popup__close')
  $blackbox = $('.popup__blackbox')
  $popup = $('.popup')
  $popup_btn = $blackbox.find('button')
  $popup_url = $blackbox.find('input[name=url]')
  $popup_loading = $blackbox.find('.popup__loading');
  $popup_manually_upload = $blackbox.find('.manually-upload')
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
  $form_tags = $form_publish.find('.mytags')
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

  generateImg = (url)->
    img = $('<img src='+ url.substring() + '>')
    img_wrapper = $('<div class="url-img"></div>')
    img_editor = $('<div class="img-editor">' +
                     '<span>设为主图</span>' +
                     '<i class="icon icon-closepop"></i>' +
                   '</div>')
    img_wrapper.append(img_editor)
    img_wrapper.append(img)
    $img_adder.before(img_wrapper)

  generateStyle = (style)->
    option = $('<option>' + style + '</option>')
    $form_style_select.append(option)

  generateCategory = (category)->
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
        getImgLength()
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
    len = $('.url-img').length
    if $('.url-img').length >= 6
      $('.img-adder').hide()
    else
      $('.img-adder').show()

    if len == 0
      $('.img-adder').css('margin-left': 0)
    else 
      $('.img-adder').css('margin-left': '7.9px')

    $('.url-img').css('margin-right': '7.9px')
    $('.url-img').last().css('margin-right': 0)
    return len

  imageUpload = ->
    if getImgLength() == 6
      alert '已经不能再上传了'
      regenerateFileInput()
    else 
      $.ajaxFileUpload({
        url: SITE_URL + "services/service.php?m=share&a=uploadsharefile&num=1",
        secureuri: false,
        fileElementId: 'file1',
        dataType:'json',
        success: (result) -> 
          generateImg(result['data'][0]['src'])
          setImgEditor()
          regenerateFileInput()
          updateBg(result['data'][0]['src'])
          getImgLength()
        error: (e)->
          alert e
      })

  regenerateFileInput = ->
    $('#file1').remove()
    new_input = $('<input data="test" type="file" id="file1" name="image[]">')
    new_input.on 'change', ->
      imageUpload()
    $('.img-adder').append(new_input)

  makeTag = (text, id)->
    span = $('<span class="pub-tag" data-id="' + id +  '">' + 
                text +
                '<i class="icon icon-closepop"></icon>' 
             '</span>')
    $form_tags_input.before(span)
    span.find('.icon').on 'click', ->
      $form_tags.find('li[data-id="' + $(this).parent().attr('data-id') + '"]')
                .removeClass('selected')
                .addClass('unselected')
      $(this).parent().remove()
  getMyTagName = (tag)->
    li = $('<li class="unselected" data-id="' + tag['tag_id'] + '">' + 
            tag['tag_name'] + 
          '</li>')
    $form_tags.append(li)
    li.on 'click', ->
      if $(this).hasClass('unselected')
        makeTag $(this).text(), $(this).attr('data-id')
        $(this).removeClass('unselected')
               .addClass('selected')
      else
        return false

  refreshForm = ->
    # refresh everything
    $form_publish.find('input').each ->
      $(this).val('')
    $form_publish.find('select').each ->
      $(this).find('option').remove()
    $form_imgs_wrapper.find('.url-img').remove()
    $('.item-tags').find('span').remove()
    $form_tags.find('li').not('.tag-title').remove()
    $form_recommendation.val('')

    $preview_title.html('商品标题')
    $preview_price.html('¥0.00')
    $draggable_bg.find('img').remove()

    $popup_url.val('')
    # $('.urlwarning').html('')

  ### popup ###
  $popup_close.on 'click', ->
    $blackbox.fadeOut(500)
    $('.emoji-hint').hide()
    $('.separator').hide()
    $('.goods-link').find('label').hide()
    toggleGoods(true)
  $popup_manually_upload.on 'click', ->
    $('.urlwarning').html('正在获取信息...')
    $.ajax({
      url: SITE_URL + "services/service.php?m=share&a=get_category_and_tags",
      type: 'get',
      dataType: 'json',
      success: (result)->
        generateCategory cate for cate in result['category']
        get2ndCate($form_cate_select.val())
        getMyTagName tag for tag in result['tags']
        generateStyle style for style in result['style'][0]['content'].split(',')
        $blackbox.fadeOut(500)
        toggleGoods(false)
        $('.urlwarning').html('')
    })

  $popup_btn.on 'click', (e)->
    link = $popup_url.val()
    urlreg=/^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9\_\-]+\.[A-Za-z0-9\_\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/
    if (!urlreg.test(link))
      $(".urlwarning").html('请输入完整的链接地址')
      return false

    obj = {
      url: encodeURIComponent(link),
      type: 'local'
    }
    $popup.hide()
    $popup_loading.show()
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
          if result['url_arr'] && result['url_arr'].length > 0
            generateImg(SITE_URL + url) for url in result['url_arr']
            updateBg(SITE_URL + '/' + result['url_arr'][0])
          $('.url-img').first().find('img').addClass('main-img')
          generateStyle style for style in result['fengge_list']
          generateCategory cate for cate in result['category_list']
          getMyTagName tag for tag in result['tags']
          get2ndCate($form_cate_select.val()) 
          updatePreview(result)
          setImgEditor()
          $blackbox.fadeOut(500)
          toggleGoods(false)
        else if result.status == 2
          $popup_loading.hide()
          $popup.show()
          $(".urlwarning").html('该单品已经发布过啦<a href="' +
            result.url + '">去看看</a>')
        else
          $popup_loading.hide()
          $popup.show()
          $(".urlwarning").html('数据读取失败，请输入正确商品链接！')
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
  $preview.find('.icon').on 'click', (e)->
    e.stopPropagation()
    return false 

  $form_publish.find('.reload').on 'click', (e)->
    link = $form_url_input.val()
    urlreg=/^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9\_\-]+\.[A-Za-z0-9\_\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/
    if (!urlreg.test(link))
      $(".form-urlwarning").html('请输入完整的链接地址')
      return false
    else
      $(".form-urlwarning").html('读取链接信息中...')
      $form_imgs_wrapper.find('.url-img').remove()
    
    obj = {
      url: encodeURIComponent(link),
      type: 'local'
    }
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
          if result['url_arr'] && result['url_arr'].length > 0
            generateImg(SITE_URL + url) for url in result['url_arr']
            updateBg(SITE_URL + '/' + result['url_arr'][0])
          $('.url-img').first().find('img').addClass('main-img')
          updatePreview(result)
          setImgEditor()
          $(".form-urlwarning").html('')
        else if result.status == 2
          $(".form-urlwarning").html('该单品已经发布过啦')
        else if result.status == (-1)
          $(".form-urlwarning").html('暂不支持该平台')
        else
          $(".form-urlwarning").html('链接输入有误 请重新输入')
    })
    e.preventDefault()
    
  $form_submit_btn.on 'click', (e)->
    link = $form_url_input.val()
    str = link.match(/http:\/\/.+/)
    if str == null
      link = 'http://'+ link;
    urlreg=/^((https|http|ftp|rtsp|mms)?:\/\/)+[A-Za-z0-9\_\-]+\.[A-Za-z0-9\_\-]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/
    if (!urlreg.test(link))
      $(".warning").html('请输入完整的链接地址')
      return false
        
    title = $form_title_input.val()
    if(title == '')
      $(".warning").html('<span style="color:#F00;">请填写分享名称</span>')
      return false

    price = $form_price_input.val()
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

    brand = $form_brand_input.val()
    style = $form_style_select.val()
    
    img_arr = []
    img_arr[0] = $('.main-img').attr('src')
    img_arr.push $(img).attr('src') for img in $('.url-img-processor').find('img').not('.main-img')
    tags = []
    tags.push $(tag).text() for tag in $('.pub-tag')

    img_info = {}
    deltaX = $draggable_bg.offset().left - 
        $draggable_bg.find('img').offset().left + 2 # 2px for border width
    deltaY = $draggable_bg.offset().top - 
        $draggable_bg.find('img').offset().top + 2
    ratioX = deltaX / $draggable_bg.find('img').width()
    ratioY = deltaY / $draggable_bg.find('img').height()
    img_info.x = ratioX * $draggable_bg.find('img')[0].naturalWidth
    img_info.y = ratioY * $draggable_bg.find('img')[0].naturalHeight

    obj = {
      'goods_link' :  link,
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
          $('.urlwarning').html('')
          $popup_loading.hide()
          $popup.fadeIn(500)
          $form_url_input.val('')
          $('.urlwarining').html('')
          refreshForm()
    })
    e.preventDefault()
