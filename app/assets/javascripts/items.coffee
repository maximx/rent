$ ->
  #form
  #ref:http://stackoverflow.com/questions/17029399/clicking-back-in-the-browser-disables-my-javascript-code-if-im-using-turbolin
  $(document).on('page:restore', () ->
    init_tinymce('#item_description')
  )
  init_tinymce('#item_description')

  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

  # index
  $('.item-bookmark').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr("href", data.href).data("method", data.method)
        .removeClass("btn-default btn-danger").addClass(data.class)
  )

  $('.item-grid').closest('#item-container').wookmark
    autoResize: true
    offset: 15

  #show
  $('#rent[data-spy="affix"]').affix
    offset:
      top: 490
      bottom: () ->
        if $('#map').size() > 0
          $(document).height() - $('#map').offset().top + 15

  $('.form_date').on('blur', () ->
    submitAdvancedSearchForm() if checkFormDateInput()
  )

  $('#price_range').on('slide', () ->
    setPriceRange()
  ).on('slideStop', () ->
    submitAdvancedSearchForm() if checkFormDateInput()
  )

  $('#use_profile_address').on 'change', () ->
    if $(this).prop('checked')
      $('#item_address').val( $(this).val() )

@checkFormDateInput = () ->
  started_at = $('#started_at').val()
  ended_at = $('#ended_at').val()
  #all empty or all present
  return ( started_at == '' && ended_at == '' ) || ( started_at != '' && ended_at != '' )

@setPriceRange = (action = 'slide') ->
  $price_range = $('#price_range')
  range = $price_range.slider('getValue')

  min = range[0]
  $('#price_min').val(min)
  $('span.price_min').text(min)

  max = range[1]
  $('#price_max').val(max)
  $('span.price_max').text(max)

  if action == 'slideStop'
    $('#price_min').remove() if min == $price_range.data('slider-min')
    $('#price_max').remove() if max == $price_range.data('slider-max')


@removeInputName = () ->
  $('#advanced-search-form input').not('.price').each () ->
    $('#price_range').removeAttr('name')
    $(this).removeAttr('name') if $(this).val() == ''

@submitAdvancedSearchForm = () ->
  setPriceRange('slideStop')
  removeInputName()
  $('#advanced-search-form').submit()
