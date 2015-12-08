$ ->
  $('.follow-user').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr('href', data.href)
             .html(data.text)
             .data('method', data.method)
  )

  $('#bank_info_form').on 'ajax:success', (e, data, status, xhr) ->
    if data and data.status == 'ok'
      $alert_strong = $('.alert strong')
      text = ' 帳號資訊已成功更新，' + $alert_strong.text()

      $alert_strong.text(text)
      $('#bank_info_modal').modal('hide')
