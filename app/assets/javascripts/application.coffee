# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require jquery
#= require bootstrap-sprockets
#= require moment
#= require bootstrap-datetimepicker
#= require underscore
#= require gmaps/google
#= require fullcalendar
#= require fullcalendar/lang-all
#= require_tree .


$(document).ready ->
  $('.stop-bubble').click (e)->
    if e.stopPropagation
      e.stopPropagation()
    else
      e.cancelBubble = true

  $('[data-toggle="tooltip"]').tooltip()

  $('.form_date').datetimepicker
    format: 'YYYY-MM-DD'

  $search_form_date = $('.form_date')
  $start_picker_obj = $('#started_at')
  $end_picker_obj = $('#ended_at')

  $start_picker_obj.on('dp.change', (e)->
    $end_picker_obj.data('DateTimePicker').minDate(e.date)
    $search_form_date.prop('required', true)
  )
  $end_picker_obj.on('dp.change', (e)->
    $start_picker_obj.data('DateTimePicker').maxDate(e.date)
    $search_form_date.prop('required', true)
  )

  $search_form_date.blur ->
    empty_flag = true
    $search_form_date.each ->
      if $(this).val()
        empty_flag = false
    if empty_flag == true
      $search_form_date.removeProp('required')
