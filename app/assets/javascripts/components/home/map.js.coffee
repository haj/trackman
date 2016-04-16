R = React.DOM

CustomMarker = (latlng, map, args) ->
  @latlng = latlng
  @args = args
  @setMap map

CustomMarker.prototype = new google.maps.OverlayView()

CustomMarker::draw = () ->
  self = @
  div = @div
  if !div
    div = @div = document.createElement('div')
    div.className = "marker"
    div.style.position = 'absolute'
    div.style.cursor = 'pointer'
    div.innerHTML = self.args.html_marker

    # if typeof self.args.marker_id != 'undefined'
    #   div.dataset.marker_id = self.args.marker_id

    google.maps.event.addDomListener div, 'click', (event) ->
      google.maps.event.trigger self, 'click'

    panes = @getPanes()
    panes.overlayImage.appendChild div

  point = @getProjection().fromLatLngToDivPixel(@latlng)
  if point
    div.style.left = point.x + 'px'
    div.style.top = point.y + 'px'

CustomMarker::remove = ->
  # if @div
  #   console.log "OKAY"
  #   console.log @div
  #   console.log @div.parentNode
  #   @div.parentNode.removeChild @div
  #   # @div.parentNode.innerHTML = ""
  #   # @div.innerHTML = ""
  #   console.log @div
  #   @div = null
  #   console.log @div

CustomMarker::getPosition = ->
  @latlng

module.exports = React.createClass
  map: null
  markers: []
  # routeMarkers: []
  infoWindow: null
  boundsToAllCars: new google.maps.LatLngBounds()
  boundsToRoute: new google.maps.LatLngBounds()
  didFitBounds: false
  selectedMarker: null
  routePath: null

  getInitialState: ->
    {activeCars: @props.activeCars, cars: @props.cars, gmap: null, selectedCar: null, data: null, carMarkers: [], allCars: true, marker: null}

  componentWillMount: ->

    # event coming from CarsOverview
    # @pubsub = PubSub.subscribe "show_last_route_on_map", ((topic, props) ->
    #   console.log "Selected Car : "
    #   console.log props
    #   @createMap() if @state.gmap == null
    #   if props.hasOwnProperty('lat') and props.hasOwnProperty('lon')
    #     console.log "flag 1"
    #     @setState selectedCar: props
    #     @setState title: @setMapTitle props.name, props.last_seen
    #     @state.gmap.panTo new google.maps.LatLng(props.lat, props.lon)
    #     @state.gmap.setZoom 16
    #     # @highlightMarker props.name
    #   else
    #     @setState selectedCar: null
    #     @setState title: null
    #     @fitBounds()
    # ).bind(@)

    # event coming from CarsOverview
    @pubsub_clear_selected_car = PubSub.subscribe 'clearSelectedCar', (() ->
      @setState
        selectedCar: null
        title: null
        allCars: true
      @routePath.setMap null
      @routePath = null
      @fitBounds(@boundsToAllCars)
    ).bind(@)

    # event coming from LogBook
    @pubsub_show_route = PubSub.subscribe 'showRoute', ((topic, data) ->
      @setState
        selectedCar: data.car
        allCars: false
      @setState title: @setMapTitle @state.selectedCar.name, @state.selectedCar.last_seen
      @routePath.setMap null if @routePath
      @calcRoutePolyline data.locations
      # @showStepsOfRoute data.locations
      @state.gmap.fitBounds
    ).bind(@)

  componentWillUnmount: ->
    PubSub.unsubscribe @pubsub
    PubSub.unsubscribe @pubsub_clear_selected_car
    PubSub.unsubscribe @pubsub_show_route

  componentDidMount: ->
    console.log "Did mouuuunt"
    @setState gmap: @createMap()

  calcRoutePolyline: (data) ->
    console.log "calc route using polylines"
    routeCoordinates = []

    $.each data, ((index, pos) ->

      l = pos

      point =
        lat: l.latitude
        lng: l.longitude

       # if index == 0
       # 	@createRouteMarker point.lat, point.lng, "Departure"

       # if index == data.length - 1
       # 	@createRouteMarker point.lat, point.lng, "Arrival"

      routeCoordinates.push point

    ).bind(@)

    console.log routeCoordinates.length
    console.log routeCoordinates

    @routePath = new google.maps.Polyline
      path: routeCoordinates
      geodesic: false
      strokeColor: '#FF0000'
      strokeOpacity: 1.0
      strokeWeight: 2

    @routePath.setMap @state.gmap
    @zoomToObject @routePath
    # @state.gmap.setCenter @routePath.getCenter()

  createRouteMarker: (lat, lng, title) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(lat, lng)
      map: @state.gmap
      icon: @props.pinIcon
      title: title

  setMapTitle: (name, last_seen) ->
    name + " | " + moment(last_seen).fromNow()

  initialFitBounds: ->
    unless @didFitBounds
      @fitBounds @boundsToAllCars
      @didFitBounds = true

  componentWillReceiveProps: (props) ->
    # @clearMarkers()
    @createMarkers props.activeCars

    @setState 
      cars: props.cars
      activeCars: props.activeCars

  # shouldComponentUpdate: (nextProps, nextState) ->
  #   console.log "shouldComponentUpdate"
  #   console.log nextState
  #   # nextState.selectedCar != null and nextState.selectedCar.lat == null
  #   # !isNaN(nextState.selectedCar.lat)

  componentWillUpdate: (nextProps, nextState) ->
    console.log "WILL UPDATE"
    # @createMarkers(nextState.cars)
    # @state.gmap.setCenter(marker.getPosition())

  componentDidUpdate: ->
    console.log "DID UPDATE"
    # console.log "DID UPDATE MOUNT"
    # console.log @state.cars
    # console.log @props.cars

  createMap: ->
    copenhagen = new google.maps.LatLng(55.6759400, 12.5655300)
    casablanca = new google.maps.LatLng(33.5883100, -7.6113800)
    mapOptions =
      minZoom: 1
      maxZoom: 16
      zoom: 14
      center: casablanca
    map = new google.maps.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)
    @createMarkers @state.activeCars

    # google.maps.event.trigger(map, 'resize')
    # google.maps.event.addListener(map, 'bounds_changed', () ->
    #   alert "bounds changed"
    # )
    map

  fitBounds: (whatBounds) ->
    @state.gmap.fitBounds(whatBounds) if @state.gmap != null

