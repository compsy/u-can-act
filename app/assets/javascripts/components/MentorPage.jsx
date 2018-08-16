class MentorPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      lastId: -1,
      personForms: [],
      showProcessingMessage: false,
      roles: []
    };
  }

  componentWillMount(props) {
    this.loadRoles();
    this.loadProtocols();
  }

  handleOnChange(name, value, id) {
    var forms = this.state.personForms
    var form = forms.find(x => x.id === id)
    form.values[name] = value;
    forms[id] = form;

    console.log(forms);
    this.setState({
      personForms: forms
    });
  }

  loadRoles() {
    // TODO: Move to vsv_api_js
    var self = this;
    fetch('/api/v1/role', {
      method: "GET", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
    }).then(response => {
      return response.json()
    }).then(data => {
      data = data.map((entry) => {
        return { text: entry.title, value: entry.uuid }
      });
      self.setState({
        roles: data
      })
    }).catch(error => console.error(error));
  }

  loadProtocols() {
    // TODO: Move to vsv_api_js
    var self = this;
    fetch('/api/v1/protocol', {
      method: "GET", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
    }).then(response => {
      return response.json()
    }).then(data => {
      data = data.map((entry) => {
        return { text: entry.name, value: entry.uuid }
      });
      self.setState({
        protocols: data
      })
    }).catch(error => console.error(error));
  }

  storeSupervisedStudent(values) {
    // TODO: Move to vsv_api_js
    fetch('/api/v1/supervised_person', {
      method: "POST", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: JSON.stringify(values), // body data type must match "Content-Type" header
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
        protocol_uuid: undefined,
        role_uuid: undefined
      },
      generalAttributes: {
        roles: this.state.roles,
        protocols: this.state.protocols
      },
      id: id
    });

    this.setState({
      personForms: forms,
      lastId: id,
      showProcessingMessage: false
    });
  }

  buildSupervisedStudentJson(formValues) {
    var person = {
      first_name: formValues.firstName,
      last_name: formValues.lastName,
      gender: formValues.gender,
      mobile_phone: formValues.mobilePhone,
    }

    var protocol = {
      uuid: formValues.protocol_uuid
    }

    var role = {
      uuid: formValues.role_uuid
    }

    return {
      person: person,
      protocol: protocol,
      role: role
    };
  }

  handleSavePeople() {
    var self = this;
    var formValues = undefined;
    this.state.personForms.forEach(function(entry) {
      formValues = self.buildSupervisedStudentJson(entry.values);
    });

    this.storeSupervisedStudent(formValues);
    if (false) {
      // Reset the state
      this.setState({
        personForms: [],
        showProcessingMessage: true,
        lastId: -1
      })
    }
  }

  render() {
    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            <Message message='Nieuwe studenten worden toegevoegd.' shouldShow={ this.state.showProcessingMessage && this.state.personForms.length === 0 } />
            {this.state.personForms.map(FormToRender => <FormToRender.form values={FormToRender.values} generalAttributes={FormToRender.generalAttributes} formId={FormToRender.id} key={FormToRender.id} handleOnChange={ this.handleOnChange.bind(this) }/>)}
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
