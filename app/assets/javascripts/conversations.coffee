$ ->
  $('.mark-read').on 'ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $list = $(this).closest('.list-group-item')

      $link = $list.find('span.subject')
      $link.html($link.text())

      $list.find('.pull-right a').tooltip('hide').remove()
