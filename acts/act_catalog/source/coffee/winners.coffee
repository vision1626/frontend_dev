initWinners = (data)->
  $winner_panel = $('#catalog').find('section.winners')
  $tab_panels = $winner_panel.find('.tab-panels')
  $tab = $winner_panel.find('.tab')
  $list_bj = $winner_panel.find('.list.bj')
  $list_sh = $winner_panel.find('.list.sh')
  $panel_bj = $winner_panel.find('.panel.bj')
  $panel_sh = $winner_panel.find('.panel.sh')

  $tab.click ->
    ele = $(this)
    $tab.removeClass 'current'
    ele.addClass 'current'
    $tab_panels.scrollTop(0)
    if ele.hasClass 'bj'
      $panel_bj.show()
      $panel_sh.hide()
    else
      $panel_bj.hide()
      $panel_sh.show()

#  data = '[{"email":"sdkjf333@fdkf.com","author":"阿中三号","location":"1"},{"email":"sdkjf333@fdkf.com","author":"阿中一号","location":"1"},{"email":"sdkjf333@fdkf.com","author":"阿中二号","location":"2"},{"email":"sdkjf333@fdkf.com","author":"李治中","location":"2"},{"email":"sdkjf333@fdkf.com","author":"裏追隨","location":"1"}]'
  data = $.parseJSON data
  for d in data
    phone = d.mobile.substring(0,5) + '******'
    email_1 = d.email.split('@')[0]
    email_1 = email_1.substring(0, email_1.length - 3) + '***'
    email_2 = d.email.split('@')[1]

    item = $("<div class='item'><span>#{d.author}</span><span>#{phone}</span><span class='email'>#{email_1}@#{email_2}</span></div>")
    if d.location is '1'
      $list_bj.append item
    else
      $list_sh.append item
