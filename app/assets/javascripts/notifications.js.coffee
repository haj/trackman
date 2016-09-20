ready = ->
  $('.infinite-table').infinitePages
    loading: ->
      $(this).text('Loading next page...')
    error: ->
      $(this).button('There was an error, please try again')

  $('.btn-decline').click ->
    cancel_decline($(@), 'decline')

  $('.btn-cancel').click ->
    cancel_decline($(@), 'cancel')

  cancel_decline = (elm, status)->
    id      = elm.data('id')
    notifId = elm.data('notifid')
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

$(document).ready(ready)
$(document).on('page:load', ready)
