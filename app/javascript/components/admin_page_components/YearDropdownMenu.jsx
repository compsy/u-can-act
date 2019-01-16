import React from 'react'
import Select from './Select'

export default class YearDropdownMenu extends React.Component {
  generateYears() {
    const start = 2017;
    const end = new Date().getFullYear();
    const years = [];
    for (let i = start; i <= end; i++) {
      years.push(i);
    }
    return (years);
  }

  render() {
    const years = this.generateYears();
    return (
      <Select value={this.props.value} options={years} label='Year' onChange={this.props.onChange}/>
    );
  }
}
