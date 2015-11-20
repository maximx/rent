$ ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

  $('.file_with_image .item.edit .edit_image').on 'click', () ->
    $(this).closest('.item').find(':file').click()

  $('.file_with_image .item.edit :file').on 'change', () ->
    $(this).closest('form').submit()
