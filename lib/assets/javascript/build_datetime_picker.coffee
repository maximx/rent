@buildDateTimePicker = (target, format, disabled_dates = [])->
  options = {
    format: format
    useCurrent: false #ref: https://eonasdan.github.io/bootstrap-datetimepicker/#linked-pickers
  }
  if disabled_dates.length > 0
    options.minDate = moment().format(format)
    options.disabledDates = disabled_dates

  $(target).each ()->
    $(this).datetimepicker(options)
