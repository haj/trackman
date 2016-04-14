R = React.DOM

module.exports = React.createClass

	render: ->
		R.div className: 'grid simple dragme',
			R.div className: 'grid-title border-only-bot',
				R.h4 null, @props.title
				R.div className: 'tools',
          if @props.showHZoomIcon
            R.a className: 'config sizeMapFull-icon', style: {cursor: 'pointer'},
              R.i className: 'fa fa-arrows-h fa-lg', onClick: @props.onClick
          if @props.showGeneratePdf
            R.button {className: "btn btn-danger btn-small btn-xs", onClick: @props.generatePdf, 'data-toggle': "tooltip", 'data-placement': "left", title: "Save as PDF"},
              R.span {className: "fa fa-download"}

			R.div className: 'grid-body no-border', style: @props.style, @props.children
