module.exports = React.createClass

  getInitialState: ->
    {order: @props.order}

  render: ->
    return (
      <tr>
        <td>{@state.order.customer_name}</td>
        <td>{@state.order.package}</td>
        <td>{@state.order.aasm_state}</td>
        <td><a href="/orders/#{@state.order.id}" className='btn btn-mini btn-primary'>Detail</a></td>
      </tr>
    )