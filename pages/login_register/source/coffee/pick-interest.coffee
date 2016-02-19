initPickInterest = (category,is_new_user)->
  $pick_interest = $('.pick-interest')
  $bulk_action = $pick_interest.find('.bulk-actions')
  $pick_category = $pick_interest.find('.pick-category')
  $pick_users = $('.pick-users')
  $tab_bar = $pick_users.find('.tabbar')
  $tab_panel = $pick_users.find('.tab__panel')
  is_new_user = is_new_user or true

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
    $('.slider-btn').hide()
    $item     = $(this)
    cat_id    = $item.attr 'data-id'
    cat_title = $item.attr 'data-title'
    if !$item.hasClass('disabled')
      if total_pick < 6
        if !$item.hasClass('selected')
          $item.addClass('selected')
          total_pick++
          $tab_panel.find("ul.push-users").hide().removeClass('current')
          if $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").length > 0
            $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").show().addClass('current')
          else
            getUserData(cat_id,1)
          appendCatTab(cat_id,cat_title)
        else
          $item.removeClass('selected')
          $remove_tab = $tab_bar.find(".tab[cat-id='#{cat_id}']")
          current_tab_id = $tab_bar.find('.tab.current').attr('cat-id')
          if cat_id is current_tab_id
            $prev_tab = $remove_tab.prev()
            $tab_bar.find('.tab').removeClass('current')
            $prev_tab.addClass('current')
            $tab_panel.find("ul.push-users").hide().removeClass('current')
            $tab_panel.find("ul.push-users[cat-id='#{$prev_tab.attr('cat-id')}']").show().addClass('current')
          $tab_bar.find(".tab[cat-id='#{cat_id}']").remove()
          $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").hide().removeClass('current')
          total_pick--
        checkTotalPick()

  #-------------- 函数: 画用戶格仔 -----------------
  drawPushUser = (user_data,cat_id)->
    status_text = ''
    status_icon = ''
    status_btn = ''
    if user_data.is_follow is 1
      status_btn = 'slider--on'
      status_icon = 'icon-followed'
      status_text = '已关注'
    else if user_data.is_follow is 2
      status_btn = 'slider--on'
      status_icon = 'icon-friends'
      status_text = '互相关注'
    else
      status_text = '关注Ta'
      status_icon = 'icon-follow'
    $user =
      "<li uid='#{user_data.uid}'>" +
        "<div class='avatar'><img src='#{user_data.img_thumb}' alt='#{user_data.user_name}'/></div>" +
        "<div class='nickname'>#{user_data.user_name}</div>" +
        "<div class='relations'>" +
          "<span class='fans'><b>#{user_data.fans}</b>粉丝</span><span class='follows'><b>#{user_data.follows}</b>关注</span>" +
        "</div>" +
#        "<div class='follow-btn fans__follow-btn'>" +
#          "<div class='slider'><i class='icon icon-follow'></i><a class='status_text'>关注Ta</a></div>" +
#          "<div class='slider-btn'></div>" +
#        "</div>" +
        "<div class='fans__follow-btn follow-btn #{status_btn}' follow-status='#{user_data.is_follow}'>" +
          "<div class='slider'>" +
          "<i class='icon #{status_icon}'></i>" +
          "<a class='status_text'>#{status_text}</a>" +
          "</div>" +
          "<div class='slider-btn'></div>" +
        "</div>" +
      "</li></ul>"
    $pick_interest.find("ul.push-users[cat-id='#{cat_id}']").append $user
    $bulk_action.show()

  getUserData = (cat_id,page)->
    id = parseInt(cat_id)
    if is_new_user
      follow = 0
    else
      follow = 1
    $.ajax {
      url: SITE_URL + 'services/service.php?m=u&a=get_approve_user_ajax'
      type: "GET"
      data: {tag:id,page:page,limit:5,follow:follow}
      cache: false
      dataType: "json"
      success: (result)->
        $user_list = "<ul class='push-users current' cat-id='#{cat_id}' page='#{page}'></ul>"
        $pick_interest.find('.tab__content').append $user_list
        for user in result.data
          drawPushUser(user,cat_id)
      error: (xhr,statue,error)->
        alert error
    }
  getUserData(0,1)

  #------------- 事件: 点击侧栏标签 -----------------
  $pick_users.on 'click','.tabbar .tab', ->
    $('.slider-btn').hide()
    $tab = $(this)
    cat_id = $tab.attr 'cat-id'
    $tab_panel.find("ul.push-users").hide()
    $tab_panel.find("ul.push-users").removeClass('current')
    $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").show()
    $tab_panel.find("ul.push-users[cat-id='#{cat_id}']").addClass('current')
    $tab_bar.find('.tab').removeClass('current')
    $tab.addClass('current')

  #------------- 初始化关注按钮 -----------------
  initFollowBtn()

  #------------- 换一批 -----------------
  $pick_users.find('.refresh').click ->
    $current_list = $('.push-users.current')
    cat_id = parseInt($current_list.attr('cat-id'))
    page = parseInt($current_list.attr('page')) + 1
    $current_list.remove()
    getUserData(cat_id,page)

  #---------------
  $('.submit-interest button').click ->
    interests = ''
    $selected = $pick_category.find('li.selected')
    $selected.each ->
      $item = $(this)
      interests = interests + $item.attr('data-id') + ','
    $.ajax {
      url: SITE_URL + '/services/service.php?m=user&a=set_user_label'
      type: "GET"
      data: {tag_ids:interests}
      cache: false
      dataType: "json"
      success: (result)->
        if result.status is 1
          showSmallErrorTip('提交成功！<br/>即将跳转到首页',1)
          setTimeout(->
            window.location.href = SITE_URL
          , 2000)
        else
          showSmallErrorTip('请先选择兴趣',0)
      error: (result)->
        showSmallErrorTip result.msg
    }