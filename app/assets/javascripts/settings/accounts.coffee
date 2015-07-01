settings_account_ready = ->
  init_tinymce('#profile_description')

$(document).on('page:load', settings_account_ready)
$(document).ready(settings_account_ready)
