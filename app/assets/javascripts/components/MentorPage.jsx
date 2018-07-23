class MentorPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      lastId: -1,
      personForms: [],
    };
  }

  handleOnChange(name, value, id) {

    var forms = this.state.personForms
    var form = forms.find(x => x.id === id)
    form.values[name] = value;
    forms[id] = form;

    this.setState({
      personForms: forms
    });
  }

  handleAddPerson() {
    var forms = this.state.personForms;

    var id = this.state.lastId + 1;
    forms.push({
      form: AddPersonForm,
      values: {
        firstName: undefined,
        lastName: undefined,
        mobilePhone: undefined,
        protocol: undefined
      },
      id: id
    });

    this.setState({
      personForms: forms,
      lastId: id
    });
  }

  addPersonFormButton() {
    return (
      <div className="col s6">
        <a className="waves-effect waves-light btn" onClick={this.handleAddPerson.bind(this)}>
          {this.state.personForms.length < 1 ? 'Student toevoegen' : 'Nog een student toevoegen' }
        </a>
      </div>
    );
  }

  handleSavePeople() {
    console.log(this.state);
  }

  savePeopleButton() {
    if (this.state.personForms.length > 0) {
      return (
        <div className="col s6">
          <a className="waves-effect waves-light btn" onClick={this.handleSavePeople.bind(this)}>
            {this.state.personForms.length == 1 ? 'Student' : 'Studenten' } opslaan
          </a>
        </div>
      )
    }
  }

  render() {
    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            {this.state.personForms.map(FormToRender => <FormToRender.form values={FormToRender.values} formId={FormToRender.id} handleOnChange={ this.handleOnChange.bind(this) }/>)}
            <div className="col s12">
              <div className="row">
                {this.savePeopleButton()}
                {this.addPersonFormButton()}
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
