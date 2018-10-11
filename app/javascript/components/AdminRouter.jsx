import React from 'react'
import { Route } from 'react-router'
import { BrowserRouter} from 'react-router-dom'

import AdminPage from './AdminPage'
import OrganizationOverview from './admin_page_components/OrganizationOverview'
import Callback from './Callback'
import Auth from './Auth'

export default class AdminRouter extends React.Component {
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
    return (
      <BrowserRouter>
        <div>
          <Route exact path="/admin" render={(props) => {
            return <AdminPage auth={this.auth} {...props} /> 
          }}/>
          <Route path="/admin/organization_overview" render={(props) => {
            return <OrganizationOverview auth={this.auth} {...props} /> 
          }}/>
          <Route path="/admin/callback" render={(props) => {
            this.handleAuthentication(props);
            return <Callback {...props} /> 
          }}/>
        </div>
      </BrowserRouter>
    );
  }
}
