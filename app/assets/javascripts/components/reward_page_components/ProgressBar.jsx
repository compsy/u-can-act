class ProgressBar extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      timer: null,
      radial: null
    };
  }

  componentDidMount() {
    let timer = setInterval(this.performTimerEvent.bind(this), 1500);
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
    this.renderGraph(this.props.valueEuro, this.props.percentageStreak)
    this.setState({
      showStreakText: true
    })
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {

    var radial;
    if (this.state.radial) {
      radial = this.state.radial;
      radial.update([percentageStreak, valueEuro]);
    } else {
      radial = new RadialProgressChart('.progressRadial', {
        diameter: 200,
        max: totalAvailable,
        round: true,
        series: [{
          labelStart: '\u2605',
          value: percentageStreak,
          color: '#079975'
        }, {
          labelStart: '€',
          value: valueEuro,
          color: '#243a76'
        }, ],
        center: {
          content: ['Je hebt nu',
            function(value) {
              return printAsMoney(value)
            }, ' daar kan nog ' + printAsMoney(awardable) + ' bij!'
          ],
          y: -50
        }
      });
    }
    return (radial)
  }

  createStreakText() {
    if (this.state.showStreakText && this.props.currentMultiplier > 1) {
      let value = this.props.euroDelta - this.props.euroDelta / this.props.currentMultiplier
      let text = "Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je ";
      text += printAsMoney(value);
      text += " extra verdiend!";
      return (<div className="animated pulse"> {text} </div>)
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

ProgressBar.defaultProps = {
  valueEuro: 0,
  percentageStreak: 0,
  awardableEuro: 0,
  totalAvailable: 0
};
