$(document).on 'page:load', ->
  $('.remove-picture').on('ajax:success', (e, data, status, xhr) ->
    if data.result == 'ok'
      $(this).closest('.picture').remove()
    else if data.result == "false"
      alert('只有一張圖片，不得刪除')
  )

@buildGoogleMap = (markers)->
  handler = Gmaps.build('Google')
  handler.buildMap({ provider: {}, internal: { id: 'map' } }, ->
    google_markers = handler.addMarkers(markers)
    handler.bounds.extendWith(google_markers)
    handler.fitMapToBounds();
  )
