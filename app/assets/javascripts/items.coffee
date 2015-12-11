$ ->
  #form
  #ref:http://stackoverflow.com/questions/17029399/clicking-back-in-the-browser-disables-my-javascript-code-if-im-using-turbolin
  $(document).on('page:restore', () ->
    init_tinymce('#item_description')
    wookmark_item()
  )
  init_tinymce('#item_description')
  wookmark_item()

  subcategory_selects = '#item_subcategory_id, select.filter-subcategory'
  load_item_selections($(subcategory_selects))

  $('#use_profile_address').on 'change', () ->
    if $(this).prop('checked')
      $('#item_address').val( $(this).val() )

  $('#item_deliver_ids_2').on 'change', () ->
    $('#item_address').prop('required', true) if $(this).prop('checked')

  $(subcategory_selects).on('change', ()->
    load_item_selections($(this))
    submitAdvancedSearchForm()
  )

  $(document).on('change', '.edit_item .item_selection :checkbox, .new_item .item_selection :checkbox', ()->
    $(this).closest('.form-group').find(':input').not(this).prop('checked', false)
  )

  #show
  $('#rent[data-spy="affix"]').affix
    offset:
      top: 490
      bottom: () ->
        if $('#map').size() > 0
          $(document).height() - $('#map').offset().top + 15


  # action index, search
  $('.item-bookmark').on('ajax:success', (e, data, status, xhr) ->
    if data.status == 'ok'
      $(this).attr('href', data.href)
        .data('method', data.method)
        .attr('data-original-title', data.title)
        .removeClass('btn-default btn-danger').addClass(data.class)
  )

  $('.form_date').on('blur', () ->
    submitAdvancedSearchForm()
  )

  $('#price_range').on('slide', () ->
    setPriceRange()
  ).on('slideStop', () ->
    submitAdvancedSearchForm()
  )

  $('.view-type[role="button"]').on('click', (e)->
    e.preventDefault()
    $view_input = $('input.view-type')
    original_view = $view_input.val()
    view = $(this).data('view')

    unless original_view == view
      $view_input.val(view)
      submitAdvancedSearchForm()

      $('.view-type[role="button"]').not(this).removeClass('active')
      $(this).addClass('active')
  )

  $('.filter-sort[role="button"]').on('click', (e)->
    e.preventDefault()

    $sort_input = $('#advanced-search-form input.filter-sort')
    $sort_selected = $('.sort-selected')
    original_sort = $sort_selected.data('sort')
    sort = $(this).data('sort')

    unless original_sort == sort
      $sort_input.val(sort)
      submitAdvancedSearchForm()

      $sort_selected.data('sort', sort).text($(this).text())
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
  $(':input.price_min').val(min)
  $('span.price_min').text(min)

  max = range[1]
  $(':input.price_max').val(max)
  $('span.price_max').text(max)


@removeInputName = () ->
  $hidden_inputs = $('#search-hidden-inputs-container :input')

  $price_range = $('#price_range')
  range = $price_range.slider('getValue')
  $hidden_inputs.filter('.price_min').remove() if range[0] == $price_range.data('slider-min')
  $hidden_inputs.filter('.price_max').remove() if range[1] == $price_range.data('slider-max')

  $hidden_inputs.not('.price').each () ->
    $(this).removeAttr('name') if $(this).val() == ''


@cloneFilterInputs = () ->
  $clone_inputs = $('#advanced-search-form :input.clone').clone()
  $append_target = $('#search-hidden-inputs-container')
  $append_target.html($clone_inputs)
  $append_target.find(':input').removeAttr('id').attr('type', 'hidden')


@submitAdvancedSearchForm = () ->
  if checkFormDateInput()
    setPriceRange('slideStop')
    cloneFilterInputs()
    removeInputName()

    url = $('#search-form').attr('action')
    params = $('#search-form').serialize()

    $.get(url, params, (html)->
      $('#item-container').remove()
      $('#advanced-search-form').after(html)
      wookmark_item()
    )

    if history.pushState
      url +=  '?' + params
      state = { url: url }
      window.history.pushState(state, $('title').text(), url)


#load item selection on items/form
@load_item_selections = (target)->
  $target = $(target)
  if $target.size() > 0
    param = {}
    url = $target.find('option:selected').data('href')
    is_item_form = ($target.attr('id') == 'item_subcategory_id')

    if url
      if is_item_form
        # 找出 item 已選擇的 selections
        item_id = $('form.edit_item').data('item')
        param = $.param { item_id: item_id} if item_id
      else
        #複製 hidden input 到 navbar 的 search form
        param = $.param { input_name: 'item_selections[]' }
        $('input.filter-subcategory').val( $target.val() )

      $container = $('#selections-container')
      $hide_container = $('#selections-hide')
      $container.html('')
      $hide_container.html('')

      $.get(url, param, (html)->
        $hide_container.html(html)
        html = $hide_container.find('#selections-list-container').html()
        $container.html(html)
        $hide_container.html('')
      )

@wookmark_item = ()->
  $('.item-grid').closest('#item-container').wookmark
    autoResize: true
    offset: 15
