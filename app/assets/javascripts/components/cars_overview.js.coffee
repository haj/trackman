R = React.DOM

SetIntervalMixin =
  componentWillMount: ->
    @intervals = []

  setInterval: ->
    @intervals.push setInterval.apply(null, arguments)

  componentWillUnmount: ->
    @intervals.map clearInterval

@CarsOverview = React.createClass

	mixins: [SetIntervalMixin]

	getInitialState: ->
		{cars: @props.cars, selected: null, filtered: null, loaded: false}

	getDefaultProps: ->
		{tableColumns: ['Type', 'Vehicle', 'Info', 'Location', 'Last Seen', 'Speed']}

	componentWillMount: ->

	componentWillReceiveProps: (props) ->
		@setState cars: props.cars
		@handleLoadedData()

	showLogbook: (props) ->
		console.log "showLogbook clicked : "
		@setState selected: props.id
		PubSub.publish 'show_logbook', props
		PubSub.publish 'select_car', props

	handleClearSelected: ->
		@setState selected: null
		PubSub.publish 'clearSelectedCar'

	handleLoadedData: ->
		@setState loaded: true

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
				R.div className: "lazy_content #{"loaded" if @state.loaded}",
					if @state.cars.length == 0
						R.div {className: 'row', style: {padding: '10px'}},
							R.div {className: 'col-md-12'},
								R.h5 {className: 'pull-left', style: {marginBottom: '0px'}}, "No cars registered yet."
								React.createElement Button, {bsStyle: 'primary', bsSize: 'xsmall', className: 'pull-right', href: '/cars/new'}, "New car"
					else
						R.div null,
							React.createElement SimpleTable, {columns: @props.tableColumns},
								for key of @state.cars
									car = @state.cars[key]
									React.createElement CarsOverviewRow, active: (@state.selected == car.id), key: car.id, onSelect: @showLogbook, car: car
							R.div className: "",
								R.div className: "row",
									R.div className: "col-md-12",
										R.div className: "pull-right",
											R.button {className: "btn btn-white btn-small btn-sm btn-cons", disabled: "#{if @state.selected then '' else 'disabled'}", onClick: @handleClearSelected}, "Clear selected"
											# R.button className: "btn btn-primary btn-xs btn-mini btn-cons", "New car"


