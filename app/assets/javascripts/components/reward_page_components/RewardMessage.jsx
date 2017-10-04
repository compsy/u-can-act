class RewardMessage extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='section'>
        <p className="flow-text"> Je hebt hiermee {this.props.euroDelta} euro verdiend.
      Je hebt nu in totaal <strong>{this.props.earnedEuros}</strong> euro</p>
      </div>
    )
  }
}
