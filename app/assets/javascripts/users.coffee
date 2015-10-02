$ ->
  $('.follow-user').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr('href', data.href)
             .html(data.text)
             .data('method', data.method)
  )
