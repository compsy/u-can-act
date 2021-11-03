import React from 'react';
import Pyro from './Pyro';
import { printAsMoney } from '../Helpers';
import RadialProgressChart from 'radial-progress-chart';

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
    const delay = 1500
    let timer = setInterval(this.performTimerEvent.bind(this), delay);
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
    const nothing = 0;
    if (currentMultiplier <= nothing) {
      return initialValue;
    }

    const multiplier = (delta / currentMultiplier) * initialMultiplier;
    return initialValue - delta + multiplier;
  }

  performTimerEvent() {
    this.setState({
      radial: this.renderGraph(this.props.valueEuro, this.props.percentageStreak),
      showStreakDetails: this.props.inMaxStreak,
    });
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    let radial = {};
    const firstElement = 1;
    // Because the progress radial only works with integers, since we have amounts of 50 cents,
    // we have multiply everytyhing by 2 and then divide by 2 when we show it.
    if (this.state.radial) {
      radial = this.state.radial;
      radial.update({
        series: [
          {
            value: percentageStreak * 2
          }, {
            value: valueEuro * 2
          }
        ]
      });
    } else {
      radial = new RadialProgressChart('.progressRadial', {
        diameter: 250,
        max: totalAvailable * 2,
        round: true,
        series: [ {
          labelStart: '\u2605',
          value: percentageStreak * 2,
          color: this.totalAvailableColor
        }, {
          labelStart: '\u2714',

          // labelStart: '€',
          value: valueEuro * 2,
          color: this.valueEuroColor
        } ],
        center: {
          content: [ 'Je hebt nu',
            (value, _unused, series) => {
              // Only update the label when the euro value is being displayed
              if (series.index === firstElement) {
                return printAsMoney(value / 2);
              }
              return printAsMoney(valueEuro);
            }
          ],
          y: -30
        }
      });
    }
    return radial;
  }

  createStreakText() {
    const minimalNumberOfMultipliers = 1;
    if (this.state.showStreakDetails && this.props.currentMultiplier > minimalNumberOfMultipliers) {
      let value = this.props.euroDelta / this.props.currentMultiplier;
      let defaultValue = value * this.props.initialMultiplier;
      let currentBonus = this.props.euroDelta - defaultValue;
      let text = 'Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je';
      text = `${text} ${printAsMoney(currentBonus)}`;
      text = `${text} extra verdiend!`;
      return <div className='animated pulse'> {text} </div>;
    }
    return <div />;
  }

  render() {
    return (
      <div>
        {this.state.showStreakDetails ? <Pyro /> : <div />}
        <div className='row'>
          <div className='col l6 push-l3 m8 push-m2 s12'>
            <div className='progressRadial' />
            {this.createStreakText()}
          </div>
        </div>
      </div>
    );
  }
}

ProgressBar.defaultProps = {
  valueEuro: 0,
  percentageStreak: 0,
  awardableEuro: 0,
  totalAvailable: 0
};
