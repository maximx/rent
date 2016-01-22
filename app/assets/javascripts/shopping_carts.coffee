$ ->
  # init
  toggle_lender_send_period($('.lender_deliver'))

  $('.lender_deliver').change ()->
    toggle_lender_send_period($(this))
    update_lender_item_deliver($(this))
    update_rent_days_price()

  $('.lender_send_period').change ()->
    update_lender_item_send_period($(this))

  $('.item_record_order form.edit_shopping_cart').submit ()->
    update_lender_item_deliver($(this).find('.lender_deliver'))
    update_lender_item_send_period($(this).find('.lender_send_period:checked'))

@update_lender_item_deliver = (lender_deliver)->
  $(lender_deliver).each ()->
    $lender = $(this).closest('.lender')
    $lender.find('.item_deliver').val($(this).val())
    toggle_send_period($(this))

@update_lender_item_send_period = (lender_send_period)->
  $(lender_send_period).each ()->
    send_period = $(this).val()
    $(this).closest('.lender').find('.item_record').each ()->
      $(this).find('.send_period').val([send_period])

@toggle_lender_send_period = (target)->
  $(target).each ()->
    $send_period = $(this).closest('.lender').find('.send_period_container')
    if $(this).find('option:selected').data('send_home') == true
      $send_period.show()
    else
      $send_period.hide()
