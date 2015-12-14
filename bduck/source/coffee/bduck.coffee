init = ->
  $invite_btn = $('.invitation-btn').find('img')
  $share = $('.share')
  $rules_btn = $('.rules-btn')
  $rules = $('.rules')
  $black_box = $('.black-box')

  $invite_btn.on 'click', ->
    $share.css({'left': 'auto'})
  $rules_btn.on 'click', (event)->
    $rules.css({'left': 'auto'})
    event.stopPropagation()
  $black_box.on 'click', (e)->
    $(this).css({'left': '-1626em'})
    event.stopPropagation()
   