import React from 'react'
import printAsMoney from '../printAsMoney'
export default class ProgressText extends React.Component {

  calculateProgess(protocolCompletion) {
    let completion = protocolCompletion.reduce((sum, value) => {
      return sum += value.future ? 0 : 1;
    },0);
    return Math.round((completion / protocolCompletion.length) * 100);
  }

  render() {
    let percentageCompleted = this.calculateProgess(this.props.protocolCompletion)
    return (
      <div className='row'>
        <div className='col s12'>
          Het onderzoek is voor {percentageCompleted}% voltooid. Er is nog {printAsMoney(this.props.awardable)} te verdienen.
        </div>
      </div>
    )
  }
}
