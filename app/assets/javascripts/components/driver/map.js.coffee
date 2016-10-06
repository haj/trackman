R = React.DOM
gm = google.maps
directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()

module.exports = React.createClass
  getInitialState: ->
    {car: @props.car, device: @props.device, user: @props.user, last_location: @props.last_location, gmap: null, marker: null, loading: null, isLive: null, interval: null, car_id: null, order_id: null, active_order: @props.active_order, first_position_active: @props.first_position_active}

  componentDidMount: ->
    @initMap()

  latLong: ->
    if !@state.active_order
      new gm.LatLng(@state.last_location.latitude, @state.last_location.longitude)
    else
      new gm.LatLng(@state.active_order.latitude, @state.active_order.longitude)

  initMap: ->
    mapOptions  = {
      zoom: 7,
      center: @latLong()
    }
    map = new gm.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)

    @setState gmap: map

    if !@state.active_order
      @initMarker(map)
    else   
      @initMarkerActive(map)
      @setInterval(@state.active_order)

  initMarkerActive: (map) ->
    directionsDisplay.setMap(map)

    request = {
      origin: "#{@props.first_position_active.latitude}, #{@props.first_position_active.longitude}"
      destination: "#{@state.active_order.latitude}, #{@state.active_order.longitude}"
      travelMode: 'DRIVING'
    }
    directionsService.route(request, (result, status) ->
      if status == 'OK'
        directionsDisplay.setDirections(result)
    )

  initMarker: (map)->
    marker  = new gm.Marker({
      position: @latLong(),
      map: map
    })
    marker.setMap(map)

    @setMarker marker: marker

  setInterval: (order) ->
    @setState
      car_id: @props.car.id
      order_id: order.id
    interval = setInterval(@makeRequest, (10 * 1000))    
    @setState interval: interval

  makeRequest: ->
    $.ajax
      method: "GET"
      dataType: "json"
      url: "/cars/#{@state.car_id}/last_position"
      data:
        order_id: @state.order_id
      success: ((data) ->
        @removeMarker()
        @setMarker(data)
      ).bind(@)

  setMapDestination: (data)->
    destination = new google.maps.LatLng(data.latitude_origin, data.longitude_origin)
    mapOptions  = {
      zoom: 7,
      center: destination
    }
    map = new google.maps.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)

    @setState gmap: map
 
    directionsDisplay.setMap(map)

    request = {
      origin: "#{data.latitude_origin}, #{data.longitude_origin}"
      destination: "#{data.order.latitude}, #{data.order.longitude}"
      travelMode: 'DRIVING'
    }
    directionsService.route(request, (result, status) ->
      if status == 'OK'
        directionsDisplay.setDirections(result)
    )

  carOverviewToggle: ->
    $(".cars_overview .grid-body").toggle()

  changeOverviewDetail: (data) ->
    $(".title-inline.noselect").html("#{data.order.customer_name} - #{data.order.package}")    

  newLatLong: (data)->
    new gm.LatLng(data.latitude, data.longitude)

  removeMarker: ->
    if @state.marker
      @state.marker.setMap(null)

  setMarker: (data) ->
    marker  = new gm.Marker({
      position: @newLatLong(data),
      map: @state.gmap
    })

    @setState marker: marker

    marker.setMap(@state.gmap)

  componentWillMount: ->
    @pubsub = PubSub.subscribe 'render_map', ((topic, props) ->
      $.ajax
        dataType: 'json'
        type: 'GET'
        url: "/orders/#{props.order.id}"
        success: ((data)->
          @setMapDestination(data)
          @changeOverviewDetail(data)
          @setInterval(props.order)
        ).bind(@)
      @carOverviewToggle()
    ).bind(@)

    @pubsubacceptdestination = PubSub.subscribe 'accept_destination', ((topic, props) ->
      $.ajax
        dataType: 'json'
        type: 'PUT'
        url: "/destinations_drivers/#{props.order.destination_id}/accept"
        success: ((data)->
          @setMapDestination(data)
          @changeOverviewDetail(data)
          @setInterval(props.order)

          toastr.success('Success accepting an order! Have a good ride! ;)')

        ).bind(@)
      @carOverviewToggle()
    ).bind(@)

    @pubsubdonedestination = PubSub.subscribe 'done_destination', ((topic, props) ->
      $.ajax
        dataType: 'json'
        type: 'PUT'
        url: "/destinations_drivers/#{props.order.destination_id}/finish"
        success: ((data)->
          @setState isShow: false
          window.clearInterval(@state.interval)

          toastr.success('Awesome! You have successfully delivered a package!')
        ).bind(@)

    ).bind(@)

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
            R.div className: "overlay-label standard live-label #{if !@state.active_order then "hidde" else ""}", "Live : #{if !@state.active_order then "hidde" else @state.active_order.customer_name} - #{if !@state.active_order then "hidde" else @state.active_order.package}"
            R.div ref: "map_canvas", key: "map_canvas", style: {height: '100%', width: '100%'}
