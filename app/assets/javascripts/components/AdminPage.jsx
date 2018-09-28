class AdminPage extends React.Component {
  render() {
    var isAuthenticated = this.props.auth.isAuthenticated();
    return ( 
      <div>
        <Login auth={this.props.auth} />
      </div>
    )
  }
}
