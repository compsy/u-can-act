import React from 'react'
import Pyro from './Pyro'
import printAsMoney from '../printAsMoney'
import RadialProgressChart from 'radial-progress-chart'

export default class ProgressBar extends React.Component {

  constructor(props) {
    super(props);
    this.totalAvailableColor = '#079975';
    this.valueEuroColor = '#243a76';
    this.state = {
      timer: null,
      showStreakDetails: false,
      radial: null
    };
  }

  componentDidMount() {
    let timer = setInterval(this.performTimerEvent.bind(this), 1500);
    let radial = this.renderGraph(
      this.calculateInitialValue(this.props.valueEuro,
        this.props.euroDelta,
        this.props.initialMultiplier,
        this.props.currentMultiplier),
      this.props.percentageStreak,
      this.props.awardableEuro,
      this.props.totalAvailable
    );

    this.setState({
      timer: timer,
      radial: radial,
    });
  }

  componentWillUnmount() {
    clearInterval(this.state.timer);
  }

  calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier) {
    if (currentMultiplier <= 0) {
      return initialValue;
    }

    const multiplier = (delta / currentMultiplier) * initialMultiplier;
    return initialValue - delta + multiplier;
  }

  performTimerEvent() {
    this.setState({
      radial: this.renderGraph(this.props.valueEuro, this.props.percentageStreak),
      showStreakDetails: this.props.inMaxStreak,
    })
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    let radial;
    if (this.state.radial) {
      radial = this.state.radial;
      radial.update({
        series: [{
          value: percentageStreak
        }, {
          value: valueEuro
        }]
      });
    } else {
      radial = new RadialProgressChart('.progressRadial', {
        diameter: 250,
        max: totalAvailable,
        round: true,
        series: [{
          labelStart: '\u2605',
          value: percentageStreak,
          color: this.totalAvailableColor
        }, {
          labelStart: '€',
          value: valueEuro,
          color: this.valueEuroColor
        }],
        center: {
          content: ['Je hebt nu',
            function(value, _unused, series) {
              // Only update the label when the euro value is being displayed
              if (series.index == 1) {
                return printAsMoney(value)
              }
              return printAsMoney(valueEuro)
            }, 'je kunt nog ' + printAsMoney(awardable) + ' verdienen!'
          ],
          y: -50
        }
      });
    }
    return (radial)
  }

  createStreakText() {
    if (this.state.showStreakDetails && this.props.currentMultiplier > 1) {
      let value = (this.props.euroDelta / this.props.currentMultiplier);
      let defaultValue = value * this.props.initialMultiplier;
      let currentBonus = this.props.euroDelta - defaultValue;
      let text = "Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je ";
      text += printAsMoney(currentBonus);
      text += " extra verdiend!";
      return (<div className="animated pulse"> {text} </div>)
    }
  }

  render() {
    return (
      <div>
        {this.state.showStreakDetails ? <Pyro /> : <div/>}
        <div className='row'>
          <div className='col l6 push-l3 m8 push-m2 s12'>
            <div className="progressRadial" />
            {this.createStreakText()}
          </div>
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
