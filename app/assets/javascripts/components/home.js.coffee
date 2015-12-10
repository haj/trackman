R = React.DOM

IntervalMixin = require('./utils/interval_mixin')

LogBook = require('./log_book')
CarsOverview = require('./cars_overview')
Map = require('./map')
Hello = require('./hello')

module.exports = React.createClass

  mixins: [IntervalMixin]

  getInitialState: ->
    {cars: []}

  componentWillMount: ->
    @fetchData()
    @setInterval @fetchData, 5000

  fetchData: ->
    $.getJSON @props.carsOverviewPath, ((data) ->
      @setState cars: data
    ).bind(@)

  render: ->
    R.div className: "col-md-12",

      # Map
      R.div {className: "col-md-6 no-padding"},
        React.createElement Map,
          carsIndexPath: @props.carsIndexPath,
          cars: @state.cars, title: "All vehicles",
          pinIcon: @props.pinIcon

      # Cars Overview
      R.div {className: "col-md-6 no-padding"},
        React.createElement CarsOverview,
        carsOverviewPath: @props.carsOverviewPath,
        cars: @state.cars

      # Logbook
      React.createElement LogBook
