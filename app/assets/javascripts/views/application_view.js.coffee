window.Views ||= {}
class Views.ApplicationView
  render: ->
    $('#layout-condensed-toggle-two .iconset').click ->
      $('body').condensMenu()

    window.Button = ReactBootstrap.Button
    window.ButtonToolbar = ReactBootstrap.ButtonToolbar
    window.Table = ReactBootstrap.Table
