$ ->
  $('#profile_send_mail').on 'change', ()->
    $icon = $(this).closest('.form-group').find('.hint .glyphicon')
    $icon.removeClass('glyphicon-ok hide').addClass('glyphicon-refresh')
    $(this).closest('form').submit()
