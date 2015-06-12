$(document).ready ->
    $('.form_datetime').datetimepicker
      format: 'YYYY-MM-DD HH:mm::ss'

    $start_picker_obj = $('#rent_record_started_at').closest('.form_datetime')
    $end_picker_obj = $('#rent_record_ended_at').closest('.form_datetime')
    minimum_period = $('#minimun_period').val()

    $start_picker_obj.on('dp.change', (e)->
      $end_picker_obj.data('DateTimePicker').minDate(
        e.date.add(minimum_period, 'd')
      )
    )
    $end_picker_obj.on('dp.change', (e)->
      $start_picker_obj.data('DateTimePicker').maxDate(
        e.date.subtract(minimum_period, 'd')
      )
    )
