R = React.DOM

@SimpleGrid = React.createClass

	render: ->
		R.div className: 'grid simple h-scroll dragme',

			R.div className: 'grid-title border-only-bot',
				R.h4 null, @props.title
				R.div className: 'tools',
					R.a className: 'collapse', href: 'javascript:;'

			R.div className: 'grid-body no-border', style: {padding:'0px'}, @props.children