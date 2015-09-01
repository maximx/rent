$(document).ready ->
  $start_picker_obj = $('#rent_record_started_at')
  $end_picker_obj = $('#rent_record_ended_at')
  minimum_period = $('#minimun_period').val()

  $start_picker_obj.on('dp.change', (e)->
    if e.date
      $end_picker_obj.data('DateTimePicker').minDate(
        e.date.add(minimum_period, 'd')
      )
    else
      $end_picker_obj.data('DateTimePicker').minDate(moment().format('YYYY-MM-DD'))

    update_rent_days_price()
  )
  $end_picker_obj.on('dp.change', (e)->
    if e.date
      $start_picker_obj.data('DateTimePicker').maxDate(
        e.date.subtract(minimum_period, 'd')
      )
    else
      $start_picker_obj.data('DateTimePicker').maxDate(moment().format('YYYY-MM-DD'))
    update_rent_days_price()
  )

  $('.rent_record_operates a.rent_record_form_modal').click () ->
    type = $(this).data('type')
    label_text = $(this).data('label')
    $state_log_form = $('#rent_record_state_log_form')

    $('.modal-title').text( label_text )
    $state_log_form.find('label').text( label_text )
    $state_log_form.attr( 'action', $(this).attr('href') )

    if type == 'file'
      $('#rent_record_state_log_text').closest('.form-group').remove()
    else
      $('#rent_record_state_log_file').closest('.form-group').remove()

    $('#rent_record_modal').modal('show')
    return false

@update_rent_days_price = ()->
  if $('.item-price-days').size() > 0
    validify_date = (val) ->
      date_and_time =  val.split(' ')
      date_and_time[0] + 'T' + date_and_time[1]

    valid_started =  validify_date( $('#rent_record_started_at').val() )
    valid_ended =  validify_date( $('#rent_record_ended_at').val() )

    started_date = new Date( valid_started )
    ended_date = new Date( valid_ended )

    diff = Math.abs(ended_date - started_date)
    days = Math.ceil( diff / (24 * 60 * 60 * 1000))
    days = 0 if isNaN(days)

    $('#rent_days').text(days + ' 天')
    $('#total_price').text('$' + days * $('#item_price').val() + ' 元')
