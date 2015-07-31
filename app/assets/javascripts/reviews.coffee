$ ->
  $('.user-reviews').on('ajax:success', (e, data, status, xhr) ->
    $(this).closest('.reviews-container').find('.reviews-list').append(data)

    next_page = $('.review-container:last').data('page')
    if next_page == 0
      $(this).remove()
    else
      href = $(this).attr('href').split('?')
      href.pop 1 # pop out page parameter
      href.push('page=' + next_page)
      $(this).attr('href', href.join('?'))
  )
