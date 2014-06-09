$(document).ready ->

  if $('#map_canvas').length

    $('#submit_poylgon').click ->
      for marker in markers 
        console.log(marker.position['d'] + " , " + marker.position['e'])
        

    addPoint = (event) ->
      path.insertAt path.length, event.latLng
      marker = new google.maps.Marker(
        position: event.latLng
        map: map
        draggable: true
      )
      markers.push marker
      marker.setTitle "#" + path.length
      google.maps.event.addListener marker, "click", ->
        marker.setMap null
        i = 0
        I = markers.length

        while i < I and markers[i] isnt marker
          ++i
        markers.splice i, 1
        path.removeAt i
        return

      google.maps.event.addListener marker, "dragend", ->
        i = 0
        I = markers.length

        while i < I and markers[i] isnt marker
          ++i
        path.setAt i, marker.getPosition()
        return

      return

    markers = []
    path = new google.maps.MVCArray
    uluru = new google.maps.LatLng(-25.344, 131.036)
    map = new google.maps.Map(document.getElementById("map_canvas"),
      zoom: 14
      center: uluru
      mapTypeId: google.maps.MapTypeId.SATELLITE
    )
    poly = new google.maps.Polygon(
      strokeWeight: 3
      fillColor: "#5555FF"
    )
    poly.setMap map
    poly.setPaths new google.maps.MVCArray([path])
    google.maps.event.addListener map, "click", addPoint
