R = React.DOM

@LogBook = React.createClass

	getInitialState: ->
		{data: [], car_id: []}

	componentWillMount: ->
		@pubsub = PubSub.subscribe 'show_logbook', ((topic, props) ->
			@setState car_id: props.id
			self = @

			$.ajax
				url: "/home/logbook_data"
				data: car_id: props.id
				type: 'get'
				success: (data) ->
					self.setState data: data
					console.log data
				error: (data) ->
					self.setState data: []

		).bind(@)

	componentWillUnmount: ->
		PubSub.unsubscribe @pubsub

	# showRoad: (date) ->

 #    show_road = (data) ->
 #      Cars.Maps.switch_to_directions data

	# 	alert 'show road here'

 #    gon.watch 'road', { url: '/one_car_render_directions?car_id=' + @state.car_id + '&date=' + date }, show_road
 #    # $('.map-title').empty().html 'Route of ' + car_name + ' <small>| ' + date + '</small>'

	render: ->

		step = (state, step) ->
			if state == "start"
				R.a {className: 'badge badge-success'}, step
			else if state == "stop"
				R.a {className: 'badge badge-danger'}, step

		duration = (item) ->
			parking_duration = moment.duration(parseInt(item.parking_duration), "seconds").format("h [hrs], m [min]")
			driving_duration = moment.duration(parseInt(item.driving_duration), "seconds").format("h [hrs], m [min]")
			if item.parking_duration || item.driving_duration
				"P : #{parking_duration} | D : #{driving_duration}"

		React.createElement SimpleGrid, title: 'LogBook',
			for x in @state.data
				R.div null,
					R.table className: 'table',
						R.tr {className: 'row', style:{borderBottom: '1px solid #ddd'}},#1b1e24
							R.th {className: 'text-info col-md-1', style: {color: 'black'}},
								R.a {href: '#'}, x[0]
							R.th {className: 'col-md-2', style: {color: 'black'}},
								# R.a {href:'#', onClick: @showRoad(x[0]), style: {color: 'white', textDecoration: 'underline'}}, 'Show in the map'
							R.th {className: 'col-md-2', style: {color: 'white'}} # , driving time
							R.th {className: 'col-md-7', style: {color: 'white'}}

					React.createElement SimpleTable,
					{columns: ['state', 'time', 'P/D', 'location', 'speed']},
						$.map x[1], (item, key) ->
							R.tr null,
								R.td className: 'col-md-1', step item.state, item.step
								R.td className: 'col-md-1', item.time.substring(11, 19)
								R.td className: 'col-md-2', duration item
								R.td className: 'col-md-6', item.address
								R.td className: 'col-md-2', Math.floor(item.speed)


