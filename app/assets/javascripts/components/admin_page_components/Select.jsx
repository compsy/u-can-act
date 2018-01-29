class Select extends React.Component {
  constructor(props) {
    super(props);
    this.uuid = this.uuid();
  }
  generateSelect(items) {
    let selectorOptions = items.map((option) => {
      return (
        <option key={option}>{option}</option>
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
    var select = $('#' + this.uuid);
    select.material_select(this._onChange.bind(this));
  }

  componentDidUpdate() {
    this.redraw();
  }

  componentDidMount() {
    this.redraw();
  }

  _onChange(e) {
    var selected_option = $('#' + this.uuid).find(":selected").text()
    this.props.onChange(selected_option);
  }

  render() {
    var options = this.generateSelect(this.props.options);
    return(
      <div className="input-field">
        <select id={this.uuid} defaultValue={this.props.value} >
          {options}
        </select>
        <label>{this.props.label}</label>
      </div>
    )
  }
}
