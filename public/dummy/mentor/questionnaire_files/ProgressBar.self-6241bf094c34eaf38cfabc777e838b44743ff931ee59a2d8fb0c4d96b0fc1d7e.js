var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ProgressBar = (function (_React$Component) {
  _inherits(ProgressBar, _React$Component);

  function ProgressBar(props) {
    _classCallCheck(this, ProgressBar);

    _get(Object.getPrototypeOf(ProgressBar.prototype), 'constructor', this).call(this, props);
    this.state = {
      timer: null,
      radial: null
    };
  }

  _createClass(ProgressBar, [{
    key: 'componentDidMount',
    value: function componentDidMount() {
      var timer = setInterval(this.performTimerEvent.bind(this), 1500);
      var radial = this.renderGraph(this.props.valueEuro, this.props.percentageStreak, this.props.awardableEuro, this.props.totalAvailable);

      this.setState({
        timer: timer,
        radial: radial,
        showStreakText: false
      });
    }
  }, {
    key: 'calculateInitialValue',
    value: function calculateInitialValue() {
      var initialValue = this.props.valueEuro;
      if (this.props.currentMultiplier > 0) {
        initial_value -= this.props.euroDelta;
        initial_value += this.props.euroDelta / this.props.currentMultiplier;
      }
      return initialValue;
    }
  }, {
    key: 'componentWillUnmount',
    value: function componentWillUnmount() {
      this.clearInterval(this.state.timer);
    }
  }, {
    key: 'performTimerEvent',
    value: function performTimerEvent() {
      this.renderGraph(this.props.valueEuro, this.props.percentageStreak);
      this.setState({
        showStreakText: true
      });
      clearInterval(this.state.timer);
    }
  }, {
    key: 'renderGraph',
    value: function renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {

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
            labelStart: '★',
            value: percentageStreak,
            color: '#079975'
          }, {
            labelStart: '€',
            value: valueEuro,
            color: '#243a76'
          }],
          center: {
            content: ['Je hebt nu', function (value) {
              return printAsMoney(value);
            }, ' daar kan nog ' + printAsMoney(awardable) + ' bij!'],
            y: -50
          }
        });
      }
      return radial;
    }
  }, {
    key: 'createStreakText',
    value: function createStreakText() {
      if (this.state.showStreakText && this.props.currentMultiplier > 1) {
        var value = this.props.euroDelta - this.props.euroDelta / this.props.currentMultiplier;
        var text = "Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je ";
        text += printAsMoney(value);
        text += " extra verdiend!";
        return React.createElement(
          'div',
          { className: 'animated pulse' },
          ' ',
          text,
          ' '
        );
      }
    }
  }, {
    key: 'render',
    value: function render() {
      return React.createElement(
        'div',
        { className: 'row' },
        React.createElement(
          'div',
          { className: 'col m6 push-m3' },
          React.createElement('div', { className: 'progressRadial' }),
          this.createStreakText()
        )
      );
    }
  }]);

  return ProgressBar;
})(React.Component);

ProgressBar.defaultProps = {
  valueEuro: 0,
  percentageStreak: 0,
  awardableEuro: 0,
  totalAvailable: 0
};