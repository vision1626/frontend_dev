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
  $draggable_bg = $preview.find('.item-b_image')
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

  updateBg = (url)->
    $draggable_bg.css({
      'background': 'url("' + url + '") no-repeat center center',
      'background-size': 'cover'
    })

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
          gentarateTags()
          g_expire = result['expire_time']
          if result['url_arr'].length > 0
            renderImg url for url in result['url_arr']
            updateBg(SITE_URL + '/' + result['url_arr'][0])
          $('.url-img').first().find('img').addClass('main-img')
          renderStyle style for style in result['fengge_list']
          renderCatgory cate for cate in result['category_list']
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
  $img_adder.on 'click', ->
    if getImgLength() == 5
      alert '已经不能再上传了'
    else 
      $.ajaxFileUpload({
        url: SITE_URL + "services/service.php?m=share&a=uploadsharefile&num=1",
        secureuri: false,
        fileElementId: 'file1',
        dataType:'json',
        success: (result) ->
          alert "result" + result
        error: (e)->
          alert err for err in e
      })
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
    alert tags
    obj = {
      'goods_name' :  title,
      'goods_price':  price,
      'catid'      :  catid,
      'pinpai'     :  brand,
      'fengge'     :  style,
      'img_arr'    :  img_arr,
      'expire'     :  g_expire,
      'content'    :  recommendation
      'tags'       :  tags
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
