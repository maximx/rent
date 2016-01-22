$ ->
  $('.lender_deliver').change ()->
    update_lender_item_deliver($(this))
    update_rent_days_price()

  $('.item_record_order form.edit_shopping_cart').submit ()->
    update_lender_item_deliver($(this).find('.lender_deliver'))

@update_lender_item_deliver = (lender_deliver)->
  $(lender_deliver).each ()->
    $lender = $(this).closest('.lender')
    $lender.find('.item_deliver').val($(this).val())
    toggle_send_period($(this))
