class StudentInProgressRewardPage extends React.Component {
  render() {
    return (
      <div>
        <RewardMessage euroDelta={this.props.euroDelta} earnedEuros={this.props.earnedEuros} />
        <div>
          <div className='section'>
            <p className='flow-text'> Voortgang van het onderzoek</p>
          </div>
          <div className='section'>
            <ProgressBar earned_euros={this.props.earnedEuros}
                        awardable={this.props.awardable}
                        protocolCompletion={this.props.protocolCompletion} />
            <ProgressText awardable={this.props.awardable}
                        protocolCompletion={this.props.protocolCompletion}/>
          </div>
        </div>
      </div>
    )
  }
}

