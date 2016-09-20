R = React.DOM

IntervalMixin = require('../utils/interval_mixin')
LogBook       = require('./log_book')
Order         = require('./order')
Map           = require('./map')
Reflux        = require('reflux')
Actions       = require('../utils/actions')
ReactInterval = require('react-interval')

module.exports = React.createClass

  getInitialState: ->
    {car: @props.car, device: @props.device, user: @props.user}

  render: ->
    R.div null,
      R.div className: "row",
        R.div className: "col-md-12 top-analyze-view", style: {position: "relative"},
          # Map
          R.div {className: "col-md-12 home-map no-padding"},
            React.createElement Map,
              car: @state.car,
              user: @state.user

          # Cars Overview
          R.div {className: "col-md- home-cars-overview", style: {position: "absolute", right: "0px", top: "0px", zIndex: "2"}},
            React.createElement Order,
              car: @state.car,
              user: @state.user

      R.div className: "row",
        # Logbook
        R.div className: "col-md-12",
        React.createElement LogBook,
          car: @state.car,
          user: @state.user
