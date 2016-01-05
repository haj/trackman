Router = ReactRouter.Router
Route = ReactRouter.Route

Home = require('./home')
Hello = require('../hello')

module.exports =
  <Router>
    <Route path="/" component={Home}>
      <Route path="1" component={Hello} />
    </Route>
  </Router>
