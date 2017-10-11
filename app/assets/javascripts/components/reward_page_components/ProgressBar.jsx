class ProgressBar extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      timer: null,
      radial: null
    };
  }

  componentDidMount() {
    let timer = setInterval(this.performTimerEvent.bind(this), 500);
    let radial = this.renderGraph(
      this.props.valueEuro,
      this.props.percentageStreak,
      this.props.awardableEuro,
      this.props.totalAvailable
    )

    this.setState({
      timer: timer,
      radial: radial,
      showStreakText: false,
    });
  }


  // Idea::
  // Initially set current euros to earned euros - euro_delta + euro_delta / current_multiplier
  // Then, after a second, update the value to earned_euros (so it is the total.
  // We could write the (euro_delta - euro_delta / current_multiplier)
  // somewhere as 'youve earned X using the streak you're currently in!'

  calculateInitialValue() {
    var initialValue = this.props.valueEuro
    if (this.props.currentMultiplier > 0) {
      initial_value -= this.props.euroDelta;
      initial_value += this.props.euroDelta / this.props.currentMultiplier;
    }
    return initialValue
  }

  componentWillUnmount() {
    this.clearInterval(this.state.timer);
  }

  performTimerEvent() {
    this.renderGraph(this.props.valueEuro)
    this.setState({showStreakText: true})
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    var radial;
    if (this.state.radial) {
      radial = this.state.radial;
      // First is 0 so we only update the euros, not the streak
      radial.update([0, valueEuro]);
    } else {
      radial = new RadialProgressChart('.progressRadial', {
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
    return(radial)
  }

  createStreakText() {
    if (this.state.showStreakText && this.props.currentMultiplier > 0) {
      let value = this.props.euroDelta - this.props.euroDelta / this.props.currentMultiplier
      let text = "Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je €";
      text += value;
      text += " extra verdiend!";
     return(<div className="animated fadeInLeft"> {text} </div>) 
    }
  }

  render() {
    return (
      <div className='row'>
        <div className='col m6 push-m3'>
          <div className="progressRadial" />
          {this.createStreakText()}
        </div>
      </div>
    )
  }
}

