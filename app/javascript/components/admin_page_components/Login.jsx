import React from 'react'

export default class Login extends React.Component {
  login() {
    this.props.auth.login();
  }

  logout() {
    this.props.auth.logout();
  }

  loginLogoutButton(isAuthenticated) {
    if (!isAuthenticated) {
      return (
        <a className="waves-effect waves-light btn login-button" onClick={this.login.bind(this)} >
          Log In 
        </a>
      )
    } 
    return (
      <a className="waves-effect waves-light btn login-button" onClick={this.logout.bind(this)} >
        Log Out
      </a>
    )
  }

  render() {
    const isAuthenticated = this.props.auth.isAuthenticated();

    return (
      <div>
        {this.loginLogoutButton(isAuthenticated)}
      </div>
    );
  }
}
