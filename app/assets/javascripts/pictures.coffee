$ ->
  $(document).on 'ajax:success', '.remove-picture', (e, data, status, xhr) ->
    if data.result == 'ok'
      $carousel = $(this).closest('.carousel')
      size = $carousel.find('.item').size()

      if size == 1
        $carousel.remove()
      else
        $pic_item = $(this).closest('.item')
        index = $pic_item.index()
        active_index = ( index == 0 ) ? 1 : 0

        $carousel.find('.carousel-indicators li').eq(index).remove()
        $pic_item.remove()

        $carousel.find('.carousel-indicators li').eq(active_index).addClass('active')
        $carousel.find('.item').eq(active_index).addClass('active')
        $carousel.carousel()
    else if data.result == "false"
      alert('發生錯誤')

  $('.file_with_image .picture .edit_image').on 'click', () ->
    $(this).closest('.item').find(':file').click()

  $('form.ajax_image').on 'change', '.picture :file', () ->
    $(this).closest('form').submit()
