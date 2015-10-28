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
		{cars: [], focused: []}

	componentDidMount: ->
		@fetchData()
		@setInterval @fetchData, 1000

	fetchData: ->
		$.getJSON @props.carsOverviewPath, ((data) ->
			@setState cars: data
		).bind(@) if @isMounted

	showLogbook: (e) ->
		row = $(e.target).parent('tr')
		car_id = row.data('car-id')
		car_name = row.data('car-name')
		car_last_seen = row.data('last-seen')
		@setState focused: row.index()
		# console.log "row #{row.index()} selected"
		PubSub.publish 'cars_overview', car_id, car_name, car_last_seen

	render: ->
		React.createElement SimpleGrid, title: 'Overview',
			R.div null,
				if @state.cars.length == 0
					R.div {className: 'row', style: {padding: '10px'}},
						R.div {className: 'col-md-12'},
							R.h4 {className: 'pull-left', style: {marginBottom: '0px'}}, "No cars registered yet."
							React.createElement Button, {bsStyle: 'primary', bsSize: 'xsmall', className: 'pull-right', href: '/cars/new'}, "New car"
				else
					React.createElement SimpleTable,
					{columns: ['Type', 'Vehicle', 'Info', 'Location', 'Last Seen', 'Speed']},
						for data in @state.cars
							R.tr {className: 'show_logbook', onClick: @showLogbook, key: "#{data.id}", style: {cursor: 'pointer'}, 'data-car-id': data.id, 'data-car-name': data.name, 'data-last-seen': data.last_seen},
								R.td className: 'col-md-2', data.type
								R.td {className: 'col-md-2'}, data.name
								R.td className: 'col-md-1', data.numberplate
								R.td {className: 'col-md-3', style: {wordBreak: 'break-all'}}, data.last_location
								R.td className: 'col-md-2', data.last_seen
								R.td className: 'col-md-1', "#{data.speed} km/h"


