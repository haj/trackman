R = React.DOM

CarsOverviewRow = require('./cars_overview_row')

module.exports = React.createClass

	getInitialState: ->
		{cars: @props.cars, selected: null, loaded: false}

	componentWillMount: ->

	componentWillReceiveProps: (props) ->
		@setState cars: props.cars
		@handleLoadedData()

	showLogbook: (props) ->
		console.log "showLogbook clicked : "
		console.log props
		@setState selected: props.id
		PubSub.publish 'show_logbook', props
		# PubSub.publish 'show_last_route_on_map', props

	handleClearSelected: ->
		@setState selected: null
		PubSub.publish 'clearSelectedCar'

	handleLoadedData: ->
		@setState loaded: true

	render: ->
		R.div className: 'grid simple cars_overview overview dragme',
			R.div className: 'grid-title border-only-bot',
				R.h4 className: "title-inline", "Overview"

			R.div className: 'grid-body no-border', style: {padding:'0px'},
				R.div className: "lazy_content #{"loaded" if @state.loaded}",
					if @state.cars.length == 0
						R.div {className: 'row', style: {padding: '10px'}},
							R.div {className: 'col-md-12'},
								R.h5 {className: 'pull-left', style: {marginBottom: '0px'}}, "No cars registered yet."
								React.createElement Button, {bsStyle: 'primary', bsSize: 'xsmall', className: 'pull-right', href: '/cars/new'}, "New car"
					else
						R.div null,
							React.createElement Table, {className: 'simple_table mi-size', style: {borderBottom: '1px solid #eee'}, striped: true, condensed: true, responsive: true, hover: true},
								R.thead null,
									R.tr null,
										R.th null, "Type"
										R.th null, "Vehicle"
										R.th null, "Location"
										R.th null, "Last seen"
										R.th null, "Speed"
								R.tbody null,
									for key of @state.cars
										car = @state.cars[key]
										React.createElement CarsOverviewRow, active: (@state.selected == car.id), key: car.id, onSelect: @showLogbook, car: car

					R.div {className: ""},
						R.div className: "row",
							R.div className: "col-md-12",
								R.div className: "pull-right",
									R.button {className: "btn btn-white btn-small btn-sm btn-cons", disabled: "#{if @state.selected then '' else 'disabled'}", onClick: @handleClearSelected}, "Clear selected"


