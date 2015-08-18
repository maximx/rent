$ ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

  $('.item-bookmark').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr("href", data.href).data("method", data.method)
        .removeClass("btn-default btn-danger").addClass(data.class)
  )

  init_tinymce('#item_description')

  $('#item-calendar').click ()->
    $(this).tab('show')
    $('#calendar').fullCalendar('render')

  $('.item-grid').closest('#item-container').wookmark
    autoResize: true
    offset: 15

  $('#rent[data-spy="affix"]').affix
    offset:
      top: 490
      bottom: () ->
        if $('#map').size() > 0
          $(document).height() - $('#map').offset().top + 15

  $('#price_range').on 'slideStop', () ->
    setPriceRange()
    removeInputName()
    $('#advanced-search-form').submit()


@setPriceRange = () ->
  $price_range = $('#price_range')
  range = $price_range.slider('getValue')

  min = range[0]
  max = range[1]

  $('#price_min').val(min)
  $('#price_max').val(max)

  $('#price_min').remove() if min == $price_range.data('slider-min')
  $('#price_max').remove() if max == $price_range.data('slider-max')


@removeInputName = () ->
  $('#advanced-search-form input').not('.price').each () ->
    $('#price_range').removeAttr('name')
    $(this).removeAttr('name') if $(this).val() == ''
