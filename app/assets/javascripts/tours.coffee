initialize = ->
  fromMarkers = []
  toMarkers   = []

  map = new google.maps.Map(
  	document.getElementById('map-canvas'), 
  	mapTypeId: google.maps.MapTypeId.ROADMAP
  )

  defaultBounds = new google.maps.LatLngBounds(
  	new google.maps.LatLng(-23.1772377, -47.3251997), 
  	new google.maps.LatLng(-23.2196102, -47.2785018)
  )

  map.fitBounds defaultBounds

  # Create the 'from' search box and link it to the UI element.
  fromInput = document.getElementById('pac-from-input')
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(fromInput)
  fromSearchBox = new google.maps.places.SearchBox(fromInput)

  # Create the 'to' search box and link it to the UI element.
  toInput = document.getElementById('pac-to-input')
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(toInput)
  toSearchBox = new google.maps.places.SearchBox(toInput)

  # Listen for the event fired when the user selects an item from the
  # search pick list. Retrieve the matching places for that item.
  google.maps.event.addListener fromSearchBox, 'places_changed', ->
    places = fromSearchBox.getPlaces()

    if places.length == 0
      return

    for marker in fromMarkers
      marker.setMap null

    bounds = new google.maps.LatLngBounds()

    for place in places
      image = 
        url: place.icon
        size: new google.maps.Size(100, 100)
        origin: new google.maps.Point(0, 0)
        anchor: new google.maps.Point(17, 34)
        scaledSize: new google.maps.Size(25, 25)

      # Create a marker for each place.
      marker = new google.maps.Marker(
        map: map
        icon: image
        title: place.name
        position: place.geometry.location)

      fromMarkers.push marker
      bounds.extend place.geometry.location

    map.fitBounds bounds

  # Bias the SearchBox results towards places that are within the bounds of the
  # current map's viewport.
  google.maps.event.addListener map, 'bounds_changed', ->
    bounds = map.getBounds()
    fromSearchBox.setBounds bounds


  # Listen for the event fired when the user selects an item from the
  # search pick list. Retrieve the matching places for that item.
  google.maps.event.addListener toSearchBox, 'places_changed', ->
    places = toSearchBox.getPlaces()

    if places.length == 0
      return

    for marker in toMarkers
      marker.setMap null

    bounds = new google.maps.LatLngBounds()

    for place in places
      image = 
        url: place.icon
        size: new google.maps.Size(100, 100)
        origin: new google.maps.Point(0, 0)
        anchor: new google.maps.Point(17, 34)
        scaledSize: new google.maps.Size(25, 25)

      # Create a marker for each place.
      marker = new google.maps.Marker(
        map: map
        icon: image
        title: place.name
        position: place.geometry.location)

      toMarkers.push marker
      bounds.extend place.geometry.location

    map.fitBounds bounds

  # Bias the SearchBox results towards places that are within the bounds of the
  # current map's viewport.
  google.maps.event.addListener map, 'bounds_changed', ->
    bounds = map.getBounds()
    toSearchBox.setBounds bounds

google.maps.event.addDomListener(window, 'load', initialize)