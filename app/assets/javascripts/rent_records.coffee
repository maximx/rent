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

@update_rent_days_price = ()->
  if $('.item-price-days').size() > 0
    ended_date = new Date($('#rent_record_started_at').val())
    started_date = new Date($('#rent_record_ended_at').val())

    diff = Math.abs(ended_date - started_date)
    days = Math.ceil( diff / (24 * 60 * 60 * 1000))
    days = 0 if isNaN(days)

    $('#rent_days').text(days + ' 天')
    $('#total_price').text('$' + days * $('#item_price').val() + ' 元')
