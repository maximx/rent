$ ->
  $('.unfollow-user').on('ajax:success', (e, data, status, xhr) ->
    $(this).closest('.follow-container').remove() if data.status == 'ok'
  )

  $('.user-reviews').on('ajax:success', (e, data, status, xhr) ->
    $(this).siblings('.reviews-container').append(data)

    href = $(this).attr('href').split('?')
    href.pop 1 # pop out page parameter
    next_page = $('.review-container:last').data('page') + 1
    href.push('page=' + next_page)
    $(this).attr('href', href.join('?'))
  )
