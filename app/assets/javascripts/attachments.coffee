$ ->
  $('.file_with_image .picture .edit_image').on 'click', () ->
    $(this).closest('.item').find(':file').click()

  $('form.ajax_image').on 'change', '.picture :file', () ->
    $(this).closest('form').submit()

  $('.cover-image .original-image').load ()->
    $(this).closest('.cover-image').css('background-image', 'url(' + $(this).attr('src') + ')')
