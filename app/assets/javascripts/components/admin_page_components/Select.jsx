class Select extends React.Component {
  constructor(props) {
    super(props);
    this._uuid = this.uuid();
  }

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

  uuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  redraw() {
    var select = $('#' + this._uuid);
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
    return $('#' + this._uuid).val();
  }

  _onChange(e) {
    this.props.onChange(this.getSelectedOption(), this.props.name);
  }

  render() {
    var options = this.generateSelectOptions(this.props.options);
    return(
      <div className="input-field">
        <select id={this._uuid} defaultValue={this.props.value} >
          {options}
        </select>
        <label>{this.props.label}</label>
      </div>
    )
  }
}
