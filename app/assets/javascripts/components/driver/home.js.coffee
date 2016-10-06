R = React.DOM

IntervalMixin = require('../utils/interval_mixin')
LogBook       = require('./log_book')
Order         = require('./order')
Map           = require('./map')

module.exports = React.createClass

  getInitialState: ->
    {car: @props.car, device: @props.device, user: @props.user, last_location: @props.last_location, orders: @props.orders, all_orders: @props.all_orders, active_order: @props.active_order}

  render: ->
    R.div null,
      R.div className: "row",
        R.div className: "col-md-12 top-analyze-view", style: {position: "relative"},
          # Map
          R.div {className: "col-md-12 home-map no-padding"},
            React.createElement Map,
              car: @state.car,
              user: @state.user,
              device: @state.device,
              last_location: @state.last_location,
              active_order: @state.active_order

          # Cars Overview
          R.div {className: "col-md- home-cars-overview", style: {position: "absolute", right: "0px", top: "0px", zIndex: "2"}},
            React.createElement Order,
              car: @state.car,
              user: @state.user,
              orders: @state.orders

      R.div className: "row",
        # Logbook
        R.div className: "col-md-12",
        React.createElement LogBook,
          car: @state.car,
          user: @state.user,
          all_orders: @state.all_orders
