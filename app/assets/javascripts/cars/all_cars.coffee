@module "Cars", ->
    class @AllCars
        @show : () ->
            handler = Gmaps.build("Google", builders: { Marker: CustomMarkerBuilder } )
            handler.buildMap { provider: { scrollwheel: false }, internal: { id: gon.map_id }}, ->
                #markers = handler.addMarkers(gon.data)

                for one_marker, i in gon.data

                    infos = one_marker.infowindow.split("/");

                    if infos[1] == ""
                        infos[1] = "No Driver"

                    pin = "<img width='36px' height='36px' src='<%= image_path('red_pin.png') %>'>"
                    
                    content = "<div class='map-tooltip' ><p>"+ infos[0] + "</p><p>" + infos[1] + "</p><p>" + infos[2] + "</p></div>" 

                    
                    marker = handler.addMarker
                        lat:               one_marker.lat
                        lng:               one_marker.lng
                        custom_marker:     pin
                        custom_infowindow: content

                    handler.bounds.extendWith(marker)
                    
                handler.fitMapToBounds()
                handler.getMap().setZoom(3)