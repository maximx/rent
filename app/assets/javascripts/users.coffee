$ ->
  $('.unfollow-user').on('ajax:success', (e, data, status, xhr) ->
    console.log "hi"
    $(this).closest('.follow-container').remove() if data.status == 'ok'
  )
