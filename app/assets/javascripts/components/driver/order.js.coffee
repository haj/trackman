R = React.DOM
OrderRow = require('./order_rows')

module.exports = React.createClass

  getInitialState: ->
    {car: @props.car, device: @props.device, user: @props.user, selected: null, loaded: false, orders: @props.orders, selectedOrder: null}

  componentWillMount: ->
    @pubsub = PubSub.subscribe 'select_order', ((topic, props) ->
      @setState selectedOrder: props.order.id
    ).bind(@)

  componentDidMount: ->
    $(".cars_overview .toggle").on("click", ->
      $(".cars_overview .grid-body").toggle()
    )

  render: ->
    R.div { className: 'grid simple cars_overview overview' },
      R.div className: 'grid-title border-only-bo no-border toggle', style: {cursor: "pointer"},
        R.h4 className: "title-inline noselect", "Orders Overview"
        R.div className: "tools",
          R.a href: "javascript:;", className: "collapse"

      R.div className: 'grid-body no-border', style: {padding:'0px'},
        R.div className: "lazy_content loaded",
          if @state.orders.length == 0
            R.div {className: 'row', style: {padding: '10px'}},
              R.div {className: 'col-md-12'},
                R.h5 {className: 'pull-left', style: {marginBottom: '0px'}}, "No orders yet."
          else
            R.div null,
              React.createElement Table, {className: 'simple_table mi-size', style: {borderBottom: '1px solid #eee'}, striped: true, condensed: true, responsive: true, hover: true},
                R.thead null,
                  R.tr null,
                    R.th null, "Customer Name"
                    R.th null, "Package"
                    R.th null, "Status"
                    R.th null, "Quick Action"
                for key of @state.orders
                  order = @state.orders[key]
                  if !@state.selectOrder || (order && @state.selectedOrder)
                    React.createElement OrderRow, key: order.id, order: order, car: @state.car


