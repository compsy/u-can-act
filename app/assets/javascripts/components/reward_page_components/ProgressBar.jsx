class ProgressBar extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    if (!this.props.protocolCompletion) {
      return 'Busy...';
    }

    // Find the last non -1 index
    var percentageStreakIdx = this.props.protocolCompletion.findIndex(elem => (elem == -1));
    percentageStreakIdx = percentageStreakIdx === 0 ? 0 : percentageStreakIdx -1;


    let valueEuro = this.props.earned_euros;
    let awardableEuro = this.props.awardable;
    let totalAvailable = valueEuro + awardableEuro;

    //TODO: This should be made dynamic.
    let maxStreak = 5;
    let percentageStreak = Math.min(this.props.protocolCompletion[percentageStreakIdx], maxStreak);

    percentageStreak =  (percentageStreak / maxStreak) * totalAvailable;
    this.renderGraph(valueEuro, percentageStreak, awardableEuro, totalAvailable)
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    new RadialProgressChart('.progressRadial', {
      diameter: 200,
      max: totalAvailable,
      round: true,
      series: [
        {labelStart: '\u2605', value: percentageStreak, color: '#079975'},
        {labelStart: '€', value: valueEuro, color: '#243a76'},
      ],
      center: {
        content: [ 'Je hebt nu',
          function(value) {
          return '€'+value
        }, ' daar kan nog €'+(awardable) + ' bij!'],
        y: -50
      }
    });
  }

  render() {
    return (
      <div className='row'>
        <div className='col m6 push-m3'>
          <div className="progressRadial" />
        </div>
      </div>
    )
  }
}

