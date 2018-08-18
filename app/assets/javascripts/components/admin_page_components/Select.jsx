class Select extends React.Component {
  generateSelectOptions(items) {
    let selectorOptions = items.map((option) => {
      if (typeof option != 'object') {
        return (
          <option name={option} key={option} value={option}>{option}</option>
        )
      }
      return (
        <option name={option.text} key={option.value} value={option.value}>{option.text}</option>
      )
    })
    selectorOptions.unshift(<option key="def" value="def" disabled>Selecteer</option>)

    return (selectorOptions)
  }

  redraw() {
    var select = $('#' + this.props.uuid);
    select.material_select(this._onChange.bind(this));
  }

  componentDidUpdate() {
    this.redraw();
  }

  componentDidMount() {
    this.redraw();

    // Trigger an onchange here so the surrounding component will have the
    // correct props selected in this component
    this._onChange();
  }

  getSelectedOption() {
    return $('#' + this.props.uuid).val();
  }

  _onChange(e) {
    this.props.onChange(this.getSelectedOption(), this.props.name);
  }

  render() {
    var options = this.generateSelectOptions(this.props.options);
    return(
      <div className="input-field">
        <select id={this.props.uuid} defaultValue={this.props.value} >
          {options}
        </select>
        <label>{this.props.label}</label>
      </div>
    )
  }
}
