@module "Cars", ->
    class @Maps
        @switch_to_pins : () ->
            window.current_mode = "pins"

            handler = Gmaps.build("Google", builders: { Marker: CustomMarkerBuilder } )
            handler.buildMap { provider: { scrollwheel: false }, internal: { id: gon.map_id }}, ->

                for one_marker, i in gon.data

                    if i == 0 
                        pin = "<img width='36px' height='36px' src='<%= image_path('red_pin.png') %>'>"
                    else if gon.data.length - 1 == i
                        pin = "<img width='36px' height='36px' src='<%= image_path('green_pin.png') %>'>"
                    else
                        pin = "<img width='36px' height='36px' src='<%= image_path('yellow_pin.png') %>'>"

                    content = "<div>" + one_marker.infowindow + "</div>"
                    
                    marker = handler.addMarker
                        lat:               one_marker.lat
                        lng:               one_marker.lng
                        custom_marker:     pin
                        custom_infowindow: content
                    handler.bounds.extendWith(marker)
                    
                handler.fitMapToBounds()
                handler.getMap().setZoom(11)

                window.handler = handler

        @switch_to_directions : () ->
            window.current_mode = "directions"

            handler = Gmaps.build("Google")

            # Implement directions map
            directionsDisplay = new google.maps.DirectionsRenderer()
            directionsService = new google.maps.DirectionsService()

            handler.buildMap { provider: { scrollwheel: false }, internal: { id: gon.map_id }}, ->
                directionsDisplay.setMap handler.getMap()

            window.handler = handler
        
            array_length = gon.data.length

            if array_length != 0

                first_position = gon.data[array_length - 1]
                last_position = gon.data[0]

                sliced_array = gon.data.slice(1, array_length - 1)

                console.log("Setting origin")

                origin = new google.maps.LatLng(first_position.lat, first_position.lng)

                console.log("Setting destination")

                destination = new google.maps.LatLng(last_position.lat, last_position.lng)

                console.log("Done setting destination")

                waypts = []

                if sliced_array.length <= 8

                    waypoints_positions = sliced_array

                else 

                    steps = Math.round(sliced_array.length/6) - 1

                    index_to_fetch = 0
                    waypoints_positions = new Array

                    for i in [0...8]
                        waypoints_positions[i] = sliced_array[index_to_fetch]
                        index_to_fetch += steps
                    
                console.log("Preparing for waypoints")
                
                for waypoint in waypoints_positions.reverse()
                    if !_.isUndefined(waypoint) && !_.isUndefined(waypoint.lat) && !_.isUndefined(waypoint.lng)
                        waypts.push
                            location: new google.maps.LatLng(waypoint.lat, waypoint.lng)
                            stopover: false

                console.log("Did set waypoints")

                window.points = waypts    

                request =
                    origin: origin
                    destination: destination
                    waypoints: waypts
                    travelMode: google.maps.TravelMode.DRIVING

                directionsService.route request, (response, status) ->
                    directionsDisplay.setDirections response  if status is google.maps.DirectionsStatus.OK

            else 
                alert("Select another start/end date")
        
