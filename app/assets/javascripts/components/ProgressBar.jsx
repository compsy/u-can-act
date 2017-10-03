class ProgressBar extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {

    if (!this.props.measurementCompletion) {
      return 'Busy...';
    }

    index = this.props.measurementCompletion.findIndex(elem => (elem == -1))
    percentageStreakIdx = index === 0 ? 0 : index -1;
    percentageStreak = this.props.measurementCompletion[percentageStreakIdx]
    this.renderGraph(parseInt(this.props.progress_perc), percentageStreak, parseInt(this.props.awardable))
  }

  renderGraph(percentageEuro, percentageStreak, awardable) {
    new RadialProgressChart('.progressRadial', {
      diameter: 200,
      max: 100,
      round: true,
      series: [
        {labelStart: '\u2605', value: percentageStreak, color: '#079975'},
        {labelStart: '€', value: percentageEuro, color: '#243a76'},
      ],
      center: {
        content: [function(value) {
          return '€'+value
        }, ' van €'+(percentageEuro + awardable)+',-'],
        y: 25
      }
    });
  }

  render() {
    return (
      <div>
        <div className='section'>
          <p className='flow-text'> Voortgang van het onderzoek</p>
        </div>
        <div className='section'>
          <div className='row'>
            <div className='col m6 push-m3'>
              <div className="progressRadial" />
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

