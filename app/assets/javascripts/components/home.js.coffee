R = React.DOM

@Home = React.createClass

  getInitialState: ->
    {cars: []}

  componentWillMount: ->
    @fetchData()
    setInterval @fetchData, 5000
    # @pubsub = PubSub.subscribe "toggleWidthView", ((map) ->
    #   if @MapStyle == "col-md-6 no-padding" and @OverviewStyle == "col-md-6 no-padding"
    #     @fullWidthView()
    #   else
    #     @halfWidthView()
    #   google.maps.event.trigger(map, "resize")
    # ).bind(@)

  componentWillUnmount: ->
    @pubsub.unsubscribe

  fetchData: ->
    $.getJSON @props.carsOverviewPath, ((data) ->
      @setState cars: data
      console.log "Data received in Home Component..."
      console.log @state.cars
    ).bind(@)

  fullWidthView: ->
    console.log @refs.mapRef
    React.findDOMNode(@refs.mapRef).toggleClass("col-md-6 no-padding")
    React.findDOMNode(@refs.overviewRef).toggleClass("col-md-6 no-padding")
    alert "finished resizing container"

  halfWidthView: ->
    console.log @refs.mapRef
    React.findDOMNode(@refs.mapRef).toggleClass("col-md-6 no-padding")
    React.findDOMNode(@refs.overviewRef).toggleClass("col-md-6 no-padding")
    alert "finished resizing container"

  render: ->
    console.log "Rendering Home Component..."
    R.div className: "col-md-12",

      # Map
      R.div {className: "col-md-6 no-padding", ref: "mapRef"},
        React.createElement Map, carsIndexPath: @props.carsIndexPath, cars: @state.cars

      # Cars Overview
      R.div {className: "col-md-6 no-padding", ref: "overviewRef"},
        React.createElement CarsOverview, carsOverviewPath: @props.carsOverviewPath, cars: @state.cars

      # Logbook
      React.createElement LogBook
