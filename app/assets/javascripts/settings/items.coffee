$ ->
  $(document).on('ajax:success', '#rent_records_list_container a[data-remote="true"], .rent-records-list', (e, data, status, xhr) ->
    back_link = '<div><a href="#" id="back_to_items" class="text-danger"><< 回到出租物列表</a></div><br />'
    $('#items-container').hide()
    $('#rent_records_list_container').html(back_link + data).show()
  )

  $(document).on('click', '#back_to_items', (e) ->
    $('#rent_records_list_container').hide()
    $('#items-container').show()
    return false
  )
