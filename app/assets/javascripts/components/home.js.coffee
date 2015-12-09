R = React.DOM

@Home = React.createClass

  getInitialState: ->
    {cars: []}

  componentWillMount: ->
    @fetchData()
    @interval = setInterval @fetchData, 5000
    $(window).focus (() ->
      @fetchData()
      clearInterval(@interval)
      @interval = setInterval @fetchData, 5000
    ).bind(@)
    $(window).focusout (() ->
      clearInterval(@interval)
    ).bind(@)

  fetchData: ->
    $.getJSON @props.carsOverviewPath, ((data) ->
      @setState cars: data
    ).bind(@)

  render: ->
    console.log "Rendering Home Component..."
    R.div className: "col-md-12",

      # Map
      R.div {className: "col-md-6 no-padding", ref: "mapRef"},
        React.createElement Map, carsIndexPath: @props.carsIndexPath, cars: @state.cars, title: "All vehicles"

      # Cars Overview
      R.div {className: "col-md-6 no-padding", ref: "overviewRef"},
        React.createElement CarsOverview, carsOverviewPath: @props.carsOverviewPath, cars: @state.cars

      # Logbook
      React.createElement LogBook
