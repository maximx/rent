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
#= require bootstrap-sprockets
#= require moment
#= require bootstrap-datetimepicker
#= require underscore
#= require gmaps/google
#= require fullcalendar
#= require fullcalendar/lang-all
#= require tinymce
#= require_tree .

index_ready  = ->
  # stop bubble javascript
  $('.stop-bubble').click (e)->
    if e.stopPropagation
      e.stopPropagation()
    else
      e.cancelBubble = true

  # display tooltip
  $('[data-toggle="tooltip"]').tooltip()

  #active date time picker
  $('.form_date').datetimepicker
    format: 'YYYY-MM-DD'

  # date time picker logic
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

  # search form validation
  $search_form_date.blur ->
    empty_flag = true
    $search_form_date.each ->
      if $(this).val()
        empty_flag = false
    if empty_flag == true
      $search_form_date.removeProp('required')

  # custom bootstrap shape file select button
  $('.btn-file :file').on('fileselect', (event, numFiles, label)->
    $input = $('#file-name')
    text = if numFiles > 1 then '已選擇 ' + numFiles + ' 個檔案' else label

    if $input.length
      $input.val(text)
    else
      alert text if text
  )

  $('.btn-file :file').on('change', ()->
    $input = $(this)
    numFiles = if $input.get(0).files then $input.get(0).files.length else 1
    label = $input.val().replace(/\\/g, '/').replace(/.*\//, '')

    $input.trigger('fileselect', [numFiles, label])
  )


$(document).ready(index_ready)
$(document).on('page:load', index_ready)


@init_tinymce = (target_obj)->
  tinymce.init
    selector: target_obj
    language: 'zh_TW'
    height: 400
    plugins: 'image'
