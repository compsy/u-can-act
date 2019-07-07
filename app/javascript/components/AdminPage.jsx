import React from 'react'
import Login from './admin_page_components/Login'

export default class AdminPage extends React.Component {
  render() {
    return (
      <div>
        <Login auth={this.props.auth} />
      </div>
    );
  }
}
