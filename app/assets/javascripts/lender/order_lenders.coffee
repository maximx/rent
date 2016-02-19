$ ->
  # log form
  $('.order_lender_operates a.log_form_modal').click () ->
    $state_log_form = $('#order_lender_log_form')
    $inputs = $('.order_lender_log_text')
    label_text = $(this).data('label')

    $('.modal-title').text( label_text )
    $state_log_form.attr( 'action', $(this).attr('href') )

    if $(this).data('required') == 'required'
      label_text = '<abbr title="必須">*</abbr>' + label_text
      $inputs.prop('required', true)
    $state_log_form.find('label').html( label_text )

    $input_remove = if 'file' == $(this).data('type')
                      $inputs.not(':file')
                    else
                      $inputs.filter(':file')
    $input_remove.closest('.form-group').remove()

    $('#log_modal').modal('show')
    return false

