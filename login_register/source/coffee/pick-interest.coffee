initPickInterest = (category)->
  $pick_interest = $('.pick-interest')
  $bulk_action = $pick_interest.find('.bulk-actions')
  $pick_users = $('.pick-users')
  $tab_bar = $pick_users.find('.tabbar')
  $tab_panel = $pick_users.find('.tab__panel')

  #-------------- 函数: 画兴趣格仔 -----------------
  drawInterest = (item_data)->
    $item =
      "<li data-id='#{item_data.id}' data-title='#{item_data.seo_title}'>" +
        "<div class='thumb' style='background-image:url(#{item_data.img})'>" +
          "<div class='tick'><i class='icon icon-tick'></i></div>" +
        "</div>" +
        "<div class='desc'><h3>#{item_data.seo_title}</h3><p>#{item_data.seo_desc}</p></div>" +
        "</li>"
    $pick_interest.find('ul.categories').append $item

  for i in [0...10]
    drawInterest(category[i])

  #-------------- 函数: 检查选择数量 -----------------
  total_pick = 0
  checkTotalPick = ->
    if total_pick is 5
      $pick_interest.find('ul.categories li').each ->
        if !$(this).hasClass('selected')
          $(this).addClass('disabled').find('.thumb').css('opacity',0.4)
    else if total_pick < 5
      $pick_interest.find('ul.categories li').removeClass('disabled')
      $pick_interest.find('ul.categories li .thumb').css('opacity',1)

  #-------------- 函数: 画标签 -----------------
  appendCatTab = (cat_id,cat_title)->
    $tab_bar.find('.tab').removeClass('current')
    $tab = "<div class='tab current' cat-id='#{cat_id}'><span>#{cat_title}</span></div>"
    $tab_bar.append $tab

  #------------- 事件: 点击兴趣格仔 -----------------
  $pick_interest.on 'click','ul.categories li', ->
    $item     = $(this)
    cat_id    = $item.attr 'data-id'
    cat_title = $item.attr 'data-title'
    if !$item.hasClass('disabled')
      if total_pick < 6
        if !$item.hasClass('selected')
          $item.addClass('selected')
          total_pick++
          $tab_panel.find("ul.push-users").hide()
          if $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").length > 0
            $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").show()
          else
            getUserData(cat_id,1)
          appendCatTab(cat_id,cat_title)
        else
          $item.removeClass('selected')
          $remove_tab = $tab_bar.find(".tab[cat-id='#{cat_id}']")
          $prev_tab = $remove_tab.prev()
          $tab_bar.find('.tab').removeClass('current')
          $prev_tab.addClass('current')
          $tab_panel.find("ul.push-users").hide()
          $tab_panel.find("ul.push-users[cat-id='#{$prev_tab.attr('cat-id')}']").show()
          $tab_bar.find(".tab[cat-id='#{cat_id}']").remove()
          $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").hide()
          total_pick--
        checkTotalPick()

  #-------------- 函数: 画用戶格仔 -----------------
  drawPushUser = (user_data,cat_id)->
    $user =
      "<li>" +
        "<div class='avatar'><img src='#{user_data.img_thumb}' alt='#{user_data.user_name}'/></div>" +
        "<div class='nickname'>#{user_data.user_name}</div>" +
        "<div class='relations'>" +
          "<span class='fans'><b>#{user_data.fans}</b>粉丝</span><span class='follows'><b>#{user_data.follows}</b>关注</span>" +
        "</div>" +
        "<div class='follow-btn'>" +
          "<div class='slider'><i class='icon icon-follow'></i><a class='status_text'>关注Ta</a></div>" +
          "<div class='slider-btn'></div>" +
        "</div>" +
      "</li></ul>"
    $pick_interest.find("ul.push-users[cat-id='#{cat_id}']").append $user
    $bulk_action.show()

  getUserData = (cat_id,page)->
    id = parseInt(cat_id)
#    result = '{"data":[{"uid":"237004","img_thumb":"http:\/\/192.168.0.230\/public\/upload\/avatar\/noavatar_big.jpg","user_name":"laoxu@laoxu.com","introduce":"","follows":"0","fans":"0","user_href":"http:\/\/192.168.0.230\/u\/talk-237004.html","newest_publish":[]},{"uid":"237005","img_thumb":"http:\/\/192.168.0.230\/public\/upload\/avatar\/noavatar_big.jpg","user_name":"2@qq.com","introduce":"","follows":"0","fans":"0","user_href":"http:\/\/192.168.0.230\/u\/talk-237005.html","newest_publish":[]},{"uid":"237059","img_thumb":"http:\/\/192.168.0.230\/public\/upload\/avatar\/noavatar_big.jpg","user_name":"a_9789686","introduce":"","follows":"0","fans":"0","user_href":"http:\/\/192.168.0.230\/u\/talk-237059.html","newest_publish":[]},{"uid":"237062","img_thumb":"http:\/\/192.168.0.230\/public\/upload\/avatar\/noavatar_big.jpg","user_name":"a_0108918","introduce":"","follows":"0","fans":"0","user_href":"http:\/\/192.168.0.230\/u\/talk-237062.html","newest_publish":[]},{"uid":"237088","img_thumb":"http:\/\/192.168.0.230\/public\/upload\/avatar\/noavatar_big.jpg","user_name":"1626_8936204","introduce":"","follows":"0","fans":"0","user_href":"http:\/\/192.168.0.230\/u\/talk-237088.html","newest_publish":[]}]}'
#    $user_list = "<ul class='push-users' cat-id='#{cat_id}'></ul>"
#    $pick_interest.find('.tab__content').append $user_list
#    for user in $.parseJSON(result).data
#      drawPushUser(user,cat_id)
    $.ajax {
      url: SITE_URL + 'services/service.php?m=u&a=get_approve_user_ajax'
      type: "GET"
      data: {tag:id,page:page,limit:5,follow:0}
      cache: false
      dataType: "json"
      success: (result)->
        $user_list = "<ul class='push-users' cat-id='#{cat_id}'></ul>"
        $pick_interest.find('.tab__content').append $user_list
        for user in result.data
          drawPushUser(user,cat_id)
      error: (result)->
        alert result
    }
  getUserData(0,1)

  #------------- 事件: 点击侧栏标签 -----------------
  $pick_users.on 'click','.tabbar .tab', ->
    $tab = $(this)
    cat_id = $tab.attr 'cat-id'
    $tab_panel.find("ul.push-users").hide()
    $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").show()
    $tab_bar.find('.tab').removeClass('current')
    $tab.addClass('current')