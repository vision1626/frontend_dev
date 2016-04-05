_submiting = false
initTouch = ->
  FastClick.attach(document.body)
  $(document).on 'touchstart','.touchable', ->
    ele = $(this)
    ele.addClass 'touched'

  $(document).on 'touchend', '.touchable', ->
    ele = $(this)
    ele.removeClass 'touched'

  $(document).on 'touchend', '.submit', ->
    if !_submiting
      validate_result = formValidate($('.username'),$('.mobile'))
      if !validate_result
        _submiting = true
        submit_info = $.ajax {
          url: SITE_URL + 'absolut/submit.html'
          type: "POST"
          data: {name:$('.username').val(),mobile:$('.mobile').val()}
          cache: true
          dataType: "json"
          success: (result,status,response)->
            if result.status is 1
              alert('提交成功')
              $('.final').find('input').css('opacity',0)
              $('.submit').hide()
              $('.again').css('display','block')
            else
              alert(result.msg)
            _submiting = false
          error: (xhr,status,error)->
            alert('error:'+ status)
            _submiting = false
        }
      else
        alert(validate_result)

  $(document).on 'touchend', '.again', ->
    location.reload()