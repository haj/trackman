R = React.DOM

SetIntervalMixin =
  componentWillMount: ->
    @intervals = []

  setInterval: ->
    @intervals.push setInterval.apply(null, arguments)

  componentWillUnmount: ->
    @intervals.map clearInterval

@CarsOverview = React.createClass

	color: ""

	mixins: [SetIntervalMixin]

	getInitialState: ->
		{cars: [], focused_row: null}

	componentWillMount: ->
		# console.log "componentWillMount in CarsOverview Component"
		# console.log @state.cars
		# console.log @props.cars
		# @fetchData()
		# @setInterval @fetchData, 10000
		# @setState cars: @props.data

	componentWillReceiveProps: (props) ->
		@setState cars: props.cars
		# console.log "componentWillReceiveProps CarsOverview (state) =>"
		# console.log @state.cars
		# console.log "componentWillReceiveProps (props) : "+@props.cars

	componentDidMount: ->
		# console.log "Did mount cars_overview"
		# console.log @refs.trs
		# console.log "componentDidMount CarsOverview (state) =>"
		# @setState cars: @props.data
		# console.log @state.cars
		# console.log "componentDidMount (props): "+@props.cars

	componentWillUpdate: (nextProps, nextState) ->
		console.log "will update"
		console.log nextState.focused_row

	focused: ->
		"black"

	showLogbook: (props, that) ->
		console.log "showLogbook clicked : "
		# @getDOMNode.toggleClass "col-md-12"
		console.log $(that.getDOMNode())
		# @setState focused_row: @getDOMNode
		# @color = "col-md-6"
		PubSub.publish 'show_logbook', props
		PubSub.publish 'select_car', props
		# if !isNaN(props.lat) || !isNaN(props.lon)

	render: ->
		# console.log "CarsOverview Rendering (state) =>"
		# console.log @state.cars
		# console.log "CarsOverview Rendering (props) : " + @props.cars
		React.createElement SimpleGrid, title: 'Overview',
			R.div null,
				if @state.cars.length == 0
					R.div {className: 'row', style: {padding: '10px'}},
						R.div {className: 'col-md-12'},
							R.h5 {className: 'pull-left', style: {marginBottom: '0px'}}, "No cars registered yet."
							React.createElement Button, {bsStyle: 'primary', bsSize: 'xsmall', className: 'pull-right', href: '/cars/new'}, "New car"
				else
					React.createElement SimpleTable,
					{columns: ['Type', 'Vehicle', 'Info', 'Location', 'Last Seen', 'Speed']},
						for data in @state.cars
							R.tr {className: @color, ref: "item", onClick: @showLogbook.bind(@, data, @), key: "#{data.id}", style: {cursor: 'pointer', backgroundColor: @focused}, car_id: data.id, car_name: data.name, car_last_seen: data.last_seen, car_lat: data.lat, car_lon: data.lon},
								R.td className: 'col-md-2', data.type
								R.td {className: 'col-md-2'}, data.name
								R.td className: 'col-md-1', data.numberplate
								R.td {className: 'col-md-4', style: {wordBreak: 'break-all'}}, data.last_location
								R.td className: 'col-md-2', data.last_seen
								R.td className: 'col-md-1', "#{data.speed} km/h"


