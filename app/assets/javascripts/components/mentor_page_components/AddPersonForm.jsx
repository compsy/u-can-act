class AddPersonForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      student: 'Student'
    };
  }

  handleOnChange(e) {
    this.props.handleOnChange(e.target.name, e.target.value, this.props.formId);
  }


  handleOnDropdownChange(e, name) {
    this.props.handleOnChange(name, e, this.props.formId);
  }

  handleOnFirstNameChange(e) {
    this.setState({
      student: e.target.value
    });
    this.props.handleOnChange(e.target.name, e.target.value, this.props.formId);
  }

  render() {
    return (
      <div className="col s12">
          <h3> {this.state.student} toevoegen </h3>
        <div className="row">
          <div className="col m3 s12">
            <TextField id="first_name" name="firstName" label='First Name' value={this.props.values.firstName} type="text" class="validate"  onChange={this.handleOnFirstNameChange.bind(this)}/>
          </div>
          <div className="col m3 s12">
            <TextField id="last_name" name="lastName" label='Last Name' value={this.props.values.lastName} type="text" class="validate"  onChange={this.handleOnChange.bind(this)}/>
          </div>
          <div className="col m3 s12">
            <TextField id="mobile_phone" name="mobilePhone" value={this.props.values.mobilePhone} label='Mobile phone'  onChange={this.handleOnChange.bind(this)} />
          </div>
          <div className="col m3 s12">
            <MaterializeUniqueIDComponent SubComponent={Select} name='roleUuid' value={this.props.values.roleUuid} options={this.props.generalAttributes.roles} label='Rol' onChange={this.handleOnDropdownChange.bind(this)} />
          </div>
          <div className="col m6 s12">
            <MaterializeUniqueIDComponent SubComponent={Select} name='supervisionTrajectoryUuid' value={this.props.values.supervisionTrajectoryUuid} options={this.props.generalAttributes.supervisionTrajectories} label='Begeleidingstrajecten' onChange={this.handleOnDropdownChange.bind(this)} />
          </div>
          <div className="col m3 s12">
            <MaterializeUniqueIDComponent SubComponent={DateField} id="start_date" name="startDate" value={this.props.values.startDate} label='Start date' onChange={this.handleOnChange.bind(this)} />
          </div>
          <div className="col m3 s12">
            <MaterializeUniqueIDComponent SubComponent={DateField} id="end_date" name="endDate" value={this.props.values.endDate} label='End date' onChange={this.handleOnChange.bind(this)} />
          </div>
        </div>
      </div>
    )
  }
}

AddPersonForm.defaultProps = {
  values: {
    firstName: undefined,
    lastName: undefined,
    mobilePhone: undefined,
    supervisionTrajectoryUuid: undefined,
    roleUuid: undefined,
    startDate: undefined,
    endDate: undefined
  },
  roles: [],
  supervisionTrajectories: [],
  formId: undefined
};
