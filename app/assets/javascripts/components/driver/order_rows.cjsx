directionsService = new google.maps.DirectionsService()
directionsDisplay = new google.maps.DirectionsRenderer()
gm = google.maps

module.exports = React.createClass

  getInitialState: ->
    { order: @props.order, gmap: null, marker: null, car: @props.car, isShow: true, interval: null, selectedOrder: null, active_order: @props.active_order }

  setInterval: ->
    interval = setInterval(@makeRequest, (10 * 1000))    
    @setState interval: interval

  makeRequest: ->
    $.ajax
      method: "GET"
      dataType: "json"
      url: "/cars/#{@props.car.id}/last_position"
      data:
        order_id: @props.order.id
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
    PubSub.publish 'render_map', {order: @props.order}

  acceptDestination: ->
    PubSub.publish 'accept_destination', {order: @props.order}
    PubSub.publish 'select_order', {order: @props.order}
    @setState
      order:
        aasm_state: 'accepted'
      selectedOrder: @props.order.id


  doneDestination: ->
    PubSub.publish 'done_destination', {order: @props.order}

  declineDestination: ->
    @cancelDecline('decline')

  cancelDestination: ->
    @cancelDecline('cancel')

  cancelDecline: (status)->
    id      = @props.order.destination_id
    notifId = @props.order.notif_id
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
      $('#form-decline-order').attr('action', "/destinations_drivers/#{id}/#{status}")
      $('#form-decline-order').submit()

  render: ->
    return (
      <tbody>
        {
          if @state.isShow
            <tr>
              <td>{@props.order.customer_name}</td>
              <td>{@props.order.package}</td>
              <td>{@props.order.aasm_state}</td>
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
        }
      </tbody>
    )