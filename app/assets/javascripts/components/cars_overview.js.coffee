R = React.DOM

SetIntervalMixin =
  componentWillMount: ->
    @intervals = []

  setInterval: ->
    @intervals.push setInterval.apply(null, arguments)

  componentWillUnmount: ->
    @intervals.map clearInterval

@CarsOverview = React.createClass

	color: "black"

	mixins: [SetIntervalMixin]

	getInitialState: ->
		{cars: {}, selected: null, filtered: null, loaded: false}

	getDefaultProps: ->
		{tableColumns: ['Type', 'Vehicle', 'Info', 'Location', 'Last Seen', 'Speed']}

	componentWillMount: ->

	componentWillReceiveProps: (props) ->
		@setState cars: props.cars

	componentDidMount: ->

	componentWillUpdate: (nextProps, nextState) ->
		console.log "will update"
		console.log nextState.selected

	focused: (id) ->
		# if @state.selected == id
		if false
			"black"
		else
		 	""

	handleFilter: (filtered) ->
		@setState filtered: filtered
		# @forceUpdate()

	# setActiveRow: (id) ->
	# 	@setState selected: id

	showLogbook: (props) ->
		console.log "showLogbook clicked : "
		# @getDOMNode.toggleClass "col-md-12"
		# console.log $(@getDOMNode())
		# @setState selected: @getDOMNode
		# @color = "col-md-6"
		@setState selected: props.id
		PubSub.publish 'show_logbook', props
		PubSub.publish 'select_car', props
		# if !isNaN(props.lat) || !isNaN(props.lon)

	render: ->
		R.div className: 'grid simple cars_overview overview h-scroll dragme',
			R.div className: 'grid-title border-only-bot',
				R.h4 className: "title-inline", "Overview"

				# R.span className: 'options',
				# 	R.ul className: '',
				# 		R.li className: '',
				# 			R.a {ref: "all_cars_click", href: "#", onClick: @handleFilter.bind(null, "All")}, "All"
				# 		R.li className: '',
				# 			R.a {ref: "active_cars_click", href: "#", onClick: @handleFilter.bind(null, "Active")}, "Active"

			R.div className: 'grid-body no-border', style: {padding:'0px'},
				if @state.cars.length == 0
					R.div {className: 'row', style: {padding: '10px'}},
						R.div {className: 'col-md-12'},
							R.h5 {className: 'pull-left', style: {marginBottom: '0px'}}, "No cars registered yet."
							React.createElement Button, {bsStyle: 'primary', bsSize: 'xsmall', className: 'pull-right', href: '/cars/new'}, "New car"
				else
					React.createElement SimpleTable, {columns: @props.tableColumns},
						@state.cars.map ((data) ->
							React.createElement CarsOverviewRow, active: (@state.selected == data.id), key: data.id, onSelect: @showLogbook, data: data
						).bind(@)



