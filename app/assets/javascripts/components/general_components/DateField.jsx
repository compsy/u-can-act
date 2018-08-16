class DateField extends React.Component {

  render() {
    return (
      <div className="input-field">
        <input id={this.props.id} name={this.props.name} value={this.props.value} type="text" className="datepicker" onChange={this.props.onChange}/>
        <label htmlFor={this.props.id}>{this.props.label}</label>
      </div>
    )
  }
}
