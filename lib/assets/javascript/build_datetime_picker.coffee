@buildDateTimePicker = (target, format, disabled_dates = [])->
  options = {
    format: format
    useCurrent: false #ref: https://eonasdan.github.io/bootstrap-datetimepicker/#linked-pickers
  }
  if disabled_dates.length > 0
    options.minDate = moment().format(format)
    options.disabledDates = disabled_dates

  min_date = $(target).first().val()
  max_date = $(target).last().val()
  if min_date == '' && max_date == ''
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
