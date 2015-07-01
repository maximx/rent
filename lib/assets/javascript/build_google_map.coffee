@buildGoogleMap = (markers)->
  target_id = 'map'
  if $('#' + target_id).size() > 0
    handler = Gmaps.build('Google')
    handler.buildMap({ provider: {}, internal: { id: target_id } }, ->
      google_markers = handler.addMarkers(markers)
      handler.bounds.extendWith(google_markers)
      handler.fitMapToBounds()
    )
