$ ->
  $('.mark-read').on 'ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $link = $(this).closest('.list-group-item').find('span.subject')
      $link.addClass('text-muted').html($link.text())
