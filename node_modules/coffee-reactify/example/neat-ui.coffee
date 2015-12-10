React = require 'react'

RadComponent = require './rad-component'

console.log React.renderToStaticMarkup React.createElement(RadComponent, rad: 'mos def')
