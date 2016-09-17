module.exports = React.createClass

  getInitialState: ->
    { start_adress: @props.object.start_address, end_address: @props.object.end_address,
    distance: @props.object.distance, duraton: @props.object.duration, steps: @props.object.steps }

  # steps: ->
  #   return (
  #     { @state.steps.map(val)->
  #       <div className='row'>
  #         return {val}
  #       </div>
  #     }
  #   )

  render: ->
    return (
      <h2>Route Description</h2>
      <hr />
      <div className='row'>
        <label>Start Point</label>
        <div>{@state.start_address}</div>
      </div>
      <div className='row'>
        <label>Destination</label>
        <div>{@state.end_address}</div>
      </div>
      <div className='row'>
        <label>Distance</label>
        <div>{@state.distance}</div>
      </div>
      <div className='row'>
        <label>Estimate Duration</label>
        <div>{@state.duration}</div>
      </div>
    )