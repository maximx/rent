$ ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

  $('.file_with_image .avatar .edit_image').on 'click', () ->
    $(this).closest('.item').find(':file').click()

  $('form.ajax_image'). on 'change', '.avatar :file', () ->
    $(this).closest('form').submit()

  $('form.ajax_image').on 'ajax:complete', (e, data) ->
    data = $.parseJSON(data.responseText)
    if data.status == "ok"
      url = 'url(' + data.src + ')'
      $(this).find('.file_with_image .avatar .item').css('background-image', url)
