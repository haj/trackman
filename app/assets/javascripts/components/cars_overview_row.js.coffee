R = React.DOM

@CarsOverviewRow = React.createClass

  handleClick: (e) ->
    e.preventDefault()
    @props.onSelect @props.data

  render: ->
    className = if @props.active then "active_row" else ""
    R.tr {className: className, onClick: @handleClick, key: "#{@props.data.id}", style: {cursor: 'pointer'}},
      R.td className: 'col-md-2', @props.data.type
      R.td {className: 'col-md-2'}, @props.data.name
      R.td className: 'col-md-1', @props.data.numberplate
      R.td {className: 'col-md-4', style: {wordBreak: 'break-all'}}, @props.data.last_location
      R.td className: 'col-md-2', @props.data.last_seen
      R.td className: 'col-md-1', "#{Math.floor(@props.data.speed)} km/h"
