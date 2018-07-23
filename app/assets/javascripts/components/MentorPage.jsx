class MentorPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      lastId: -1,
      personForms: [],
      showProcessingMessage: false
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
      lastId: id,
      showProcessingMessage: false
    });
  }

  handleSavePeople() {
    console.log(this.state);
    this.setState({
      personForms: [],
      showProcessingMessage: true,
      lastId: -1
    })
  }

  processingMessage(){
    if (this.state.showProcessingMessage && this.state.personForms.length === 0) {
      return (
        <div className="card-panel green">
          <span className="white-text">
            Nieuwe studenten worden toegevoegd.
          </span>
        </div>
      )
    }
  }

  render() {
    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            {this.processingMessage()}
            {this.state.personForms.map(FormToRender => <FormToRender.form values={FormToRender.values} formId={FormToRender.id} handleOnChange={ this.handleOnChange.bind(this) }/>)}
            <div className="col s12">
              <div className="row">
                <SavePeopleButton numberOfForms={this.state.personForms.length} handleOnClick={this.handleSavePeople.bind(this)} />
                <AddPersonFormButton numberOfForms={this.state.personForms.length} handleOnClick={this.handleAddPerson.bind(this)} />
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
