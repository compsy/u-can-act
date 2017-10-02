class RewardMessage extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='section'>
        <p className="flow-text"> Je hebt hiermee {this.props.reward_delta} punten verdiend.
      Je hebt nu in totaal <strong>{this.props.reward_points}</strong> punten</p>
      </div>
    )
  }
}
