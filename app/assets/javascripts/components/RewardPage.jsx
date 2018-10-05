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
    var self = this;

    // Only update if the subscription id has changed
    let url = '/api/v1/protocol_subscriptions/' + protocolSubscriptionId;
    $.getJSON(url, (response) => {
      self.setState({
        result: response
      })
    });
  }

  renderMentorRewardPage() {
    if (!this.isDone()) {
      return (<div/>);
    }
    return (<MentorRewardPage person={this.state.person}/>);
  }

  renderSoloRewardPage() {
    if (!this.isDone()) {
      return (<div/>);
    }
    return (<SoloRewardPage/>);
  }

  renderStudentRewardPage() {
    let earnedEuros = this.state.result.earned_euros;
    let name = this.state.person.first_name + ' ' + this.state.person.last_name;
    if (this.isDone()) {
      return (<StudentFinalRewardPage earnedEuros={earnedEuros}
                                      iban={this.state.person.iban}
                                      person={this.state.person}
                                      name={name}/>);
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
                                   maxStreak={this.state.result.max_streak.threshold}
                                   person={this.state.person}/>
    );
  }

  getCorrectResultPage() {
    if (this.state.result.person_type === 'Mentor') {
      return this.renderMentorRewardPage();
    }
    if (this.state.result.person_type === 'Solo') {
      return this.renderSoloRewardPage();
    }
    return this.renderStudentRewardPage();
  }

  render() {
    if (!this.state.result || !this.state.person) {
      return <div>Bezig...</div>
    }

    return (
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            {this.getCorrectResultPage()}
          </div>
        </div>
      </div>
    )
  }
}
