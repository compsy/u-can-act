class AdminPage extends React.Component {

  renderAdminPage(isAuthenticated) {
    if (isAuthenticated) {
      return (
        <TeamOverview />
      )
    }
  }


  render() {
    var isAuthenticated = this.props.auth.isAuthenticated();
    return ( 
      <div>
        <Login auth={this.props.auth} />
        {this.renderAdminPage(isAuthenticated)}
      </div>
    )
  }
}
