ready = ->
  $('.btn-decline').click ->
    id      = $(@).data('id')
    notifId = $(@).data('notifid')
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

$(document).ready(ready)
$(document).on('page:load', ready)