## Markers for showing the cars #########

  createMarkers: (cars) ->
    console.log "Here the markers"
    console.log @state.active_cars
    console.log @markers.length
    @clearMarkers()
    for car in cars
      @createMarker car
    @state.gmap.panTo new google.maps.LatLng(@state.selectedCar.lat, @state.selectedCar.lon) if @state.selectedCar != null

  createMarker: (car) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(car.lat, car.lon)
      map: @state.gmap
      icon: @props.pinIcon
      title: car.name
    console.log "Making a marker"
    console.log marker
    google.maps.event.addListener marker, "click", (() ->
      if @infoWindow
        @infoWindow.close()
      @createInfoWindow marker, car
    ).bind(@)

    @markers.push marker
    @boundsToAllCars.extend marker.getPosition()
    @fitBounds @boundsToAllCars
    console.log @boundsToAllCars
    console.log "get markers positions"
    console.log marker.getPosition()
    return marker

    # google.maps.event.addListener marker, "click", (() ->
    #   if @infoWindow
    #     @infoWindow.close()
    #   @createInfoWindow marker, car
    # ).bind(@)

    @markers.push marker
    @boundsToRoute.extend marker.getPosition()
    @fitBounds @boundsToRoute
    return marker

  highlightMarker: (name) ->
    marker = @markers.filter (el, i) ->
      el if el.title == name
    @selectedMarker = marker[0]
    @selectedMarker.setAnimation google.maps.Animation.BOUNCE if marker != null
    @routePath.setMap null if @routePath

  clearMarkers: ->
    for marker in @markers
      marker.setMap(null)
    @markers = []

## Markers for showing the cars #########

  createInfoWindow: (marker, car) ->
    contentString =
    "<div class='InfoWindow'>
      <h5>#{car.name}</h5>
      <p>#{car.last_location}</p>
      <p>#{car.last_seen}</p>
      <p>#{car.numberplate}</p>
      <p>#{car.type}</p>
    </div>"
    @infoWindow = new google.maps.InfoWindow
      content: contentString
      map: @state.gmap
      pixelOffset:
        width: 0
        height: -40

    @infoWindow.setPosition marker.getPosition()


  ## Create markers for routes

  showStepsOfRoute: (data) ->

    if @routeMarkers != []
      $.map @routeMarkers, (marker) ->
        marker.div.parentNode.removeChild marker.div
      @routeMarkers = []

    j = 0
    for pos in data
      status = pos.state
      if status == "start" || status == "stop"
          if status == "start"
              pin = "<span style='margin-left:15px' class='badge badge-success'>"+(j+1)+"</span>"

          if status == "idle"
              pin = "<span style='margin-left:0px' class='badge badge-warning'>"+(j+1)+"</span>"

          if status == "stop"
              pin = "<span style='margin-right:15px' class='badge badge-danger'>"+(j+1)+"</span>"
              j++

          content = "<div><b>Date:</b><br/>" + pos.time + "</div>"

          marker = new CustomMarker(new google.maps.LatLng(pos.latitude, pos.longitude),
            @state.gmap,{html_marker: pin})

          @routeMarkers.push marker

  ############################

  handleZoomChange: ->
    alert "Zoom Changed!"

  zoomToObject: (obj) ->
    @boundsToRoute = new google.maps.LatLngBounds()
    points = obj.getPath().getArray()
    n = 0
    while n < points.length
      @boundsToRoute.extend points[n]
      n++
    @fitBounds @boundsToRoute

  resizeMap: ->
    console.log "Resizing the map"
    PubSub.publish "toggleWidthView", @state.gmap
    # google.maps.event.trigger(@state.gmap, 'resize')
    # @state.gmap.setCenter(@state.gmap.getCenter())

  render: ->
    R.div className: 'grid simple dragme',
      R.div className: 'grid-title border-only-bot',
        R.h4 null, @state.title || @props.title
        R.div className: 'tools',
          # R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
          #   R.i className: 'fa fa-arrows-h fa-lg', onClick: @resizeMap
      R.div className: 'grid-body no-border', style: {padding:'0px'},
        R.div className: "GMap", style: {height: "400px", width: "100%"},
          R.div ref: "map_canvas", key: "map_canvas", style: {height: '100%', width: '100%'}







