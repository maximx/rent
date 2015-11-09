@buildGoogleMap = (markers)->
  target_id = 'map'
  if $('#' + target_id).size() > 0
    handler = Gmaps.build('Google')
    handler.buildMap({ provider: { scrollwheel: false, zoomControl: false }, internal: { id: target_id } }, ->
      if _.isEmpty(markers)
        handler.getMap().setZoom(6)
        handler.getMap().setCenter({lat: 23.69781, lng: 120.96051})
      else
        google_markers = handler.addMarkers(markers)
        handler.bounds.extendWith(google_markers)
        handler.fitMapToBounds()
        handler.getMap().setZoom(15)
    )
