class RewardPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      result: undefined
    };
  }

  componentDidMount() {
    this.loadRewardData(this.props.protocolSubscriptionId);
  }

  componentWillReceiveProps(nextProps){
    this.loadRewardData(nextProps.protocolSubscriptionId);
  }

  loadRewardData(protocolSubscriptionId) {
    var self = this
    
    // Only update if the subscription id has changed
    let url = '/api/v1/rewards/' + protocolSubscriptionId;
    $.getJSON(url, (response) => {
      self.setState({
        result: response
      })
    });
  }

  render() {
    if (!this.state.result) {
        return <div>Bezig...</div>
    }

    let awardable_points = this.state.result.max_reward_points - this.state.result.possible_reward_points
    return (
      <div>
        <RewardMessage reward_delta={this.props.reward_delta} reward_points={this.state.result.reward_points} />
        <ProgressBar progress_perc={this.props.progress_perc} awardable={awardable_points} />
      </div>
    )
  }
}
