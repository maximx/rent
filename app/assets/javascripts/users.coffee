$ ->
  $('.unfollow-user').on('ajax:success', (e, data, status, xhr) ->
    $(this).closest('.follow-container').remove() if data.status == 'ok'
  )
