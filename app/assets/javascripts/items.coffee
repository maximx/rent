$(document).ready ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
  )
