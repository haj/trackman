R = React.DOM

@LogBook = React.createClass

	getInitialState: ->
		{data: [], car_id: []}

	componentWillMount: ->
		@pubsub = PubSub.subscribe 'cars_overview', ((topic, car_id, car_name, car_last_seen) ->
			@setState car_id: car_id
			self = @

			$.ajax
				url: "/home/logbook_data"
				data: car_id: car_id
				type: 'get'
				success: (data) ->
					self.setState data: data
					console.log data.length
				error: (data) ->
					self.setState data: []

		).bind(@)

	componentWillUnmount: ->
		PubSub.unsubscribe @pubsub

	render: ->

		status = (status) ->
			@steps = 1
			if status == "start"
				R.a {className: 'badge badge-success'}, @steps
			else if status == "stop"
				R.a {className: 'badge badge-danger'}, @steps+=1

		React.createElement SimpleGrid, title: 'LogBook',
			for x in @state.data
				R.div null,
					R.table className: 'table',
						R.tr {className: 'row', style: {backgroundColor: '#1b1e24'}},
							R.th {className: 'col-md-2', style: {color: 'white'}}, x[0]
							R.th {className: 'col-md-1', style: {color: 'white'}}, "P : 19:39"
							R.th {className: 'col-md-1', style: {color: 'white'}}, "D : 16:30"
							R.th {className: 'col-md-8', style: {color: 'white'}}

					React.createElement SimpleTable,
					{columns: ['status', 'time', 'info', 'location', 'speed']},
						$.map x[1], (item, key) ->
							R.tr null,
								R.td className: 'col-md-1', status item.status
								R.td className: 'col-md-2', item.time.substring(11, 19)
							  R.td className: 'col-md-2', item.status
#								R.td className: 'col-md-2', "P : #{item.parking_duration} | D : #{item.duration_duration}"
								R.td className: 'col-md-5', item.address
								R.td className: 'col-md-2', item.speed


