import React from 'react'

export default class Select extends React.Component {
  constructor(props) {
    super(props);
    this._uuid = this.uuid();
  }

  generateSelectOptions(items) {
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
      const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  redraw() {
    const select = $('#' + this._uuid);
    select.formSelect().change(this._onChange.bind(this));
  }

  componentDidUpdate() {
    this.redraw();
  }

  componentDidMount() {
    this.redraw();
  }

  getSelectedOption() {
    return $('#' + this._uuid).find(":selected").text();
  }

  _onChange(e) {
    this.props.onChange(this.getSelectedOption());
  }

  render() {
    const options = this.generateSelectOptions(this.props.options);
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
