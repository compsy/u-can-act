class SavePeopleButton extends React.Component {
  render() {
    if (this.props.numberOfForms <= 0) {
      return <div />
    }
    return (
      <div className="col s6">
        <a className="waves-effect waves-light btn" onClick={this.props.handleOnClick}>
          {this.props.numberOfForms == 1 ? 'Student' : 'Studenten' } opslaan
        </a>
      </div>
    )
  }
}
