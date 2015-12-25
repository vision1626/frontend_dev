big_DashboardItem_Generater = (data,current_index) ->
  if data.dynamic_type is 1
    sid = data.dapei_id
    dtype = 'd'
  else
    sid = data.share_id
    dtype = 's'

  dd = $('<dd class="item ' + sid + '" i="' + current_index + '" dtype="' + dtype + '">' +
      '<div>' +
      (if data.dynamic_type is 1
        '<div class="item-l_image">' +
          '<a href="' + data.url + '">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
          '<dl class="collocation">' +
          (
            goods = []
            for g in data.goods
              goods.push ('<dd class="collocation_item">' +
                '<div class="goods_item">' +
                '<a href="' + g.url + '">' +
                '<img src="' + g.img + '" alt=""/>' +
                '</a>' +
                '</div>' +
                '</dd>')
            goods.join ''
          ) +
          '</dl>' +
        '</div>' +
        '<div class="item-b_description">' +
          '<div class="item-b_isnew">' +
          (
            if data.is_dapei_like is 1 or data.like_user_list
              (
                for lu in data.like_user_list
                  '<span>'+
                    '<a href="' + lu.user_href + '">' +
                      lu.user_name +
                    '</a>' +
                  '</span>'
              )+
                '<span> 喜欢此搭配</span>'
            else
              '<span class="item_tag">NEW</span>' +
              '<span>新发布</span>'
          ) +
          '</div>' +
        '</div>'
      else
        '<div class="item-b_image">' +
          '<a href="' + data.url + '">' +
            '<img src="' + data.img + '" alt="' + data.title + '"/>' +
          '</a>' +
        '</div>' +
        '<div class="item-b_description">' +
          '<div class="item-b_isnew">' +
          (
            if data.is_share_fav is 1 or data.like_user_list
              (
                for lu in data.like_user_list
                  '<span>'+
                    '<a href="' + lu.user_href + '">' +
                      lu.user_name +
                    '</a>' +
                  '</span>'
              )+
                '<span> 喜欢此单品</span>'
            else
              '<span class="item_tag">NEW</span>' +
              '<span>新发布</span>'
          ) +
          '</div>' +
          '<div class="item-b_title">' +
            '<span>' + data.title + '</span>' +
          '</div>' +
          '<div class="item-b_price">' +
            '<span>¥' + data.goods_price + '</span>' +
          '</div>' +
        '</div>'
      ) +

      '<div class="item-b_additional">' +
        '<a href="' + data.user_href + '">' +
          '<img src="' + data.img_thumb + '"/>' +
        '</a>' +
      '<div class="item-value">' +
        '<span class="icon icon-viewed"></span>' +
        '<span>' + data.view_count + '</span>' +
        '<span class="icon icon-comment"></span>' +
        '<span>' + data.comment_count + '</span>' +
      '</div>' +
      '</div>' +
      '<div class="item-b_add_like btn_like" sid="' + sid + '" dtype="' + dtype + '"  ed="' + data.is_fav + '">' +
        '<a>' +
          '<span class="icon icon-heart"></span>' +
          '<br/>' +
          '<span class="like_count">' +
            data.like_total +
          '</span>' +
        '</a>' +
      '</div>' +
    '</div>' +
  '</dd>')

small_DashboardItem_Generater = (data,current_index) ->
  if data.dynamic_type is 1
    sid = data.dapei_id
    dtype = 'd'
  else
    sid = data.share_id
    dtype = 's'

  dd = $('<dd class="item ' + sid + '" i="' + current_index + '" dtype="' + dtype + '">' +
      '<div>' +
        '<div class="item-s_image">' +
        '<img src="' + data.img_small + '" alt="' + data.title + '"/>' +
      '</div>' +
      '<div class="item-s_description">' +
        '<div class="item-s_owner">' +
          '<a href="' + data.user_href + '">' +
            '<img src="' + data.img_thumb + '"/>' +
          '</a>' +
        '</div>' +
        '<div class="item-s_action">' +
          '<a class="action-add_special">' +
            '<span class="icon icon-album"></span>' +
          '</a>' +
          '<a class="action-add_like btn_like" sid="' + sid + '" dtype="' + dtype + '" ed="' + data.is_fav + '">' +
            '<span class="icon icon-heart"></span>' +
          '</a>' +
        '</div>' +
        (
          if data.dynamic_type is 1
            '<div class="item-s_isnew">' +
              (
                if data.is_dapei_like is 1 or data.like_user_list
                  (
                    for lu in data.like_user_list
                      '<span>'+
                        '<a href="' + lu.user_href + '">' +
                        lu.user_name +
                        '</a>' +
                        '</span>'
                  )+
                    '<span> 喜欢了</span>'
                else
                  '<span>NEW</span>'
              ) +
              '</div>' +
              '<dl class="collocation">' +
              (
                for g in data.goods
                  '<dd class="collocation_item">' +
                    '<div class="goods_item">' +
                    '<a href="' + g.url + '">' +
                    '<img src="' + g.img + '" alt=""/>' +
                    '</a>' +
                    '</div>' +
                    '</dd>'
              ) +
              '</dl>'
          else
            '<div class="item-s_isnew">' +
              (
                if data.is_share_fav is 1 or data.like_user_list
                  (
                    for lu in data.like_user_list
                      '<span>'+
                        '<a href="' + lu.user_href + '">' +
                        lu.user_name +
                        '</a>' +
                        '</span>'
                  )+
                    '<span> 喜欢了</span>'
                else
                  '<span>NEW</span>'
              ) +
              '</div>' +
              '<div class="item-s_title">' +
              '<a href="' + data.url + '">' +
              '<span>' + data.title + '</span>' +
              '</a>' +
              '</div>' +
              '<div class="item-s_price">' +
              '<span>¥' + data.goods_price + '</span>' +
              '</div>'
        ) +
        '<div class="item-s_additional">' +
          '<span class="icon icon-viewed"></span>' +
          '<span class="count">' + data.view_count + '</span>' +
          '<span class="icon icon-hearted"></span>' +
          '<span class="count">' + data.like_total + '</span>' +
          '<span class="icon icon-comment"></span>' +
          '<span class="count">' + data.comment_count + '</span>' +
        '</div>' +
      '</div>' +
    '</dd>')
