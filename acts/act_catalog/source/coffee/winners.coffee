initWinners = (data)->
  $winner_panel = $('#catalog').find 'section.winners'
  $tab = $winner_panel.find '.tab'
  $list_bj = $winner_panel.find '.list.bj'
  $list_sh = $winner_panel.find '.list.sh'
  $tab.click ->
    ele = $(this)
    $tab.removeClass 'current'
    ele.addClass 'current'
    if ele.hasClass 'bj'
      $list_bj.show()
      $list_sh.hide()
    else
      $list_bj.hide()
      $list_sh.show()

  data = $.parseJSON data
  for d in data
    phone = d.mobile.substring(0,5) + '******'
    item = $("<div class='item'><span>#{d.author}</span><span>#{phone}</span></div>")
    if d.location is '1'
      $list_bj.append item
    else
      $list_sh.append item
