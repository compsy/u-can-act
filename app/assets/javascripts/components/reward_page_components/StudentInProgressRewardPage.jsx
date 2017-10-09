class StudentInProgressRewardPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      valueEuro: undefined, 
      percentageStreak: undefined,
      awardableEuro: undefined,
      totalAvailable: undefined,
      maxStreak: undefined,
      max_streak: false
    };
  }

  componentDidMount() {
    // Find the last non future index
    var percentageStreakIdx = this.props.protocolCompletion.findIndex(elem => (elem.future));
    percentageStreakIdx = percentageStreakIdx === 0 ? 0 : percentageStreakIdx -1;

    let valueEuro = this.props.earnedEuros;
    let awardableEuro = this.props.awardable;
    let totalAvailable = valueEuro + awardableEuro;

    //TODO: This should be made dynamic.
    let maxStreak = 5;
    let currentStreak =  Math.min(this.props.protocolCompletion[percentageStreakIdx].streak, maxStreak);
    let inMaxStreak = (currentStreak === maxStreak) 

    percentageStreak =  (currentStreak / maxStreak) * totalAvailable;

    this.setState({
      valueEuro:  valueEuro, 
      percentageStreak: percentageStreak,
      awardableEuro: awardableEuro,
      totalAvailable: totalAvailable,
      maxStreak: inMaxStreak
    })
  }

  render() {
    return (
      <div>
        <RewardMessage euroDelta={this.props.euroDelta} earnedEuros={this.props.earnedEuros} />
        <div>
          <div className='section'>
            <p className='flow-text'> Voortgang van het onderzoek</p>
          </div>
          <div className='section'>
            {this.state.maxStreak ? <Pyro /> : <div/>}
            <ProgressBar valueEuro={this.state.valueEuro}
                        percentageStreak={this.state.percentageStreak}
                        awardableEuro={this.state.awardableEuro}
                        totalAvailable={this.state.totalAvailable}/>
            <ProgressText earned_euros={this.state.earnedEuros}
                        awardable={this.state.awardableEuro}
                        protocolCompletion={this.props.protocolCompletion} />
          </div>
        </div>
      </div>
    )
  }
}

