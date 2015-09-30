$(document).ready ->
  # rent record state log
  $('.rent_record_operates a.rent_record_form_modal').click () ->
    $state_log_form = $('#rent_record_state_log_form')
    $inputs = $('.rent_record_state_log_text')
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

    $('#rent_record_modal').modal('show')
    return false

@update_rent_days_price = ()->
  if $('.item-price-days').size() > 0
    valid_started =  validify_date( $('#rent_record_started_at').val() )
    valid_ended =  validify_date( $('#rent_record_ended_at').val() )

    started_date = new Date( valid_started )
    ended_date = new Date( valid_ended )

    diff = Math.abs(ended_date - started_date)
    days = Math.ceil( diff / (24 * 60 * 60 * 1000))
    days = 0 if isNaN(days)

    $('#rent_days').text(days + ' 天')
    $('#total_price').text('$' + days * $('#item_price').val() + ' 元')
