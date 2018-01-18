class AdminRouter extends React.Component {
  constructor(props) {
    super(props);
    this.auth = new Auth()
    this.state = {
      result: undefined
    };
  }

  handleAuthentication(nextState, replace) {
    if (/access_token|id_token|error/.test(nextState.location.hash)) {
      this.auth.handleAuthentication();
    }
  }

  render() {
    var Route = ReactRouter.Route;
    var Router = ReactRouterDOM.BrowserRouter;
    var self = this;

    return (
      <Router>
        <div>
          <Route exact path="/admin" render={(props) => {
            return <AdminPage auth={this.auth} {...props} /> 
          }}/>

          // Create clientside route for the auth-0 callback
          <Route path="/admin/callback" render={(props) => {
            self.handleAuthentication(props);
            return <Callback {...props} /> 
          }}/>
        </div>
      </Router>
    );
  }
}
