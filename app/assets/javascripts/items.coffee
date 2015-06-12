$(document).ready ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
  )

  $('.nav-tabs a[data-toggle=tab]').click ->
    window.location.hash = this.hash
