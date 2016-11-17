R = React.DOM
gm = google.maps

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

CustomMarker::getPosition = ->
  @latlng

module.exports = React.createClass
  map: null
  carMarkers: []
  routeMarkers: []
  oms: null
  stepMarkers: []
  infoWindow: null
  boundsToAllCars: new google.maps.LatLngBounds()
  boundsToRoute: new google.maps.LatLngBounds()
  didFitBounds: false
  selectedMarker: null
  routePath: null
  follow: true

  getInitialState: ->
    {activeCars: @props.activeCars, cars: @props.cars, gmap: null, selectedCar: {}, data: null, carMarkers: [], allCars: true, marker: null, loading: false, isLive: false, followCar: true, logbookDate: null}

  componentWillMount: ->
    # event coming from CarsOverview
    @pubsub_clear_selected_car = PubSub.subscribe 'clearSelectedCar', (() ->
      @setState
        title: null
        allCars: true
        selectedCar: {routes:[]}
      @routePath.setMap null
      @routePath = null
      @clearRouteMarkers()
      @fitBounds(@boundsToAllCars)
    ).bind(@)

    # event coming from LogBook
    @pubsub_show_route = PubSub.subscribe 'showRoute', ((topic, data) ->
      locations = []

      @follow = true

      selectedCar = React.addons.update @state.selectedCar, 
        $merge: data.car

      @setState
        isLive: false
        selectedCar: selectedCar
        allCars: false
        logbookDate: data.date

      @setState title: @setMapTitle @state.selectedCar.name, @state.selectedCar.last_seen
      @routePath.setMap null if @routePath

      self = @

      if @state.selectedCar.routes.hasOwnProperty(eval("data.date"))
        if @state.selectedCar.routes[data.date].hasOwnProperty(eval("data.car.id"))
          if @state.selectedCar.routes[data.date][data.car.id].route != null and @state.selectedCar.routes[data.date][data.car.id].route != [] and @state.selectedCar.routes[data.date][data.car.id].route != {}
            locations = @state.selectedCar.routes[data.date][data.car.id].route
            @calcRoutePolyline locations

      if locations.length == 0
        @setState loading: true
        api.getWithParams("/get_car_route", {car_id: data.car.id, date: data.date}).then((positions) ->
          self.setState loading: false
          locations = positions

          selectedCar = React.addons.update self.state.selectedCar,  
            routes:
              $merge:
                "#{data.date}":
                  "#{data.car.id}":
                    route: locations

          self.setState selectedCar: selectedCar
          self.calcRoutePolyline locations
          # @showStepsOfRoute data.locations
        )

      @state.gmap.fitBounds
      console.log("get car route")

    ).bind(@)

  componentWillUnmount: ->
    PubSub.unsubscribe @pubsub
    PubSub.unsubscribe @pubsub_clear_selected_car
    PubSub.unsubscribe @pubsub_show_route

  componentDidMount: ->
    selectedCar = React.addons.update @state.selectedCar, $merge:
      routes: {}

    @setState selectedCar: selectedCar

    @setState gmap: @createMap()

  pinSymbol: (color) ->
    path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z'
    fillColor: color
    fillOpacity: 1
    strokeColor: '#000'
    strokeWeight: 2
    scale: 2

  calcRoutePolyline: (data) ->
    routeCoordinates = []
    @boundsToRoute = new google.maps.LatLngBounds()
    @clearRouteMarkers()

    iw = new gm.InfoWindow()
    $.each data, ((index, pos) ->

      self = @
      l = pos

      latlng = new google.maps.LatLng(l.latitude, l.longitude)

      @boundsToRoute.extend(latlng)

      point =
        lat: l.latitude
        lng: l.longitude

      if l.state == "start"
        marker = new MarkerWithLabel
          position: latlng
          labelContent: "#{l.trip_step}"
          labelClass: "gmlabels"
          labelAnchor: new google.maps.Point(10.5, 26.5)
          labelInBackground: false
          icon: @props.emptyIcon
          #on: @pinSymbol('red')
        marker.desc = "My cool description"
        marker.setMap @state.gmap
        # @stepMarkers.push marker
        @oms.addMarker marker

        # @oms.addListener 'click' , (marker, event) ->
        #   iw.setContent marker.desc
        #   iw.open self.state.gmap, marker

        # @oms.addListener 'spiderfy', (markers) ->
        #   iw.close()

       # if pos.state == "start" or pos.state == "stop"
        # @createRouteMarker point.lat, point.lng, pos.address

       # if index == 0
       #  @createRouteMarker point.lat, point.lng, "Departure"

       # if index == data.length - 1
       #  @createRouteMarker point.lat, point.lng, "Arrival"

      routeCoordinates.push point

    ).bind(@)

    @fitBounds @boundsToRoute
    console.log("Car Route")

    # 3b7fb8 - blue
    # 1da599 - green
    @routePath = new google.maps.Polyline
      path: routeCoordinates
      geodesic: false
      strokeColor: "#3b7fb8"
      # strokeColor: "#22262e"
      strokeOpacity: 1.0
      strokeWeight: 2

    @routePath.setMap @state.gmap
    # @zoomToObject @routePath
    # @state.gmap.setCenter @routePath.getCenter()

  clearRouteMarkers: ->
    for m in @stepMarkers
      m.setMap null
    for m in @oms.getMarkers()
      @oms.removeMarker m
      m.setMap null
    @stepMarkers = []

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
    @createCarMarkers props.activeCars
    CurrentCarid = @state.selectedCar.id

    if @state.selectedCar.hasOwnProperty("id")
      matches = jQuery.grep props.cars, (item) ->
        return item.id == CurrentCarid
      if matches.length
        selectedCar = React.addons.update @state.selectedCar,
          $merge: matches[0]
        @setState selectedCar: selectedCar
        @setState title: @setMapTitle selectedCar.name, selectedCar.last_seen

    @setState 
      cars: props.cars
      activeCars: props.activeCars

  # shouldComponentUpdate: (nextProps, nextState) ->
  #   # nextState.selectedCar != null and nextState.selectedCar.lat == null
  #   # !isNaN(nextState.selectedCar.lat)

  componentWillUpdate: (nextProps, nextState) ->
    # @createMarkers(nextState.cars)
    # @state.gmap.setCenter(marker.getPosition())

  componentDidUpdate: ->

  createMap: ->
    self = @

    copenhagen = new google.maps.LatLng(55.6759400, 12.5655300)
    casablanca = new google.maps.LatLng(33.5883100, -7.6113800)

    mapOptions =
      minZoom: 1
      scrollwheel: false
      maxZoom: 16
      zoom: 14
      center: casablanca
    map = new google.maps.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)
    @createCarMarkers @state.activeCars
    @oms = new OverlappingMarkerSpiderfier(map, {keepSpiderfied: true})

    google.maps.event.addListener map, 'dragstart', () ->
      self.follow = false

    google.maps.event.addListener map, 'dblclick', () ->
      self.follow = true

    map

  fitBounds: (whatBounds) ->
    @state.gmap.fitBounds(whatBounds) if @state.gmap != null
    
  fitBoundsSelected: (whatBounds) ->
    count = parseInt($("#count").attr("val"))

    @state.gmap.fitBounds(whatBounds) if @state.gmap != null && count <= 3

    $("#count").attr("val", count + 1)  


  createCarMarkers: (cars) ->
    @clearCarMarkers()

    for car in cars
      @createCarMarker car

    window.currentTime = moment().utc()
    window.lastTime = moment("#{@state.selectedCar.last_seen}").utc()

    if @state.selectedCar.hasOwnProperty('lon') and @state.selectedCar.hasOwnProperty('lat')
      window.currentTime = moment().utc()
      window.lastTime = moment("#{@state.selectedCar.last_seen}").utc()
      window.selectedCar = @state.selectedCar

      if moment("#{@state.logbookDate}").toDate().isToday()
        if window.currentTime.utc().local().diff(window.lastTime.utc().local()) <=  60000
          @setState isLive: true
          if @follow
            @state.gmap.panTo new google.maps.LatLng(@state.selectedCar.lat, @state.selectedCar.lon)
        else
          @setState isLive: false
      else
        @setState isLive: false
    else
      @fitBounds @boundsToAllCars

  createCarMarker: (car) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(car.lat, car.lon)
      map: @state.gmap
      icon: @props.carIcon
      title: car.name
    google.maps.event.addListener marker, "click", (() ->
      PubSub.publish 'show_logbook', car
      console.log("clicked")
      if @infoWindow
        @infoWindow.close()
      @createInfoWindow marker, car
    ).bind(@)

    @carMarkers.push marker
    @boundsToAllCars.extend marker.getPosition()
    return marker

    # google.maps.event.addListener marker, "click", (() ->
    #   if @infoWindow
    #     @infoWindow.close()
    #   @createInfoWindow marker, car
    # ).bind(@)

  highlightMarker: (name) ->
    marker = @markers.filter (el, i) ->
      el if el.title == name
    @selectedMarker = marker[0]
    @selectedMarker.setAnimation google.maps.Animation.BOUNCE if marker != null
    @routePath.setMap null if @routePath

  clearCarMarkers: ->
    for marker in @carMarkers
      marker.setMap(null)
    @carMarkers = []

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
    PubSub.publish "toggleWidthView", @state.gmap
    # google.maps.event.trigger(@state.gmap, 'resize')
    # @state.gmap.setCenter(@state.gmap.getCenter())

  render: ->
    R.div className: 'grid simple dragme', style: {marginBottom: "0px"},
      R.div className: 'grid-title border-only-bo no-border',
        R.h4 null, @state.title || @props.title
        R.div className: 'tools',
          # R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
          #   R.i className: 'fa fa-arrows-h fa-lg', onClick: @resizeMap
      R.div className: 'grid-body no-border', style: {padding:'0px'},
        R.div className: "GMap",
          R.div, null
            # R.div className: "overlay standard #{if !@state.loading then "hidde" else ""}"
            R.div className: "overlay-label standard loading-label #{if !@state.loading then "hidde" else ""}", "Loading ..."
            R.div className: "overlay-label standard live-label #{if !@state.isLive then "hidde" else ""}", "#{@state.selectedCar.name} - Live"
            R.div className: "overlay-label standard live-stats #{if !@state.isLive then "hidde" else ""}", "#{@state.selectedCar.speed} Km/h"
            R.div ref: "map_canvas", key: "map_canvas", style: {height: '100%', width: '100%'}







