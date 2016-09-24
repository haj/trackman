R = React.DOM

module.exports = React.createClass

  getInitialState: ->
    {car: @props.car, all_orders: @props.all_orders}

  render: ->
    R.div null,
      R.div {className: 'logbook_section', ref: 'logbook'},
        R.div className: "col-md-12 no-padding",
			    R.div className: 'grid simple dragme',
			      R.div className: 'grid-title border-only-bot',
		          R.h4 null, 'Order List'
			      R.div { className: 'no-border', style: { background: '#fff' }},
              React.createElement Table, {className: 'mi-size', ref: 'logbook_data', style: {borderBottom: '1px solid #eee'}, striped: true, condensed: false, responsive: true, hover: true},
                R.thead null,
                  R.tr null,
                    R.th null, "Customer Name"
                    R.th null, "Package"
                    R.th null, "Status"
                R.tbody null,
                    $.map @state.all_orders, (item, key) ->
                      R.tr {key: key, className: 'position_row', style: {verticalAlign: 'middle'}},
                        R.td className: 'col-md-4', item.customer_name
                        R.td className: 'col-md-4', item.package
                        R.td className: 'col-md-4', item.des_state
