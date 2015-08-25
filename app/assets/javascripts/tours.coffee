initialize = ->
  fromMarkers = []
  toMarkers   = []

  window.map = new google.maps.Map(
    document.getElementById('map-canvas'), 
    mapTypeId: google.maps.MapTypeId.ROADMAP
  )

  map.fitBounds new google.maps.LatLngBounds(
    new google.maps.LatLng(-22, -47), 
    new google.maps.LatLng(-24, -47)
  )

  setEventListener (getSearchBox 'pac-from-input'), fromMarkers
  setEventListener (getSearchBox 'pac-to-input'), toMarkers

getSearchBox = (elementId) ->
  # Create the search box and link it to the given elementId.
  input = document.getElementById(elementId)
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input)

  new google.maps.places.SearchBox(input)

setEventListener = (searchInput, markers) ->
  # Listen for the event fired when the user selects an item from the
  # search pick list. Retrieve the matching places for that item.
  google.maps.event.addListener searchInput, 'places_changed', ->
    places = searchInput.getPlaces()

    if places.length == 0
      return

    for marker in markers
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

      markers.push marker
      bounds.extend place.geometry.location

    map.fitBounds bounds

  # Bias the SearchBox results towards places that are within the bounds of the
  # current map's viewport.
  google.maps.event.addListener map, 'bounds_changed', ->
    bounds = map.getBounds()
    searchInput.setBounds bounds

google.maps.event.addDomListener(window, 'load', initialize)