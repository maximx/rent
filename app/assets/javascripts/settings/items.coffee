$ ->
  $(document).on('ajax:success', '#rent_records_list_container a[data-remote="true"], .rent-records-list', (e, data, status, xhr) ->
    back_link = '<div><a href="#" id="back_to_items" class="text-danger"><< 回到出租物列表</a></div><br />'
    $('#items-container').hide()
    $('#rent_records_list_container').html(back_link + data).show()
    $(document).scrollTop(0)
  )

  $(document).on('click', '#back_to_items', (e) ->
    $('#rent_records_list_container').hide()
    $('#items-container').show()
    $(document).scrollTop(0)
    return false
  )

  $('#rent[data-spy="affix"').affix
    offset:
      top: 425
      bottom: $(document).height() - $('#map').offset().top + 15
