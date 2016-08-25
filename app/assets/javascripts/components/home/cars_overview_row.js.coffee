R = React.DOM

module.exports = React.createClass

  handleClick: (e) ->
    e.preventDefault()
    @props.onSelect @props.car

  render: ->
    speed = Math.floor(@props.car.speed)
    date = moment(@props.car.last_seen).utc().local().fromNow()
    console.log("testggs")
    console.log(@props.car)

    className = if @props.active then "active_row" else ""
    R.tr {className: className, onClick: @handleClick, key: "#{@props.car.id}", style: {cursor: 'pointer'}},
      R.td className: 'col-md-2', @props.car.type
      R.td {className: 'col-md-2'}, @props.car.name
      R.td {className: 'col-md-4', style: {overflow: 'hidden', whiteSpace: 'nowrap'}}, @props.car.last_location
      R.td className: 'col-md-2', date
      R.td className: 'col-md-2',
        if speed >= 0
          "#{speed} km/h"
        else
          '-'
