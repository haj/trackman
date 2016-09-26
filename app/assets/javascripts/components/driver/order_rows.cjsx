directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()

module.exports = React.createClass

  getInitialState: ->
    { order: @props.order }

  setMapDestination: (data)->
    destination = new google.maps.LatLng(data.latitude_origin, data.longitude_origin)
    mapOptions  = {
      zoom: 7,
      center: destination
    }
    map = new google.maps.Map(document.getElementById('map'), mapOptions)
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

  renderMap: ->
    $.ajax
      dataType: 'json'
      type: 'GET'
      url: "/orders/#{@state.order.id}"
      success: ((data)->
        @setMapDestination(data)
      ).bind(@)
    @carOverviewToggle()
    
  acceptDestination: ->
    $.ajax
      dataType: 'json'
      type: 'PUT'
      url: "/destinations_drivers/#{@state.order.destination_id}/accept"
      success: ((data)->
        @setMapDestination(data)
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