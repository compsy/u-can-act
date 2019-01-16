import React from 'react'
import printAsMoney from '../printAsMoney'

// NOTE: This class is not used anywhere in the code right now.
export default class ProgressText extends React.Component {

  calculateProgess(protocolCompletion) {
    let completion = protocolCompletion.reduce((sum, value) => {
      return sum += value.future ? 0 : 1;
    },0);
    return Math.round((completion / protocolCompletion.length) * 100);
  }

  render() {
    let percentageCompleted = this.calculateProgess(this.props.protocolCompletion);
    return (
      <div className='row'>
        <div className='col s12'>
          Het onderzoek is voor {percentageCompleted}% voltooid. Er zijn nog {printAsMoney(this.props.awardable)} te verdienen.
        </div>
      </div>
    );
  }
}
