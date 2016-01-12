$ ->
  #ref:http://stackoverflow.com/questions/17029399/clicking-back-in-the-browser-disables-my-javascript-code-if-im-using-turbolin
  $(document).on('page:restore', () ->
    init_tinymce('#item_description') # form
    wookmark_item() # index
  )
  init_tinymce('#item_description')
  wookmark_item()

  #form
  subcategory_selects = '#item_subcategory_id, select.filter-subcategory'
  load_item_selections($(subcategory_selects))

  #同聯絡住址
  $('#use_profile_address').on 'change', () ->
    if $(this).prop('checked')
      $('#item_address').val( $(this).val() )

  $('#item_deliver_ids_2').on 'change', () ->
    $('#item_address').prop('required', true) if $(this).prop('checked')

  #同屬item_selection只能選一個
  $(document).on('change', '.edit_item .item_selection :checkbox, .new_item .item_selection :checkbox', ()->
    $(this).closest('.form-group').find(':input').not(this).prop('checked', false)
  )

  $('#item_period').on 'change', ()->
    text = $(this).find('option:selected').text()
    $('.item_period_text').text(text)

  #show
  $('#rent[data-spy="affix"]').affix
    offset:
      top: 490
      bottom: () ->
        if $('#map').size() > 0
          $(document).height() - $('#map').offset().top + 15


  # action index, search
  $(document).on('ajax:success', '.item-bookmark', (e, data, status, xhr) ->
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

  $(subcategory_selects).on('change', ()->
    load_item_selections($(this))

    # 為 search 才submit，只有items/new, edit 有id
    unless $(this).attr('id') == 'item_subcategory_id'
      submitAdvancedSearchForm()
  )

  $(document).on('change', '#advanced-search-form .item_selection :checkbox', ()->
    submitAdvancedSearchForm()
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
  $advanced_form = $('#advanced-search-form')
  $append_target = $('#search-hidden-inputs-container')

  subcategory_id = $advanced_form.find('select.filter-subcategory').val()
  $advanced_form.find('.filter-subcategory.clone').val(subcategory_id)

  $clone_inputs = $advanced_form.find(':input.clone').not(':checkbox').clone()
  $append_target.html($clone_inputs)
  $append_target.find(':input').removeAttr('id').attr('type', 'hidden')

  $checkbox_inputs = $advanced_form.find(':checked.clone').clone()
  $append_target.append($checkbox_inputs)

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
      init_tooltip()
    )

    if history.pushState
      url +=  '?' + params
      state = { url: url }
      window.history.pushState(state, $('title').text(), url)


#load item selection on items/form
@load_item_selections = (target)->
  $target = $(target)
  if $target.size() > 0
    $container = $('#selections-container').html('')
    $hide_container = $('#selections-hide').html('')

    if url = $target.find('option:selected').data('href')
      param = ''
      if item_id = $('form.edit_item').data('item')
        # items/edit 找出 item 已選擇的 selections
        param = $.param {item_id: item_id}
      else if location.search != ''
        # search 要傳出所有參數
        param = location.search
        param = param.substr(1) if param.charAt(0) == '?'

      $.get(url, param, (html)->
        $hide_container.html(html)
        html = $hide_container.find('#selections-list-container').html()
        $container.html(html)
        $hide_container.html('')
      )

@update_item_picturs_container = (html)->
  $('#item-picture-container').remove()
  $(html).insertAfter('.page-header')
  wookmark_item()

@wookmark_item = ()->
  $('.item-grid').closest('#item-list-container').wookmark
    autoResize: true
    offset: 15
  $('#item-picture-container').wookmark
    autoResize: true
    offset: 15

  $('#item-picture-container').find('img').load ()->
    $('#item-picture-container').wookmark
      autoResize: true
      offset: 15
