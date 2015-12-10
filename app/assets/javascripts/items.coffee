$ ->
  #form
  #ref:http://stackoverflow.com/questions/17029399/clicking-back-in-the-browser-disables-my-javascript-code-if-im-using-turbolin
  $(document).on('page:restore', () ->
    init_tinymce('#item_description')
  )
  init_tinymce('#item_description')
  load_item_selections()

  $('#use_profile_address').on 'change', () ->
    if $(this).prop('checked')
      $('#item_address').val( $(this).val() )

  $('#item_deliver_ids_2').on 'change', () ->
    $('#item_address').prop('required', true) if $(this).prop('checked')

  $('#item_subcategory_id').on('change', ()->
    load_item_selections()
  )

  $(document).on('change', '.item_selection :input', ()->
    $(this).closest('.form-group').find(':input').not(this).prop('checked', false)
  )


  # index
  $('.item-bookmark').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr('href', data.href)
        .data('method', data.method)
        .attr('data-original-title', data.title)
        .removeClass('btn-default btn-danger').addClass(data.class)
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

#load item selection on items/form
@load_item_selections = ()->
  if $('#item_subcategory_id').size() > 0
    url = $('#item_subcategory_id').find('option:selected').data('href')
    # 找出 item 已選擇的 selections
    item_id = $('form.edit_item').data('item')
    param = $.param { item_id: item_id}
    url += '?' + param

    $container = $('#selections-container')
    $hide_container = $('#selections-hide')

    $container.html('')
    $hide_container.html('')

    $.get(url, (html)->
      $hide_container.html(html)
      html = $hide_container.find('#item-selections-list').html()
      $container.html(html)
      $hide_container.html('')
    )
