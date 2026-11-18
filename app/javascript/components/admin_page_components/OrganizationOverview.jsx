import React from 'react';
import TeamOverview from './TeamOverview';
import Login from './Login';

export default class OrganizationOverview extends React.Component {
  render() {
    if (!this.props.auth.isAuthenticated()) {
      return (
        <div>
          <p>You need to authenticate first.</p>
          <Login auth={this.props.auth} />
        </div>
      );
    }
    return (
      <div>
        <TeamOverview />
      </div>
    );
  }
}
