R = React.DOM

@SimpleTable = React.createClass

	render: ->
		window.children = @props.children
		React.createElement Table, {className: 'simple_table mi-size', striped: true, condensed: true, responsive: true, hover: true},
			R.thead null,
				R.tr null,
					R.th null, col for col in @props.columns
			R.tbody null,
				@props.children
