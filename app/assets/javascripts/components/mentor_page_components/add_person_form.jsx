class AddPersonForm extends React.Component {

  handleOnChange(e) {
    this.props.handleOnChange(e.target.name, e.target.value, this.props.formId);
  }

  render() {
    return (
      <div className="col s12">
        <div className="row">
          <div className="input-field col m3 s12">
            <input id="first_name" name="firstName" value={this.props.values.firstName} type="text" class="validate"  onChange={this.handleOnChange.bind(this)}/>
            <label for="first_name">First Name</label>
          </div>
          <div className="input-field col m3 s12">
            <input id="last_name" name="lastName" value={this.props.values.lastName} type="text" class="validate"  onChange={this.handleOnChange.bind(this)}/>
            <label for="last_name">Last Name</label>
          </div>
          <div className="input-field col m3 s12">
            <input id="mobile_phone" name="mobilePhone" value={this.props.values.mobilePhone} type="text" class="validate"  onChange={this.handleOnChange.bind(this)} />
            <label for="mobile_phone">Mobile phone</label>
          </div>
          <div className="input-field col m3 s12">
            <input id="protocol" name="protocol" value={this.props.values.protocol} type="text" class="validate"  onChange={this.handleOnChange.bind(this)}/>
            <label for="protocol">Protocol</label>
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
    protocol: undefined
  },
  formId: undefined
};
