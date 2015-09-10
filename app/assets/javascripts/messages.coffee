$ ->
  $('#message_form').on 'ajax:success', (e, data, status, xhr) ->
    if data && data.status == 'ok'
      $(this).find('textarea').val('')
      $('#message_form_success').removeClass('hide').find('code').text(data.message)
      $('#messages_modal').modal('hide')
    else
      $('#message_body').closest('.form-group').find('.hint-error').html(data.message)
