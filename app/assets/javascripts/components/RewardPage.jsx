class RewardPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      result: undefined,
      person: undefined
    };
  }

  componentDidMount() {
    this.loadRewardData(this.props.protocolSubscriptionId);
    this.loadCurrentPerson();
  }

  isDone() {
    return !this.state.result.protocol_completion.some((entry) => {
      return entry.future
    })
  }

  loadCurrentPerson() {
    var self = this

    // Only update if the subscription id has changed
    let url = '/api/v1/person/me';
    $.getJSON(url, (response) => {
      self.setState({
        person: response
      })
    });
  }

  loadRewardData(protocolSubscriptionId) {
    var self = this

    // Only update if the subscription id has changed
    let url = '/api/v1/protocol_subscriptions/' + protocolSubscriptionId;
    $.getJSON(url, (response) => {
      self.setState({
        result: response
      })
    });
  }

  getCorrectResultPage() {
    if (this.state.result.person_type === 'Mentor') {
      if (!this.isDone()) {
        return <div />
      }
      return (<MentorRewardPage />)
    }

    let earnedEuros = this.state.result.earned_euros / 100;
    if (this.isDone()) {
      return (<StudentFinalRewardPage earnedEuros={earnedEuros} />)
    }

    let euroDelta = this.state.result.euro_delta / 100;
    let maxStillAwardableEuros = this.state.result.max_still_awardable_euros / 100;
    return (
      <StudentInProgressRewardPage euroDelta={euroDelta} 
        earnedEuros={earnedEuros}
        currentMultiplier={this.state.result.current_multiplier}
        initialMultiplier={this.state.result.initial_multiplier}
        awardable={maxStillAwardableEuros}
        protocolCompletion={this.state.result.protocol_completion}
        maxStreak={this.state.result.max_streak.threshold}/>
    )
  }

  render() {
    if (!this.state.result || !this.state.person) {
      return <div>Bezig...</div>
    }

    result = this.getCorrectResultPage()
    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            <h4>Bedankt voor het invullen van de vragenlijst!</h4>
            {result}
            <ul>
              <li><a href='/disclaimer'>Disclaimer</a></li>
              {/* <li><EditPersonLink person={this.state.person}/></li> */}
            </ul>
          </div>
        </div>
      </div>
    )
  }
}
