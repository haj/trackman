directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()
gm = google.maps

module.exports = React.createClass

  getInitialState: ->
    { order: @props.order, gmap: null, marker: null, car: @props.car }

  setInterval: ->
    setInterval(@makeRequest, (10 * 1000))    

  makeRequest: ->
    $.ajax
      method: "GET"
      dataType: "json"
      url: "/cars/#{@state.car.id}/last_position"
      data:
        order_id: @state.order.id
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
    map = new google.maps.Map(document.getElementById('map'), mapOptions)

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

  changeOverviewDetailAccepted: (data) ->
    $(".title-inline.noselect").html("
      #{data.order.customer_name} - #{data.order.package}
      &nbsp;&nbsp;
      <a href='' class='btn btn-mini btn-primary'>Done</a>
      &nbsp;
      <a href='' class='btn btn-mini btn-danger'>Cancel</a>
    ")    

  latLong: (data)->
    new gm.LatLng(data.latitude, data.longitude)

  removeMarker: ->
    if @state.marker
      @state.marker.setMap(null)

  setMarker: (data) ->
    marker  = new gm.Marker({
      position: @latLong(data),
      map: @state.gmap
    })

    @setState marker: marker

    marker.setMap(@state.gmap)

  renderMap: ->
    $.ajax
      dataType: 'json'
      type: 'GET'
      url: "/orders/#{@state.order.id}"
      success: ((data)->
        @setMapDestination(data)
        @changeOverviewDetail(data)
        @setInterval()
      ).bind(@)
    @carOverviewToggle()

  acceptDestination: ->
    $.ajax
      dataType: 'json'
      type: 'PUT'
      url: "/destinations_drivers/#{@state.order.destination_id}/accept"
      success: ((data)->
        @setMapDestination(data)
        @changeOverviewDetailAccepted(data)
        @setInterval()

        toastr.success('Success accepting an order! Have a good ride! ;)')
      ).bind(@)
    @carOverviewToggle()

  doneDestination: ->
    $.ajax
      dataType: 'json'
      type: 'PUT'
      url: "/destinations_drivers/#{@state.order.destination_id}/finish"
      success: ((data)->
        console.log data
      ).bind(@)
    @carOverviewToggle()

  declineDestination: ->
    id      = @state.order.destination_id
    notifId = @state.order.notif_id
    swal {
      title: 'Are you sure?'
      text: 'Please provide a reason!'
      type: 'input'
      showCancelButton: true
      closeOnConfirm: false
      animation: 'slide-from-top'
      inputPlaceholder: 'Write something'
      ShowLoaderOnConfirm: true
    }, (inputValue) ->
      if inputValue == false
        return false
      if inputValue == ''
        swal.showInputError 'You need to write something!'
        return false

      $('#js-input-reason').val(inputValue)
      $('#js-input-notif-id').val(notifId)
      $('#form-decline-order').attr('action', "/destinations_drivers/#{id}/decline")
      $('#form-decline-order').submit()

  cancelDestination: ->

  render: ->
    return (
      <tr>
        <td>{@state.order.customer_name}</td>
        <td>{@state.order.package}</td>
        <td>{@state.order.aasm_state}</td>
        <td>
          <a className='btn btn-mini btn-info' onClick={@renderMap} href='javascript::void(0);'>Detail</a>
          &nbsp; &nbsp; 
          {
            if @state.order.aasm_state == 'pending'
              <a className='btn btn-mini btn-primary' onClick={@acceptDestination} href='javascript::void(0);'>Accept</a>
            else
              <a className='btn btn-mini btn-primary' onClick={@doneDestination} href='javascript::void(0);'>Done</a>
          }
          &nbsp; &nbsp; 
          {
            if @state.order.aasm_state == 'pending'
              <a className='btn btn-mini btn-danger' onClick={@declineDestination} href='javascript::void(0);'>Decline</a>
            else
              <a className='btn btn-mini btn-danger' onClick={@cancelDestination} href='javascript::void(0);'>Cancel</a>
          }
        </td>
      </tr>
    )