R = React.DOM

@SimpleGrid = React.createClass

	render: ->
		R.div className: 'grid simple h-scroll dragme',
			R.div className: 'grid-title border-only-bot',
				R.h4 null, @props.title
				R.div className: 'tools',
          if @props.showHZoomIcon
            R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
              R.i className: 'fa fa-arrows-h fa-lg', onClick: @props.onClick
			R.div className: 'grid-body no-border', style: @props.style, @props.children
