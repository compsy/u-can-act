class ProgressText extends React.Component {

  calculateProgess(protocolCompletion) {
    let completion = protocolCompletion.reduce((sum, value) => {
      if(!value.future){
        sum += 1;
      }
      return sum;
    },0)
    console.log(completion)
    return Math.round((completion / protocolCompletion.length) * 100);
  }

  render() {
    let percentageCompleted = this.calculateProgess(this.props.protocolCompletion)
    return (
      <div className='row'>
        <div className='col s12'>
          Het onderzoek is voor {percentageCompleted}% voltooid. Er is nog €{this.props.awardable} te verdienen.
        </div>
      </div>
    )
  }
}
