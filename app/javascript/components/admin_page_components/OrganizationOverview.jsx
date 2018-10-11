import React from 'react'
import TeamOverview from './TeamOverview'

export default class OrganizationOverview extends React.Component {
  render() {
    if (!this.props.auth.isAuthenticated()) {
      return (
        <div>
          <p>You need to authenticate first.</p>
        </div>
      )
    }
    return (
      <div>
        <TeamOverview />
      </div>
    )
  }
}
