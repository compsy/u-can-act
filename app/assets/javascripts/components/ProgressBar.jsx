class ProgressBar extends React.Component {
  render() {
    return (
      <div>
        <div className='section'>
          <p className='flow-text'> Voortgang van het onderzoek</p>
        </div>
        <div className='section'>
          <div className='progress'>
            <div className='determinate' style={{width: this.props.progress_perc+'%'}}>
            </div>
          </div>
          <div className='row'>
            <div className='col s12'>
              Het onderzoek is voor {this.props.progress_perc}% voltooid. Er zijn
              nog {this.props.awardable} punten te verdienen.
            </div>
          </div>
        </div>
      </div>
    )
  }
}
