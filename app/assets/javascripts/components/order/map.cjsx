directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()
trafficLayer      = new google.maps.TrafficLayer()
geocoder          = new google.maps.Geocoder()
RouteDescription  = require('./routes_description')

module.exports = React.createClass

  getInitialState: ->
    { car: @props.car, order_id: @props.order.id, latitude_origin: @props.latitude_origin, 
    longitude_origin: @props.longitude_origin, latitude_destination: @props.order.latitude, 
    longitude_destination: @props.order.longitude, package: @props.order.package, 
    customer_name: @props.order.customer_name, selected_driver: @props.selected_driver }

  componentWillMount: ->
    @initMap()
    @calcRoute()

  initMap: ->
    destination = new google.maps.LatLng(@state.latitude_destination, @state.longitude_destination)
    mapOptions  = {
      zoom: 7,
      center: destination
    }
    map = new google.maps.Map(document.getElementById('showMap'), mapOptions)
    directionsDisplay.setMap(map)

  destination: ->
    "#{@state.latitude_destination}, #{@state.longitude_destination}"

  origin: ->
    "#{@state.latitude_origin}, #{@state.longitude_origin}"

  calcRoute: ->
    request = {
      origin: @origin()
      destination: @destination()
      travelMode: 'DRIVING'
    }
    directionsService.route(request, (result, status) ->
      if status == 'OK'
        directionsDisplay.setDirections(result)

        point = result.routes[0].legs[0]

        $("#routeDescription").html("
          <h3>Route Description</h3>
          <hr />
          <div>
            <label>Start Point</label>
            <strong>#{point.start_address}</strong>
          </div>
          <br />
          <div>
            <label>Destination</label>
            <strong>#{point.end_address}</strong>
          </div>
          <br />
          <div>
            <label>Distance</label>
            <strong>#{point.distance.text}</strong>
          </div>
          <br />
          <div>
            <label>Estimate Duration</label>
            <strong>#{point.duration.text}</strong>
          </div>
        ")
    )

  render: ->
    return (
      <div></div>
    )