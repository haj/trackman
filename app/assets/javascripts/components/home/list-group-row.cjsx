R = React.DOM

module.exports = React.createClass

	getInitialState: ->
		{statistics: @props.statistics, date: @props.date, car: @props.car, car_id: @props.car.id, active: @props.active, statistics_for_day: {max: null, avg: null, tdistance:  null, tparktime: null, tdrivtime: null}}

	isActive: ->
		'list-group-item logbook '+( if @state.date == @props.selectedDate then 'active' else '')

	get_car_statistics: ->
		console.log "getting cars statistics !!!"
		@setState {
			tdistance: "00.00"
			avg: "00.00"
			max: "00.00" } , ( ->
				api.getWithParams("/car_statistics", {car_id: @state.car.id, date: @props.selectedDate}).then ((stats) ->
					@setState
						statistics_for_day:
							tdistance: stats.tdistance.toFixed(2)
							avg: stats.avgspeed.toFixed(2)
							max: stats.maxspeed.toFixed(2)
							tparktime: stats.tparktime
							tdrivtime: stats.tdrivtime
				).bind(@)
			).bind(@)

	componentWillMount: ->
		@get_car_statistics()

	handleOnClick: (e) ->
		e.preventDefault()
		@props.onClick()
		@get_car_statistics()

	render: ->
		tparktime = moment.duration(parseInt(@state.statistics_for_day.tparktime), "seconds").format("h [hrs], m [min]")
		tdrivtime = moment.duration(parseInt(@state.statistics_for_day.tdrivtime), "seconds").format("h [hrs], m [min]")
		return (
			<a href="#" className={@isActive()} onClick={@handleOnClick}>
				<h4 className="list-group-item-heading">{@state.date}</h4>
				<div className="list-group-item-content">
					<p>Distance : {@state.statistics_for_day.tdistance} Km</p>
					<p>Max speed : {@state.statistics_for_day.max} Km/h</p>
					<p>Avg speed : {@state.statistics_for_day.avg} Km/h</p>
					<p>Parking duration : {tparktime}</p>
					<p>Driving duration : {tdrivtime}</p>
				</div>
			</a>
		)