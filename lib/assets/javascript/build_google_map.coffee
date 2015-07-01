@buildGoogleMap = (markers)->
  handler = Gmaps.build('Google')
  handler.buildMap({ provider: {}, internal: { id: 'map' } }, ->
    google_markers = handler.addMarkers(markers)
    handler.bounds.extendWith(google_markers)
    handler.fitMapToBounds()
  )
