R = React.DOM

IntervalMixin = require('../utils/interval_mixin')
# Order         = require('./order')
Map           = require('./map')

module.exports = React.createClass
  getInitialState: ->
    {current_latitude: @props.latitude, current_longitude: @props.longitude}

  render: ->
    R.div null,
      R.div className: "row",
        R.div className: "col-md-12 top-analyze-view", style: {position: "relative"},
          # Map
          R.div {className: "col-md-12 home-map no-padding"},
            React.createElement Map,
              current_latitude: @state.current_latitude,
              current_longitude: @state.current_longitude

          # Cars Overview
          # R.div {className: "col-md- home-cars-overview", style: {position: "absolute", right: "0px", top: "0px", zIndex: "2"}},
          #   React.createElement Order
