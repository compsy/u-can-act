class StudentInProgressRewardPage extends React.Component {
  constructor(props) {
    super(props);

    let currentStreak = this.findCurrentStreak();
    this.inMaxStreak = (currentStreak === this.props.maxStreak);
    this.totalAvailable = this.props.earnedEuros + this.props.awardable;

    // Rescale the percentage to the totalAvailable money.
    this.percentageStreak = (currentStreak / this.props.maxStreak) * this.totalAvailable;
  }

  findCurrentStreak() {
    // Find the last non future index. 
    // Note that findIndex could return -1 if the value is not found. 
    var percentageStreakIdx = this.props.protocolCompletion.findIndex(elem => (elem.future));
    percentageStreakIdx = percentageStreakIdx === -1 ? this.props.protocolCompletion.length : percentageStreakIdx;
    percentageStreakIdx -= 1;

    // Make sure the streak value does not exceed the maximum possible streak value
    return Math.max(Math.min(this.props.protocolCompletion[percentageStreakIdx].streak, this.props.maxStreak), 0);
  }

  render() {
    return (
      <div>
        <RewardMessage euroDelta={this.props.euroDelta} earnedEuros={this.props.earnedEuros} />
        <div className='section'>
          {this.inMaxStreak ? <Pyro /> : <div/>}
          <ProgressBar euroDelta={this.props.euroDelta}
                        valueEuro={this.props.earnedEuros}
                        currentMultiplier={this.props.currentMultiplier}
                        initialMultiplier={this.props.initialMultiplier}
                        percentageStreak={this.percentageStreak}
                        awardableEuro={this.props.awardable}
                        totalAvailable={this.totalAvailable}/>
        </div>
      </div>
    )
  }
}

