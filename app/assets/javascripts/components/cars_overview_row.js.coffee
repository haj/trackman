R = React.DOM

@CarsOverviewRow = React.createClass

  handleClick: (e) ->
    e.preventDefault()
    @props.onSelect @props.car

  render: ->
    className = if @props.active then "active_row" else ""
    R.tr {className: className, onClick: @handleClick, key: "#{@props.car.id}", style: {cursor: 'pointer'}},
      R.td className: 'col-md-2', @props.car.type
      R.td {className: 'col-md-2'}, @props.car.name
      R.td className: 'col-md-1', @props.car.numberplate
      R.td {className: 'col-md-4', style: {wordBreak: 'break-all'}}, @props.car.last_location
      R.td className: 'col-md-2', @props.car.last_seen
      R.td className: 'col-md-1', "#{Math.floor(@props.car.speed)} km/h"
