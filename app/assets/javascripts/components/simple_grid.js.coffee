R = React.DOM

module.exports = React.createClass
  datePicker: ->
    R.input { type: 'text', className: 'datepicker', placeholder: 'Click to Select Date For Car Logs' }

  render: ->
    R.div className: 'grid simple dragme',
      R.div className: 'grid-title border-only-bot',
        if @props.title == '...'
          @datePicker()
        else
          R.h4 null, @props.title
        R.div className: 'tools',
          if @props.showGeneratePdf
            R.button {className: "btn btn-danger btn-small btn-xs", onClick: @props.generatePdf, 'data-toggle': "tooltip", 'data-placement': "left", title: "Save as PDF"},
              R.span {className: "fa fa-download"}

      R.div className: 'grid-body no-border', style: @props.style, @props.children
