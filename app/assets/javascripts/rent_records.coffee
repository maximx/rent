$(document).ready ->
    $('.form_datetime').datetimepicker
      format: 'YYYY-MM-DD HH:mm:ss'

    $start_picker_obj = $('#rent_record_started_at').closest('.form_datetime')
    $end_picker_obj = $('#rent_record_ended_at').closest('.form_datetime')
    minimum_period = $('#minimun_period').val()

    #TODO: it's wierd
    $start_picker_obj.on('dp.change', (e)->
      $end_picker_obj.data('DateTimePicker').minDate(
        e.date.add(minimum_period, 'd')
      )
      update_rent_days_price()
    )
    $end_picker_obj.on('dp.change', (e)->
      $start_picker_obj.data('DateTimePicker').maxDate(
        e.date.subtract(minimum_period, 'd')
      )
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
