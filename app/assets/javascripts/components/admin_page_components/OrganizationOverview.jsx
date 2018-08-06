class OrganizationOverview extends React.Component {
  render() {
    if (!this.props.auth.isAuthenticated()) {
      return (
        <div> You need to authenticate first.</div>
      )
    }
    return (
      <div>
        <TeamOverview />
      </div>
    )
  }
}
