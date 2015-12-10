R = React.DOM

module.exports = React.createClass
  map: null
  markers: []
  infoWindows: []
  bounds: new google.maps.LatLngBounds()
  didFitBounds: false
  selectedMarker: null

  getInitialState: ->
    {cars: @props.cars, gmap: null, selectedCar: null}

  componentWillMount: ->
    @pubsub = PubSub.subscribe "select_car", ((topic, props) ->
      console.log "Selected Car : "
      console.log props
      @createMap() if @state.gmap == null
      if props.hasOwnProperty('lat') and props.hasOwnProperty('lon')
        @setState selectedCar: props
        @setState title: @setMapTitle props.name, props.last_seen
        @state.gmap.panTo new google.maps.LatLng(props.lat, props.lon)
        @state.gmap.setZoom 16
        @highlightMarker props.name
      else
        @setState selectedCar: null
        @setState title: null
        @fitBounds()
    ).bind(@)

    @pubsub_clear_selected_car = PubSub.subscribe 'clearSelectedCar', (() ->
      @setState
        selectedCar: null
        title: null
      @fitBounds()
    ).bind(@)

  componentWillUnmount: ->
    PubSub.unsubscribe @pubsub
    PubSub.unsubscribe @pubsub_clear_selected_car

  componentDidMount: ->
    @setState gmap: @createMap()
    # google.maps.event.trigger(@state.gmap, 'resize', () -> alert "resized")
    # google.maps.event.trigger(@state.gmap, "resize");
    # @infoWindow = @createInfoWindow()
    # google.maps.event.addListener @state.gmap, 'zoom_changed', => @handleZoomChange

  setMapTitle: (name, last_seen) ->
    name + " | " + moment(last_seen).fromNow()

  initialFitBounds: ->
    unless @didFitBounds
      @fitBounds()
      @didFitBounds = true

  componentWillReceiveProps: (props) ->
    @setState cars: props.cars
    @createMarkers props.cars
    @initialFitBounds()

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
      zoom: 13
      center: casablanca
    map = new google.maps.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)
    # google.maps.event.trigger(map, 'resize')
    # google.maps.event.addListener(map, 'bounds_changed', () ->
    #   alert "bounds changed"
    # )
    map

  focusAllVehicles: ->
    @setState title: "All vehicles"
    @fitBounds

  fitBounds: ->
    @state.gmap.fitBounds(@bounds) if @state.gmap != null

  createMarkers: (cars) ->
    console.log "Here the markers"
    console.log @markers
    @clearMarkers() if @markers != []
    for car in cars
      @createMarker car.lat, car.lon, car.name
    @state.gmap.panTo new google.maps.LatLng(@state.selectedCar.lat, @state.selectedCar.lon) if @state.selectedCar != null

  createMarker: (lat, lon, name) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(lat, lon)
      map: @state.gmap
      icon: @props.pinIcon
      title: name
    console.log marker
    if !isNaN(marker.position.G) || !isNaN(marker.position.K)
      marker.addListener "click", => @createInfoWindow marker
      @markers.push marker
      @bounds.extend marker.getPosition()

  highlightMarker: (name) ->
    marker = @markers.filter (el, i) ->
      el if el.title == name
    @selectedMarker = marker[0]
    @selectedMarker.setAnimation google.maps.Animation.BOUNCE if marker != null

  clearMarkers: ->
    for marker in @markers
      marker.setMap(null)
    @markers = []

  createInfoWindow: (marker) ->
    contentString = "<div class='InfoWindow'>I'm a Window that contains Info Yay</div>"
    infoWindow = new google.maps.InfoWindow
      content: contentString
      map: @state.gmap
      pixelOffset:
        width: 0
        height: -40

    infoWindow.setPosition marker.getPosition()
    # @infoWindows.push infoWindow
    # infoWindow.open()

  handleZoomChange: ->
    alert "Zoom Changed!"

  resizeMap: ->
    console.log "Resizing the map"
    PubSub.publish "toggleWidthView", @state.gmap
    # google.maps.event.trigger(@state.gmap, 'resize')
    # @state.gmap.setCenter(@state.gmap.getCenter())

  springCallBack: () ->
    console.log "Called Callback Spring"
    # @style = {
    #   width: val,
    #   height: val,
    #   position: 'absolute',
    #   top: val*0.25,
    #   left: val*0.25,
    #   border: '1px solid red'
    # }

    # R.div style: {style}, val

  render: ->
    R.div className: 'grid simple h-scroll dragme',
      R.div className: 'grid-title border-only-bot',
        R.h4 null, @state.title || @props.title
        R.div className: 'tools',
          # R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
          #   R.i className: 'fa fa-arrows-h fa-lg', onClick: @resizeMap
      R.div className: 'grid-body no-border', style: {padding:'0px'},
        R.div className: "GMap", style: {height: "400px", width: "100%"},
          R.div ref: "map_canvas", key: "map_canvas", style: {height: '100%', width: '100%'}







