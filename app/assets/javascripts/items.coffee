$ ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

  init_tinymce('#item_description')

  $('#item-calendar').click ()->
    $(this).tab('show')
    $('#calendar').fullCalendar('render')

  $('#item-container').wookmark
    autoResize: true
    container: $('.main-content')
    offset: 10
