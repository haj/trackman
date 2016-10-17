R = React.DOM
gm = google.maps
directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()

module.exports = React.createClass
  getInitialState: ->
    {gmap: null, marker: null}

  componentDidMount: ->
    @initMap()

  latLong: ->
    new gm.LatLng(@props.current_latitude, @props.current_longitude)

  initMap: ->
    mapOptions  = {
      zoom: 7,
      center: @latLong()
    }
    map = new gm.Map(ReactDOM.findDOMNode(@refs.map_canvas), mapOptions)

    @setState gmap: map

  render: ->
    R.div className: 'grid simple dragme', style: {marginBottom: "0px"},
      R.div className: 'grid-title border-only-bo no-border',
        R.h4 null, 'Customer Tracking'
        R.div className: 'tools',
          # R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
          #   R.i className: 'fa fa-arrows-h fa-lg', onClick: @resizeMap
      R.div className: 'grid-body no-border', style: {padding:'0px'},
        R.div className: "GMap",
          R.div, null
            # R.div className: "overlay standard #{if !@state.loading then "hidde" else ""}"
            R.div className: "overlay-label standard loading-label hidde", "Loading ..."
            R.div className: "overlay-label standard live-label hidde", "Live"
            R.div ref: "map_canvas", key: "map_canvas", style: {height: '100%', width: '100%'}
