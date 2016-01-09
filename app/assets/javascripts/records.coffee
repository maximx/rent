$(document).ready ->
  # record form
  $('.item_deliver').change () ->
    update_rent_days_price()

  # record state log
  $('.record_operates a.record_form_modal').click () ->
    $state_log_form = $('#record_state_log_form')
    $inputs = $('.record_state_log_text')
    label_text = $(this).data('label')

    $('.modal-title').text( label_text )
    $state_log_form.attr( 'action', $(this).attr('href') )

    if $(this).data('required') == 'required'
      label_text = '<abbr title="必須">*</abbr>' + label_text
      $inputs.prop('required', true)
    $state_log_form.find('label').html( label_text )

    $input_remove = if 'file' == $(this).data('type')
                      $inputs.not(':file')
                    else
                      $inputs.filter(':file')
    $input_remove.closest('.form-group').remove()

    $('#record_modal').modal('show')
    return false

@update_rent_days_price = ()->
  $order_container = $('.item_record_order')
  if $order_container.size() > 0
    started_date = moment( $('#record_started_at').val() )
    ended_date = moment( $('#record_ended_at').val() )

    # ref: http://stackoverflow.com/questions/25150570/get-hours-difference-between-two-dates-in-moment-js
    # 相減要加一天
    diff = moment.duration( ended_date.diff(started_date) ).add(1, 'd')
    days = Math.ceil(diff.asDays())

    if isNaN(days) or !$('#record_started_at').val() or !$('#record_ended_at').val()
      days = 0

    total = 0
    $order_container.find('.item_record').each ()->
      free_days = Number( $(this).find('.free_days').val() )
      item_deposit = Number( $(this).find('.item_deposit').val() )
      deliver_fee = Number( $(this).find('.item_deliver option:selected').data('deliver_fee') )
      item_period = $(this).find('.item_period').val()

      deliver_fee = 0 if isNaN(deliver_fee) or days < 1
      item_deposit = 0 if isNaN(item_deposit) or days < 1

      valid_days = if (days > free_days) then (days - free_days) else 0
      valid_days = 1 if item_period == 'per_time' and days > 0
      rent_price = valid_days * $(this).find('.item_price').val()
      subtotal = rent_price + deliver_fee + item_deposit
      total += subtotal

      $(this).find('.item_deliver_fee').text('$' + deliver_fee)
      $(this).find('.item_subtotal').text('$' + subtotal)

    $('#rent_days').text(days + '天')
    $('#total_price').text('$' + total)
