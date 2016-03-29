initGoodsAsync = ->
  $goods_section = $('#homepage-wrap').find('section.goods')
  $goods_list = $goods_section.find '.item-list-container dl.big_img'
  $load_more = $('#dashboard-show-more')
  $goods_tabs = $goods_section.find('.section__tabs ul')
  $goods_tab = $goods_tabs.find 'li'
  $goods_list_recommend = $goods_list
  $goods_list_hot = ''
  $goods_list_new = ''

  is_loading_more = false

  # 点击我要看更多
  $load_more.click ->
    if !is_loading_more
      current_page = parseInt($('.item-list-container').find('dl.big_img.current').data('page'))
      $tab = $goods_tabs.find 'li.current'
      current_page++
      sort = $tab.data 'sort'
      loadMoreGoods(current_page, sort)

  # 点击分类标签
  $goods_tab.click ->
    $tab = $(this)
    $goods_tab.removeClass 'current'
    $tab.addClass 'current'
    sort = $tab.data 'sort'
    $('dl.big_img').hide().removeClass('current')

    if $('dl.big_img[data-sort="recommend"]').length is 0 then $goods_list_recommend = '' else $goods_list_recommend = $('dl.big_img[data-sort="recommend"]')
    if $('dl.big_img[data-sort="hot"]').length is 0 then $goods_list_hot = '' else $goods_list_hot = $('dl.big_img[data-sort="hot"]')
    if $('dl.big_img[data-sort="new"]').length is 0 then $goods_list_new = '' else $goods_list_new = $('dl.big_img[data-sort="new"]')

    if sort is 'recommend' and $goods_list_recommend isnt ''
      $goods_list_recommend.show().addClass('current')
    else if sort is 'hot' and $goods_list_hot isnt ''
      $goods_list_hot.show().addClass('current')
    else if sort is 'new' and $goods_list_new isnt ''
      $goods_list_new.show().addClass('current')
    else
      page = 1
      $goods_list = "<dl class='big_img current' style='display:block;' data-page='1' data-sort='#{sort}'></dl>"
      $('.item-list-container').prepend($goods_list)
      loadMoreGoods(page, sort)
    if $('.item-list-container').find('dl.big_img.current').data('page') isnt 3
      $load_more.parent().show()
      $load_more.html('我要看更多')

  # 函数：Ajax加载数据
  loadMoreGoods = (page, sort)->
    is_loading_more = true
    $load_more.html '正在努力加载中...'
    $.ajax {
      url: SITE_URL + 'services/service.php'
      type: "GET"
      data: {'m': 'index', 'a': 'get_more_index', 'page': page, 'limit': 12, 'sort': sort}
      cache: true
      dataType: "json"
      success: (result, status)->
        if result.status is 1
          drawGoods result.data
          $('.item-list-container').find('dl.big_img.current').data 'page', page
          $load_more.html '我要看更多'
          if page is 3
            $load_more.parent().hide()
        else if result.status is 0
          $load_more.html '沒有更多了'

      error: (xhr, status, error)->
        if status is 502
          alert('服务器君跑到外太空去了,刷新试试看!')
        $load_more.html('我要看更多').removeClass('loading')
    }

  # 函数：画商品格子
  drawGoods = (data)->
    for item, i in data
      if item.is_fav is 0
        isfav = 'icon-heart'
      else
        isfav = 'icon-hearted'
      goods_name = decodeURIComponent(item.goods_name)
      current_sort = $goods_tabs.find('li.current').data('sort')
      if current_sort is 'recommend'
        $list = $('dl.big_img[data-sort="recommend"]')
      else if current_sort is 'hot'
        $list = $('dl.big_img[data-sort="hot"]')
      else if current_sort is 'new'
        $list = $('dl.big_img[data-sort="new"]')

      dd = $(
        "<dd class='item homepage' i='#{item.share_id}'>" +
          "<div>" +
            "<div class='item-b_image'>" +
              "<a href='#{item.url}' target='_blank'>" +
                "<img src='#{item.img}' alt='#{goods_name}'>" +
              "</a>" +
            "</div>" +
            "<div class='item-b_description'>" +
              "<div class='item-b_title'>" +
                  "<a href='#{item.url}' target='_blank'>#{goods_name}</a>" +
              "</div>" +
              "<div class='item-b_price longer'>" +
                "<span>#{item.goods_price}</span>"+
              "</div>" +
            "</div>" +
            "<div class='item-b_additional'>"+
              "<a href='#{item.user_href}' title='#{item.user_name}'>"+
                "<img src='#{item.img_thumb}'>"+
              "</a>"+
              "<div class='item-value'>"+
                "<span class='icon icon-viewed'></span>"+
                "<span>#{item.weight}</span>"+
                "<span class='icon icon-comment--s'></span>"+
                "<span>#{item.comment_count}</span>"+
              "</div>"+
            "</div>"+
            "<div l='b' sid='#{item.share_id}' dtype='s' ed='0' class='item-b_add_like btn_like'>"+
              "<img src='' alt='' class='harting'>"+
              "<i class='icon #{isfav}'></i>"+
              "<span class='like_count'>#{item.collect_count}</span>"+
            "</div>"+
          "</div>"+
        "</dd>"
      )

      $list.append dd
      is_loading_more = false


  _doing_like = false

  $(document).on 'click','.btn_like', ->
    do_like($(this))

  do_like = (obj) ->
    _doing_like = true
    me = $(obj)
    sid = me.attr('sid')
#    dtype = me.attr('dtype')
    ed = me.attr('ed')
    method = "GET"

    job = 0

    if ed is '0'
      url = 'services/service.php?m=share&a=fav'
      job = 1
    else
      url = 'services/service.php?m=share&a=removefav'
      job = 2

    $.ajax {
      url: SITE_URL + url
      type: method
      data: {ajax: 1, 'id': sid}
      cache: false
      dataType: "json"
      success: (result)->
        after_like(me,result,job)
      error: (xhr,status,error)->
        if status isnt 0
          alert('服务器君跑到外太空去了,刷新试试看!')
        else
          alert(error)
    }

  after_like = (me,result,job) ->
    if result.status isnt 3
      if job is 1
        if result.status is 1 or result.status is 2
          ed = 1
          count = 1
      else if job is 2
        if result.status is 1
          ed = 0
          count = -1
      refresh_like(me.attr('sid'),ed,count)
    else
      alert('不可以喜欢自己发布的单品哦!')

  refresh_like = (sid,ed,count) ->
    $btn = $('.item-list-container').find(".btn_like[sid=#{sid}]")
    $like_count = $btn.find('.like_count')
    $big_harting = $btn.find('img.harting')
    $big_icon = $btn.find('i')
    harting_img_url = SITE_URL + '/tpl/hi1626/v2/images/icon-heart-ing.gif'

    like_count = parseInt($like_count.text()) + count
    $like_count.text(like_count)
    $btn.attr 'ed', ed

    if ed is 1
      $big_harting.attr('src',harting_img_url)
      $big_harting.show()
      $big_icon.css 'color','#ff006b'
      setTimeout ->
        $big_icon.removeClass('icon-heart').addClass('icon-hearted')
        $big_harting.attr('src','')
        $big_harting.hide()
        _doing_like = false
      , 1300
    else
      $big_icon.css 'color','grey'
      $big_harting.attr('src','')
      $big_icon.removeClass('icon-hearted').addClass('icon-heart')

