@Hello = React.createClass
	
	Alert: ->
		alert 'Nice'

	render: ->
		React.DOM.div className: "shit", 
			React.DOM.div className: "anotherShit",
				React.DOM.h1 null, "Okay"
  	