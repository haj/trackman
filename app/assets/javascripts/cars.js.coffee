# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

    $('.page-sidebar').css('height',$('.page-content').css('height'))
    
    if (typeof gon != "undefined") && gon.resource == "cars"
        handler = Gmaps.build('Google')

        handler.buildMap { provider: { zoom: 1 }, internal: { id: gon.map_id }}, ->
            markers = handler.addMarkers(gon.data)
            window.markers = markers
            handler.bounds.extendWith(markers)
            handler.fitMapToBounds()
            refresh_rate = 3000

            
        refreshCarsMap = (data) ->
            console.log "Refreshing cars"
            console.log(data)
            handler.removeMarkers(window.markers)
            window.markers = handler.addMarkers(data)
        gon.watch('data', interval: 3000, refreshCarsMap)


###
$(document).ready ->
    class CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
      create_marker: ->
        options = _.extend @marker_options(), @rich_marker_options()
        @serviceObject = new RichMarker options

      rich_marker_options: ->
        marker = document.createElement("div")
        marker.setAttribute('class', 'custom_marker_content')
        marker.innerHTML = this.args.custom_marker
        { content: marker }

      create_infowindow: ->
        return null unless _.isString @args.custom_infowindow

        boxText = document.createElement("div")
        boxText.setAttribute("class", 'custom_infowindow_content')
        boxText.innerHTML = @args.custom_infowindow
        @infowindow = new InfoBox(@infobox(boxText))

      infobox: (boxText)->
        content: boxText
        pixelOffset: new google.maps.Size(-140, 0)
        boxStyle:
          width: "280px"


    handler = Gmaps.build("Google", builders: { Marker: CustomMarkerBuilder } )
    handler.buildMap { internal: id: gon.map_id }, ->
      marker = handler.addMarker
        lat:               40.689167
        lng:               -74.044444
        custom_marker:     "<b>Statue of Liberty</b>"
        custom_infowindow: "The Statue of Liberty is a colossal neoclassical sculpture on Liberty Island in the middle of New York"

      handler.map.centerOn marker
      handler.getMap().setZoom(15)
###
				





				



