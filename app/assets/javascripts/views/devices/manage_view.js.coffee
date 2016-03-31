window.Views.Devices ||= {}
class Views.Devices.ManageView extends Views.ApplicationView
  render: ->
    super()
    $('.rest-in-place').bind 'success.rest-in-place', (event, data) ->
      console.log data

    $('.rest-in-place').bind 'failure.rest-in-place', (event, data) ->
      console.log data
