R = React.DOM
gm = google.maps

module.exports = React.createClass
  getInitialState: ->
    {car: @props.car, device: @props.device, user: @props.user, last_location: @props.last_location}

  componentWillMount: ->
    @initMap()

  latLong: ->
    new gm.LatLng(@state.last_location.latitude, @state.last_location.longitude)

  initMap: ->
    mapOptions  = {
      zoom: 7,
      center: @latLong()
    }
    map = new gm.Map(document.getElementById('map'), mapOptions)

    @initMarker(map)

  initMarker: (map)->
    marker  = new gm.Marker({
      position: @latLong(),
      map: map
    })
    marker.setMap(map)

  render: ->
    R.div null