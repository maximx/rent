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

  $(subcategory_selects).on('change', ()->
    if $(this).data('controller') == 'items' and $(this).data('action') == 'search'
      submitAdvancedSearchForm()
    else
      load_item_selections($(this))
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
  $clone_inputs = $('#advanced-search-form :input.clone').not(':checkbox').clone()
  $append_target = $('#search-hidden-inputs-container')
  $append_target.html($clone_inputs)
  $append_target.find(':input').removeAttr('id').attr('type', 'hidden')

  $checkbox_inputs = $('#advanced-search-form :checked.clone').clone()
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
    )

    if history.pushState
      url +=  '?' + params
      state = { url: url }
      window.history.pushState(state, $('title').text(), url)


#load item selection on items/form
@load_item_selections = (target)->
  $target = $(target)
  if $target.size() > 0
    param = $.param { source: 'users' }
    url = $target.find('option:selected').data('href')

    # 只有 items/search  與 users/items
    # 有屬性 data controller data action
    controller = $target.data('controller')
    action = $target.data('action')

    #非 items/search 都要有使用者自定選項
    if url and !(controller == 'items' and action == 'search')
      $container = $('#selections-container')
      $hide_container = $('#selections-hide')
      $container.html('')
      $hide_container.html('')

      #為 search 類的要傳出所有參數
      if controller and action
        #複製 hidden input 到 navbar 的 search form
        $('input.filter-subcategory').val( $target.val() )
        param = location.search + '&' + param unless location.search == ''
      else
        # items/new items/edit 沒 data controller data action
        # 找出 item 已選擇的 selections
        item_id = $('form.edit_item').data('item')
        param = $.param({item_id: item_id}) if item_id

      $.get(url, param, (html)->
        $hide_container.html(html)
        html = $hide_container.find('#selections-list-container').html()
        $container.html(html)
        $hide_container.html('')

        # items/new items/edit 不用submit form
        if controller and action
          submitAdvancedSearchForm()
      )

@wookmark_item = ()->
  $('.item-grid').closest('#item-container').wookmark
    autoResize: true
    offset: 15
