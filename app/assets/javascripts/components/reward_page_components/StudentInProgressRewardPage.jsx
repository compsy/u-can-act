class StudentInProgressRewardPage extends React.Component {
  constructor(props) {
    super(props);

    let currentStreak = this.findCurrentStreak(this.props.protocolCompletion, this.props.maxStreak);
    this.inMaxStreak = (currentStreak === this.props.maxStreak);
    this.totalAvailable = this.props.earnedEuros + this.props.awardable;

    // Rescale the percentage to the totalAvailable money.
    this.percentageStreak = (currentStreak / this.props.maxStreak) * this.totalAvailable;
  }

  findCurrentStreak(protocolCompletion, maxStreak) {
    // Find the last non future index.
    // Note that findIndex could return -1 if the value is not found.
    var percentageStreakIdx = protocolCompletion.findIndex(elem => (elem.future));
    percentageStreakIdx = percentageStreakIdx === -1 ? protocolCompletion.length : percentageStreakIdx;
    percentageStreakIdx -= 1;

    // Fallback: if no streak / only future measurements exist, return zero.
    // This should never happen, but makes the code more robust.
    if (percentageStreakIdx < 0) {
      return 0;
    }

    // Make sure the streak value does not exceed the maximum possible streak value
    return Math.max(Math.min(protocolCompletion[percentageStreakIdx].streak, maxStreak), 0);
  }

  render() {
    return (
      <div>
        <h4>Bedankt voor het invullen van de vragenlijst!</h4>
        <RewardMessage euroDelta={this.props.euroDelta} earnedEuros={this.props.earnedEuros} />
        <div className='section'>
          <ProgressBar  inMaxStreak={this.inMaxStreak}
                        euroDelta={this.props.euroDelta}
                        valueEuro={this.props.earnedEuros}
                        currentMultiplier={this.props.currentMultiplier}
                        initialMultiplier={this.props.initialMultiplier}
                        percentageStreak={this.percentageStreak}
                        awardableEuro={this.props.awardable}
                        totalAvailable={this.totalAvailable}/>
        </div>
        <RewardFooter person={this.props.person}/>
      </div>
    );
  }
}
