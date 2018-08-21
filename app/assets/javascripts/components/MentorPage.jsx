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
    this.listRoles();
    this.listSupervisionTrajectories();
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

  listRoles() {
    // TODO: Use from vsv_api_js
    var self = this;
    fetch('/api/v1/role', {
      method: "GET", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
    }).then(response => {
      return response.json()
    }).then(data => {
      data = data.map((entry) => {
        return {
          text: entry.title,
          value: entry.uuid
        }
      });
      self.setState({
        roles: data
      })
    }).catch(error => console.error(error));
  }

  listSupervisionTrajectories() {
    // TODO: Use from vsv_api_js
    var self = this;
    fetch('/api/v1/supervision_trajectory', {
      method: "GET", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
    }).then(response => {
      return response.json()
    }).then(data => {
      data = data.map((entry) => {
        return {
          text: entry.name,
          value: entry.uuid
        }
      });
      self.setState({
        supervisionTrajectories: data
      })
    }).catch(error => console.error(error));
  }

  storeSupervisedStudent(values) {
    // TODO: Use from vsv_api_js
    return fetch('/api/v1/supervised_person', {
      method: "POST", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, cors, *same-origin
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: JSON.stringify(values), // body data type must match "Content-Type" header
    })
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
        supervisionTrajectoryUuid: undefined,
        roleUuid: undefined,
        startDate: undefined,
        endDate: undefined,
      },
      generalAttributes: {
        roles: this.state.roles,
        supervisionTrajectories: this.state.supervisionTrajectories
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
      start_date: formValues.startDate,
      end_date: formValues.endDate
    }

    var supervision_trajectory = {
      uuid: formValues.supervisionTrajectoryUuid
    }

    var role = {
      uuid: formValues.roleUuid
    }

    return {
      person: person,
      protocol: protocol,
      supervision_trajectory: supervision_trajectory,
      role: role
    };
  }

  handleSavePeople() {
    var self = this;
    var formValues = undefined;
    this.state.personForms.forEach(function(entry) {
      formValues = self.buildSupervisedStudentJson(entry.values);
    });

    this.storeSupervisedStudent(formValues).then(function(response) {
      if (response.status === 201) {
        // Reset the state
        self.setState({
          personForms: [],
          showProcessingMessage: true,
          lastId: -1,
          warnings: undefined
        })
      } else {
        response.json().then((parsedResponse) => {
          console.log(parsedResponse);
          self.setState({
            warnings: parsedResponse.errors
          })
        });
      }
    }).catch(error => console.error(error));
  }

  render() {
    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            <WarningMessage message={this.state.warnings} />
            <Message message='Nieuwe studenten worden toegevoegd.' shouldShow={ this.state.showProcessingMessage && this.state.personForms.length === 0 } />
            {this.state.personForms.map((FormToRender) => 
              <FormToRender.form values={FormToRender.values} generalAttributes={FormToRender.generalAttributes} formId={FormToRender.id} key={FormToRender.id} handleOnChange={ this.handleOnChange.bind(this) }/>)}
            <div className="col s12">
              <div className="row">
                <SavePeopleButton numberOfForms={this.state.personForms.length}
                                  handleOnClick={this.handleSavePeople.bind(this)} />
                <AddPersonFormButton numberOfForms={this.state.personForms.length}
                                     handleOnClick={this.handleAddPerson.bind(this)} />
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
