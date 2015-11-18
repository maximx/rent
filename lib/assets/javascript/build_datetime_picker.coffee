@buildDateTimePicker = (target, format = false, disabled_dates = [])->
  return if $(target).size() == 0

  options = {
    format: format,
    locale: 'zh-TW',
    useCurrent: false #ref: https://eonasdan.github.io/bootstrap-datetimepicker/#linked-pickers
  }

  if disabled_dates.length > 0
    options.minDate = moment().format('YYYY-MM-DD')
    options.disabledDates = disabled_dates

  min_date = validify_date( $(target).first().val() )
  max_date = validify_date( $(target).last().val() )
  if min_date == '' and max_date == ''
    $(target).each ()->
      $(this).datetimepicker(options)
  else
    #set min and max date when input.form_date has value
    if min_date != ''
      options.minDate = min_date
      $(target).last().datetimepicker(options)
    if max_date != ''
      delete options.minDate
      options.maxDate = max_date
      $(target).first().datetimepicker(options)


@rentRecordPickerChange = ()->
  $start_picker_obj = $('#record_started_at')
  $end_picker_obj = $('#record_ended_at')
  minimum_period = $('#minimun_period').val()

  $start_picker_obj.on('dp.change', (e)->
    if e.date
      $end_picker_obj.data('DateTimePicker').minDate(
        e.date.add(minimum_period, 'd')
      )
    else
      $end_picker_obj.data('DateTimePicker').minDate(moment())

    update_rent_days_price()
  )
  $end_picker_obj.on('dp.change', (e)->
    if e.date
      $start_picker_obj.data('DateTimePicker').maxDate(
        e.date.subtract(minimum_period, 'd')
      )
    else
      $start_picker_obj.data('DateTimePicker').maxDate(moment())

    update_rent_days_price()
  )
