directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()
geocoder          = new google.maps.Geocoder()

module.exports = React.createClass

  getInitialState: ->
    { car: @props.car, order_id: @props.order.id, latitude_origin: @props.latitude_origin, 
    longitude_origin: @props.longitude_origin, latitude_destination: @props.order.latitude, 
    longitude_destination: @props.order.longitude, package: @props.order.package, 
    customer_name: @props.order.customer_name, selected_driver: @props.selected_driver }

  componentWillMount: ->
    @initMap()
    @setCurrentState()
    @calcRoute()

  initMap: ->
    destination = new google.maps.LatLng(@state.latitude_destination, @state.longitude_destination)
    mapOptions  = {
      zoom: 7,
      center: destination
    }
    map = new google.maps.Map(document.getElementById('map'), mapOptions)
    directionsDisplay.setMap(map)

  destination: ->
    "#{@state.latitude_destination}, #{@state.longitude_destination}"

  setCurrentState: ->
    if navigator.geolocation
      window.test = navigator
      navigator.geolocation.getCurrentPosition((position)->
        @setState
          latitudde_origin: position.coords.latitude
          longitude_origin: position.coords.longitude
      )

  origin: ->
    "#{@state.latitudde_origin}, #{@state.longitude_origin}"

  calcRoute: ->
    request = {
      origin: @origin(),
      destination: @destination(),
      travelMode: 'DRIVING'
    }
    directionsService.route(request, (result, status) ->
      if status == 'OK'
        directionsDisplay.setDirections(result)
    )

  render: ->
    return (
      <div className='GMap'></div>
    )