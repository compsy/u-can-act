class AddPersonFormButton extends React.Component {
  render() {
    return (
      <div className="col s6">
        <a className="waves-effect waves-light btn" onClick={this.props.handleOnClick}>
          {this.props.numberOfForms < 1 ? 'Student toevoegen' : 'Nog een student toevoegen' }
        </a>
      </div>
    );
  }
}
