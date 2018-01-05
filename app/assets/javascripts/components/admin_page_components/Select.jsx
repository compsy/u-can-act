class Select extends React.Component {
  generateSelect(items) {
    let selectorOptions = items.map((option) => {
      return (
        <option key={option}>{option}</option>
      )
    })
    selectorOptions.unshift(<option key="def" value="def" disabled>Choose your option</option>)

    return (selectorOptions)
  }

  componentDidMount() {
    $(document).ready(function() {
      $('select').material_select();
    });
  }

  render() {
    var options = this.generateSelect(this.props.options)
    return(
      <div className="input-field">
        <select onChange={this.props.onChange} >
          {options}
        </select>
        <label>{this.props.label}</label>
      </div>
    )
  }
}
